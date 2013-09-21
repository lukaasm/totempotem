package pl.fabrykagier.totempotem.states.playerstates 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Controls;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	
	public class StrafeJumpingState extends JumpingState 
	{
		public function StrafeJumpingState(self:Player)   
		{
			super(self);
		}
		
		public override function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (collisionSide == CollisionData.COLLISION_SIDE_BOTTOM)
			{
				var velocity:Number = self.rigidBody.velocity.x;
				
				self.changeState(PlayerStates.STATE_PLAYER_MOVING);
				self.rigidBody.velocity.x = velocity;
			}
		}
		
		public override function enter():void
		{
			super.enter();
			
			//self.rigidBody.velocity.x = 0;
		}
		
		public override function update(diff:Number):void
		{
			self.strafe();
			
			if (self.rigidBody.velocity.y >= 0.2)
			{
				var isStrafing:Boolean = LevelManager.instance.level.hasInput(Controls.CONTROL_LEFT | Controls.CONTROL_RIGHT);
				if (!isStrafing)
					self.changeState(PlayerStates.STATE_PLAYER_FALLING);
				else
				{
					var velocity:Number = self.rigidBody.velocity.x;
					self.changeState(PlayerStates.STATE_PLAYER_FALLING_STRAFE);
					self.rigidBody.velocity.x = velocity;
				}
			}
		}
		
		public override function get name():String
		{
			return PlayerStates.STATE_PLAYER_JUMPING_STRAFE;
		}
	}
}