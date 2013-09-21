package pl.fabrykagier.totempotem.states.playerstates 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Controls;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	
	public class StrafeFallingState extends FallingState 
	{
		public function StrafeFallingState(self:Player) 
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
			
			self.rigidBody.velocity.x = 0;
		}
		
		public override function update(diff:Number):void
		{
			self.strafe();
			
			super.update(diff);
		}
		
		public override function get name():String
		{
			return PlayerStates.STATE_PLAYER_FALLING_STRAFE;
		}
	}

}