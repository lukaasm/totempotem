package pl.fabrykagier.totempotem.states.playerstates
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class SlidingState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		
		protected var enterTime:int;
		
		public function SlidingState(self:Player)
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
			
			//SoundManager.instance.playSound(SoundsData.PLAYER_SLIDE, 0, 1 * SoundsData.MUTE_SOUND);
			
			if (!self.isAnimationInProgress(Animations.ANIMATION_PLAYER_SLIDE))
				self.playAnimation(Animations.ANIMATION_PLAYER_SLIDE, null, false);
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
			
			//SoundManager.instance.stopSound(SoundsData.PLAYER_SLIDE);
		}
		
		public function update(diff:Number):void
		{
			self.slide();
			if (self.rigidBody.velocity.y >= 0.2)
			{
				++self.jumpCount;
				self.changeState(PlayerStates.STATE_PLAYER_FALLING);
			}
			else if (Math.abs(self.rigidBody.velocity.x) <= 0.02)
				self.changeState(PlayerStates.STATE_PLAYER_IDLE);
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_SLIDING;
		}
	}
}