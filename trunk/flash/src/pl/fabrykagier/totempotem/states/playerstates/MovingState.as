package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class MovingState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		
		private var enterTime:int;
		
		public function MovingState(self:Player) 
		{
			this.self = self;
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function onData(key:int, value:int):void
		{
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");

			enterTime = getTimer();
			
			self.rigidBody.velocity.x = 0;
			self.jumpCount = 0;
			
			SoundManager.instance.playSound(SoundsData.PLAYER_RUN, 9999, 1 * SoundsData.MUTE_SOUND);
			
			if (!self.isAnimationInProgress(Animations.ANIMATION_PLAYER_MOVE))
				self.playAnimation(Animations.ANIMATION_PLAYER_MOVE);
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
			SoundManager.instance.stopSound(SoundsData.PLAYER_RUN);
		}
		
		public function update(diff:Number):void
		{
			self.strafe();
			
			if (self.rigidBody.velocity.y >= 0.2)
			{
				++self.jumpCount;
				self.changeState(PlayerStates.STATE_PLAYER_FALLING_STRAFE);
			}
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_MOVING;
		}
	}
}