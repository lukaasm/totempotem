package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class IdleState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		
		protected var enterTime:int;
		
		public function IdleState(self:Player) 
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
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] onData(" + key + ", " + value + ") ");
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
						
			enterTime = getTimer();
			
			self.jumpCount = 0;
			
			self.playAnimation(Animations.ANIMATION_PLAYER_IDLE);
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
		}
		
		public function update(diff:Number):void
		{
			self.rigidBody.velocity.x = 0;
			
			if (self.rigidBody.velocity.y >= 0.3)
			{
				++self.jumpCount;
				self.changeState(PlayerStates.STATE_PLAYER_FALLING);
			}
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_IDLE;
		}
	}
}