package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class TriangleSlidingState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		
		private var bottomCount:int;
		
		protected var enterTime:int;
		
		public function TriangleSlidingState(self:Player)
		{
			this.self = self;
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			switch (collisionSide)
			{
				case CollisionData.COLLISION_SIDE_LEFT:
					if (!self.isAnimationInProgress(Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1))
						self.playAnimation(Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1, null, true);
			
					self.rigidBody.addForce(GameData.FORCE_REACTION_SLIDE_LEFT);
					break;
				case CollisionData.COLLISION_SIDE_RIGHT:
					if (!self.isAnimationInProgress(Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2))
						self.playAnimation(Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2, null, true);
						
					self.rigidBody.addForce(GameData.FORCE_REACTION_SLIDE_RIGHT);
					break;
				case CollisionData.COLLISION_SIDE_BOTTOM:
					++bottomCount;
					if (bottomCount >= 5)
						self.changeState(PlayerStates.STATE_PLAYER_IDLE);
					break;
			}
		}
		
		public function onData(key:int, value:int):void
		{
			
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			bottomCount = 0;
			
			SoundManager.instance.playSound(SoundsData.PLAYER_SLIDE, 9999, 1 * SoundsData.MUTE_SOUND);
			
			self.jumpCount = 0;
			
			enterTime = getTimer();
		}
		
		public function exit():void
		{
			self.rigidBody.velocity.x = 0;
			self.rigidBody.velocity.y = 0;
			
			self.rigidBody.forces.x = 0;
			self.rigidBody.forces.y = 0;
			
			SoundManager.instance.stopSound(SoundsData.PLAYER_SLIDE);
			
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
		}
		
		public function update(diff:Number):void
		{
			if (self.rigidBody.velocity.y >= 0.4)
			{
				++self.jumpCount;
				if (LevelManager.instance.level.hasInput(Controls.CONTROL_LEFT | Controls.CONTROL_RIGHT))
					self.changeState(PlayerStates.STATE_PLAYER_FALLING_STRAFE);
				else
					self.changeState(PlayerStates.STATE_PLAYER_FALLING);
			}
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_SLIDING_TRIANGLE;
		}
	}
}