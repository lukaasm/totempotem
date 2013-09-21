package pl.fabrykagier.totempotem.behaviours 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.collisions.BoundingSphere;
	import pl.fabrykagier.totempotem.collisions.BoundingTriangle;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Controls;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.core.Starling;
	import starling.display.Shape;
	
	public class TransparentBehaviour implements IBehaviour, ICollidable 
	{
		private var owner:GameObject;
		private var group:String;
		
		private var shape:Shape;
		public var offset:Point;
		
		public function TransparentBehaviour(owner:GameObject, offset:Point, size:Point, group:String, shape:String = "", flip:Boolean = false) 
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
			shape.x = owner.position.x + offset.x;
			shape.y = owner.position.y + offset.y;
			
			return shape;
		}
		
		public function get collisionGroup():String
		{
			return group;
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
			if (owner is ICollidable)
				ICollidable(owner).hitHandler(invoker, collisionSide);
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