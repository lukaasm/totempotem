package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.utils.getTimer;
	import starling.core.*;

	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.level.*;
	import pl.fabrykagier.totempotem.managers.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class FallingState implements IState, IPlayerState
	{
		protected var stateMachine:StateMachine;
		protected var self:Player;
		
		protected var enterTime:int;
		
		public function FallingState(self:Player) 
		{
			this.self = self;
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] onCollision(" + invoker + ", " + collisionSide + ")");
			
			if (collisionSide == CollisionData.COLLISION_SIDE_BOTTOM)
				self.changeState(PlayerStates.STATE_PLAYER_IDLE);
		}
		
		public function onData(key:int, value:int):void
		{
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			enterTime = getTimer();
			
			//self.rigidBody.velocity.x = 0;
			
			if (self.isAnimationInProgress(Animations.ANIMATION_PLAYER_FALL))
				return;
				
			self.playAnimation(Animations.ANIMATION_PLAYER_FALL);
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
		}
		
		public function update(diff:Number):void
		{
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_FALLING;
		}
	}
}