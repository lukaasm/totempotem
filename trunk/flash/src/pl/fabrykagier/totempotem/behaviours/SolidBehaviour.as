package pl.fabrykagier.totempotem.behaviours 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.collisions.BoundingSphere;
	import pl.fabrykagier.totempotem.collisions.BoundingTriangle;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Controls;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.core.Starling;
	import starling.display.Shape;
	
	public class SolidBehaviour implements IBehaviour, ICollidable 
	{
		private var owner:GameObject;
		
		private var group:String;
		
		private var shape:Shape;
		private var offset:Point;
		private var collisionCount:Dictionary;
		
		public function SolidBehaviour(owner:GameObject, offset:Point, size:Point, group:String, shape:String = "", flip:Boolean = false) 
		{
			this.owner = owner;
			this.group = group;
			
			this.offset = offset;
			
			var position:Point = new Point(owner.position.x + offset.x, owner.position.y + offset.y);
		
			switch (shape)
			{
				case "circle":
					this.shape = new BoundingSphere(position, int(size.x+size.y)/2);
					break
				case "triangle":
					this.shape = new BoundingTriangle(position, size.x, size.y, flip);
					break
				default:
					this.shape = new BoundingBox(position, size.x, size.y);
					break
			}
		}
		
		public function get boundingShape():Shape
		{
			shape.x = int(owner.position.x + offset.x);
			shape.y = int(owner.position.y + offset.y);
			
			return shape;
		}
		
		public function get collisionGroup():String
		{
			return group;
		}
		
		private function hitBoxHandler(invoker:ICollidable, collisionSide:int):void
		{
			var playerShape:Shape = invoker.boundingShape;
			var invokerShape:Shape = this.boundingShape;
			
			var player:Player = Player(invoker);
			if (player.isDying())
				return;
				
			var line:Vector.<Point> = BoundingSphere(playerShape).closestLine(invokerShape);

			var center:Point = new Point(playerShape.x, playerShape.y);
			var point:Point = Utils.closestPointToLine(line[0], line[1], center);
			
			var minX:Number = int(invokerShape.x - invokerShape.width / 2);
			var minY:Number = int(invokerShape.y - invokerShape.height / 2);
	
			var maxX:Number = int(invokerShape.x + invokerShape.width / 2);
			var maxY:Number = int(invokerShape.y + invokerShape.height / 2);
		
			var offset:int = 1;
			switch (collisionSide)
			{
				case CollisionData.COLLISION_SIDE_TOP:
					if (player.rigidBody.velocity.y < 0)
						player.rigidBody.velocity.y = 0;
						
					player.rigidBody.position.y = maxY + int(playerShape.height / 2) + offset;
					break;
				case CollisionData.COLLISION_SIDE_BOTTOM:
					if (player.rigidBody.velocity.y > 0)
						player.rigidBody.velocity.y = 0;
							
					player.jumpCount = 0;
					player.rigidBody.position.y = minY - int(playerShape.height / 2);
					break;
				case CollisionData.COLLISION_SIDE_LEFT:
					if (player.rigidBody.velocity.x < 0)
						player.rigidBody.velocity.x = 0;
				
					player.rigidBody.addForce(GameData.FORCE_REACTION_RIGHT);
					player.rigidBody.position.x = int(maxX - GameObject(invoker).parent.x + playerShape.width / 2) + offset;
					break;
				case CollisionData.COLLISION_SIDE_RIGHT:
					if (player.rigidBody.velocity.x > 0)
						player.rigidBody.velocity.x = 0;
						
					player.rigidBody.addForce(GameData.FORCE_REACTION_LEFT);
					player.rigidBody.position.x = int(minX - GameObject(invoker).parent.x - playerShape.width / 2) - offset;
					break;
			}
		}
		
		private function hitTriangleHandler(invoker:ICollidable, collisionSide:int):void
		{
			var playerShape:BoundingSphere = BoundingSphere(invoker.boundingShape);
			var invokerShape:BoundingTriangle = BoundingTriangle(this.boundingShape);
			
			if (!playerShape.intersects(invokerShape))
				return;
				
			var player:Player = Player(invoker);
			if (player.isDying())
				return;
				
			var minX:Number = int(invokerShape.x - invokerShape.width / 2);
			var minY:Number = int(invokerShape.y - invokerShape.height / 2);
	
			var maxX:Number = int(invokerShape.x + invokerShape.width / 2);
			var maxY:Number = int(invokerShape.y + invokerShape.height / 2);
		
			var line:Vector.<Point> = BoundingSphere(playerShape).closestLine(invokerShape);
			var sub:int = 20;

			var midX:int = owner.position.x;

			var center:Point = new Point(playerShape.x, playerShape.y);
			var point:Point = Utils.closestPointToLine(line[0], line[1], center);
			
			var t:Point = center;
			var dist:Number = int(playerShape.radius - Point.distance(center, point));
			var angle:Number = Math.atan2(point.y - center.y, point.x - center.x);
			
			switch (collisionSide)
			{
				case CollisionData.COLLISION_SIDE_TOP:
					if (player.rigidBody.velocity.y < 0)
						player.rigidBody.velocity.y = 0;
					
					player.rigidBody.position.x -= int(Math.cos(angle) * dist);
					player.rigidBody.position.y -= int(Math.sin(angle) * dist);
					break;
				case CollisionData.COLLISION_SIDE_BOTTOM:
					if (player.rigidBody.velocity.y > 0)
						player.rigidBody.velocity.y = 0;
					
					if (!invokerShape.flipped)
						player.rigidBody.position.x -= int(Math.cos(angle) * (dist + 20));
						
					player.rigidBody.position.y -= int(Math.sin(angle) * dist);
					break;
				case CollisionData.COLLISION_SIDE_LEFT:
					player.rigidBody.position.y -= int(Math.sin(angle) * dist);
					player.rigidBody.position.x -= int(Math.cos(angle) * dist);
					
					player.rigidBody.velocity.x = 0;
					
					if (!player.isFalling() && !player.isJumping())
						player.rigidBody.velocity.y = 0;

					if (!invokerShape.flipped)
						player.changeState(PlayerStates.STATE_PLAYER_SLIDING_TRIANGLE);

					break;
				case CollisionData.COLLISION_SIDE_RIGHT:
					player.rigidBody.position.y -= int(Math.sin(angle) * dist);
					player.rigidBody.position.x -= int(Math.cos(angle) * dist);


					player.rigidBody.velocity.x = 0;
					if (!player.isFalling() && !player.isJumping())
						player.rigidBody.velocity.y = 0;
					
					if (!invokerShape.flipped)
						player.changeState(PlayerStates.STATE_PLAYER_SLIDING_TRIANGLE);

					break;
			}
			
			playerShape.x = player.rigidBody.velocity.x;
			playerShape.y = player.rigidBody.velocity.y;
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
			if (!(owner is ICollidable))
				return;
				
			ICollidable(owner).hitHandler(invoker, collisionSide);
				
			if (!(invoker is Player))
				return;
				
			var invokerShape:Shape = this.boundingShape;
			
			if (invokerShape is BoundingBox)
				return hitBoxHandler(invoker, collisionSide);
				
			if (invokerShape is BoundingTriangle)
				return hitTriangleHandler(invoker, collisionSide);
		}
		
		public function noHitHandler(invoker:ICollidable):void
		{
			if (owner is ICollidable)
				ICollidable(owner).noHitHandler(invoker);
		}
		
		public function update(diff:Number):void
		{
					
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
		}
	}
}