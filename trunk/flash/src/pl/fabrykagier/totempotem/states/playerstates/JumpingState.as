package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class JumpingState implements IState, IPlayerState 
	{
		protected var stateMachine:StateMachine;
		protected var self:Player;
		
		protected var enterTime:int;
		
		public function JumpingState(self:Player) 
		{
			this.self = self;
			
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (collisionSide == CollisionData.COLLISION_SIDE_BOTTOM)
				self.changeState(PlayerStates.STATE_PLAYER_IDLE);
		}
		
		public function onData(key:int, value:int):void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] onData(" + key + ", " + value + ") ");
			
			if (self.jumpCount >= GameData.PLAYER_MAX_JUMP_COUNT)
				return;

			++self.jumpCount;
			
			if (self.jumpCount > 1)
				self.doubleJump();
			else
				SoundManager.instance.playSound(SoundsData.PLAYER_JUMP, 0, 0.3 * SoundsData.MUTE_SOUND);

			self.rigidBody.velocity.y = 0;
			self.rigidBody.addForce(GameData.FORCE_JUMP);
			
			self.stopAnimation();
			self.playAnimation(Animations.ANIMATION_PLAYER_JUMP, null, false);
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] jump count: " + self.jumpCount);
			
			enterTime = getTimer();			
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
		}
		
		public function update(diff:Number):void
		{
			if (Math.abs(self.rigidBody.velocity.x) >= 0.02)
				self.slide();
				
			if (self.rigidBody.velocity.y >= 0.0)
				self.changeState(PlayerStates.STATE_PLAYER_FALLING);
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_JUMPING;
		}
	}
}