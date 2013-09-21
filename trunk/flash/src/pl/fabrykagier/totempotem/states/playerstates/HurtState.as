package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.managers.*;
	import pl.fabrykagier.totempotem.physics.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class HurtState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		private var stopPositionY:int;
		private var hurt:Function;
		private var selfRigidbody:RigidBody;
		
		protected var enterTime:int;
		
		public function HurtState(self:Player) 
		{
			this.self = self;
			
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
				
			hurt = null;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function onData(key:int, value:int):void
		{
			
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "["+PlayerStates.STATE_PLAYER_HURT+"] enter() ");
			
			enterTime = getTimer();
			
			SoundManager.instance.playSound(SoundsData.PLAYER_HIT, 0, 30 * SoundsData.MUTE_SOUND);
			
			self.playAnimation(Animations.ANIMATION_PLAYER_TAKE_DAMAGE, onHurtAnimationEnd, false);
			hurt = start;
		}
		
		private function onHurtAnimationEnd():void
		{
			if (self.life.lives <= 0)
				self.changeState(PlayerStates.STATE_PLAYER_DYING);
			else
			{
				self.changeState(PlayerStates.STATE_PLAYER_FALLING);
			}
		}
		
		private function start():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_EFFECTS, 
					"[" + PlayerStates.STATE_PLAYER_HURT + "] starting death effect");
					
			selfRigidbody = self.rigidBody;
			stopPositionY = self.stage.stageHeight + self.height;
			
			hurt = moveUp;
		}
		
		private function moveUp():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_EFFECTS, 
					"[" + PlayerStates.STATE_PLAYER_HURT + "] moveUp death effect");
			
			if (selfRigidbody != null)
			{
				selfRigidbody.velocity.x = 0;
				selfRigidbody.velocity.y = 0;
				selfRigidbody.addForce(new Vector3D(GameData.FORCE_MOVE_LEFT.x * 7, GameData.FORCE_JUMP.y, 0));
				hurt = null;
			}
		}
		
		private function moveDown():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_EFFECTS, 
					"[" + PlayerStates.STATE_PLAYER_HURT + "] moveDown death effect");
			
			if (selfRigidbody != null)
			{
				if (selfRigidbody.position.y  > stopPositionY)
				{
					if (self.life.lives > 0)
						self.reset();
					
					hurt = null;
				}
			}
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "["+PlayerStates.STATE_PLAYER_HURT+"] exit() ");
		}
		
		public function update( diff:Number ):void
		{
			if(hurt != null)
				hurt();
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_HURT;
		}
	}
}