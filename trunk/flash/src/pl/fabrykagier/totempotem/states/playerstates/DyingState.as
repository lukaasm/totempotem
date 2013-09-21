package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.managers.*;
	import pl.fabrykagier.totempotem.physics.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class DyingState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		private var stopPositionY:int;
		private var death:Function;
		private var selfRigidbody:RigidBody;
		
		protected var enterTime:int;
		
		public function DyingState(self:Player) 
		{
			this.self = self;
			
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
				
			death = null;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function onData(key:int, value:int):void
		{
			
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "["+PlayerStates.STATE_PLAYER_DYING+"] enter() ");
			
			enterTime = getTimer();
			
			SoundManager.instance.playSound(SoundsData.PLAYER_DEATH, 0, 1 * SoundsData.MUTE_SOUND);
			
			self.playAnimation(Animations.ANIMATION_PLAYER_DIE, null, false);
			CollisionManager.instance.unregister(ICollidable(self));
			death = start;
		}
		
		private function start():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_EFFECTS, 
					"[" + PlayerStates.STATE_PLAYER_DYING + "] starting death effect");
					
			selfRigidbody = self.rigidBody;
			stopPositionY = self.stage.stageHeight + self.height;
			
			death = moveUp;
		}
		
		private function moveUp():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_EFFECTS, 
					"[" + PlayerStates.STATE_PLAYER_DYING + "] moveUp death effect");
			
			if (selfRigidbody != null)
			{
				selfRigidbody.velocity.y = 0;
				selfRigidbody.addForce(GameData.FORCE_JUMP);
				death = moveDown;
			}
		}
		
		private function moveDown():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_EFFECTS, 
					"[" + PlayerStates.STATE_PLAYER_DYING + "] moveDown death effect");
			
			if (selfRigidbody != null)
			{
				if (selfRigidbody.position.y  > stopPositionY)
				{
					if (self.life.lives > 0)
						self.reset();
					else
						GameManager.instance.showPopup(Popups.POPUP_GAMEOVER);
					
					death = null;
				}
			}
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "["+PlayerStates.STATE_PLAYER_DYING+"] exit() ");
		}
		
		public function update( diff:Number ):void
		{
			if(death != null)
				death();
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_DYING;
		}
	}
}