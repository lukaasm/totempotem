package pl.fabrykagier.totempotem.behaviours 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.collisions.BoundingSphere;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.physics.RigidBody;
	import starling.display.Shape;
	
	public class TransportBehaviour implements IBehaviour 
	{
		private var passengers:Vector.<GameObject>;
		private var lastPos:Point;
		private var owner:GameObject;
		private var directionDiff:Point;
		
		public function TransportBehaviour(owner:GameObject) 
		{
			passengers = new Vector.<GameObject>();
			lastPos = new Point(0, 0);
			directionDiff = new Point(0, 0);
			this.owner = owner;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (collisionSide == CollisionData.COLLISION_SIDE_BOTTOM)
				insertPassenger(GameObject(invoker));
			else if (collisionSide == CollisionData.COLLISION_SIDE_LEFT && directionDiff.x > 0)
				insertPassenger(GameObject(invoker));
			else if (collisionSide == CollisionData.COLLISION_SIDE_RIGHT && directionDiff.x < 0)
				insertPassenger(GameObject(invoker));
			else if (collisionSide == CollisionData.COLLISION_SIDE_LEFT && directionDiff.x < 0)
				removePassenger(GameObject(invoker));
			else if (collisionSide == CollisionData.COLLISION_SIDE_RIGHT && directionDiff.x > 0)
				removePassenger(GameObject(invoker));
		}
		
		private function insertPassenger(invoker:GameObject):void
		{
			if (passengers.indexOf(invoker) < 0)
			{
				Debug.log(Debug.DEBUG_VERBOSE_PLATFORM_BEHAVIOURS, "[TRANSPORT] INSERT");
				passengers.push(invoker);
			}
		}
		
		private function removePassenger(invoker:GameObject):void
		{
			if (passengers.indexOf(invoker) >= 0)
			{
				Debug.log(Debug.DEBUG_VERBOSE_PLATFORM_BEHAVIOURS, "[TRANSPORT] REMOVE");
				passengers.splice(passengers.indexOf(invoker), 1);
			}
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
			if (invoker is GameObject)
				removePassenger(GameObject(invoker));
		}
		
		public function update(diff:Number):void
		{
			calculateDirectionDiff();
			moveObjectsWithPlatform();
		}
		
		private function calculateDirectionDiff():void
		{
			directionDiff.x = owner.x - lastPos.x;
			directionDiff.y = owner.y - lastPos.y;
			
			lastPos.x = owner.x;
			lastPos.y = owner.y;
		}
		
		private function moveObjectsWithPlatform():void
		{
			for each(var passenger:GameObject in passengers)
			{
				var passengerRigidbody:RigidBody = passenger.rigidBody;
				
				if (passengerRigidbody != null)
				{
					passengerRigidbody.position.x += int(directionDiff.x);
					passengerRigidbody.position.y += int(directionDiff.y);
				}
				else
				{
					passenger.x += int(directionDiff.x);
					passenger.y += int(directionDiff.y);
				}
			}
		}
	}
}