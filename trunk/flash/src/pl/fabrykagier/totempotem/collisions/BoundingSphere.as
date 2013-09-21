package pl.fabrykagier.totempotem.collisions 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import starling.display.Shape;
	
	public class BoundingSphere extends Shape 
	{
		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var p4:Point;
		
		private var _width:int;
		private var _height:int;
		
		public function BoundingSphere(center:Point, radius:int, color:int = 0xCC0000) 
		{
			this.x = center.x;
			this.y = center.y;
			
			if (Debug.DEBUG_DRAW_COLLISION)
			{
				graphics.beginFill(color);
				graphics.lineStyle(2);
				graphics.drawCircle(-int(width/2), -int(height/2), radius);
				graphics.endFill();
			}
			
			alpha = 0.55;
			
			p1 = new Point();
			p2 = new Point();
			p3 = new Point();
			p4 = new Point();
		
			_width = radius*2;
			_height = radius*2;
			
			this.width = radius*2;
			this.height = radius*2;
		}
		
		public override function get height():Number
		{
			return _height;
		}
		
		public override function get width():Number
		{
			return _width;
		}
		
		public function intersects(shape:Shape):Boolean
		{
			if (shape is BoundingBox)
				return intersectsBox(BoundingBox(shape));
			else if (shape is BoundingSphere)
				return intersectsSphere(BoundingSphere(shape));
			else if (shape is BoundingTriangle)
				return intersectsTriangle(BoundingTriangle(shape));
				
			return false;
		}
		
		private function intersectsTriangle(boundingTriangle:BoundingTriangle):Boolean
		{
			return boundingTriangle.intersects(this);
		}
		
		private function intersectsBox(box:BoundingBox):Boolean
		{
			// p1 ---- p2
			// |  x,y  |
			// p3 ---- p4
			p1.x = int(box.x - box.width / 2);
			p1.y = int(box.y - box.height / 2);
			
			p2.x = int(box.x + box.width / 2);
			p2.y = int(box.y - box.height / 2);
			
			p3.x = int(box.x - box.width / 2);
			p3.y = int(box.y + box.height / 2);
			
			p4.x = int(box.x + box.width / 2);
			p4.y = int(box.y + box.height / 2);
			
			if (pointIntersection(p1) || pointIntersection(p2) ||
				pointIntersection(p3) || pointIntersection(p4))
				return true;
				
			if (lineIntersection(p1, p2))
				return true;
			
			if (lineIntersection(p1, p3))
				return true;
				
			if (lineIntersection(p2, p4))
				return true;
				
			if (lineIntersection(p3, p4))
				return true;
				
			return p1.x <= this.x && this.x <= p3.x && p1.y <= this.y && this.y <= p2.y;
		}
		
		public function pointIntersection(start:Point):Boolean
		{
			var t:Number = Math.pow(start.x - this.x, 2) + Math.pow(start.y - this.y, 2);
			var radiusSquared:Number = Math.pow(radius, 2);
			return t <= radiusSquared;
		}
		
		public function lineIntersection(start:Point, end:Point):Boolean
		{
			var radiusSquared:Number = Math.pow(radius, 2);
			
			var lineLength:Number = Math.pow(start.x - end.x, 2) + Math.pow(start.y - end.y, 2);
			var value:Number = (((this.x - start.x) *
								(end.x - start.x) + (this.y - start.y) * 
								(end.y - start.y)) / lineLength);
			
			if (value < 0)
			{
				var t:Number = Math.pow(this.x - start.x, 2) + Math.pow(this.y - start.y, 2);
				return t <= radiusSquared;
			}
				
			if (value > 1)
			{
				t = Math.pow(this.x - end.x, 2) + Math.pow(this.y - end.y, 2);
				return t <= radiusSquared;
			}
				
			var pointX:Number = (start.x + value * (end.x - start.x));
			var pointY:Number = (start.y + value * (end.y - start.y));
			
			t = Math.pow(this.x - pointX, 2) + Math.pow(this.y - pointY, 2);
			return t <= radiusSquared;
		}
		
		public function lineDistance(start:Point, end:Point):Number
		{
			var radiusSquared:Number = Math.pow(radius, 2);
			
			var lineLength:Number = Math.pow(start.x - end.x, 2) + Math.pow(start.y - end.y, 2);
			var value:Number = (((this.x - start.x) *
								(end.x - start.x) + (this.y - start.y) * 
								(end.y - start.y)) / lineLength);
			
			if (value < 0)
				return Math.pow(this.x - start.x, 2) + Math.pow(this.y - start.y, 2);
				
			if (value > 1)
				return Math.pow(this.x - end.x, 2) + Math.pow(this.y - end.y, 2);
				
			var pointX:Number = (start.x + value * (end.x - start.x));
			var pointY:Number = (start.y + value * (end.y - start.y));
			
			return Math.pow(this.x - pointX, 2) + Math.pow(this.y - pointY, 2);
		}
		
		public function collisiongSide(invokerShape:Shape):int
		{
			var side:int = CollisionData.COLLISION_SIDE_NONE;
			if (invokerShape is BoundingBox)
				side = collisionSideBox(BoundingBox(invokerShape));
			else if (invokerShape is BoundingTriangle)
				side = collisionSideTriangle(BoundingTriangle(invokerShape));
				
			return side;
		}
		
		private function collisionSideTriangle(invokerShape:BoundingTriangle):int
		{
			var ownerShape:BoundingSphere = this;

			var minX:int = Math.min(invokerShape.p1.x, Math.min(invokerShape.p2.x, invokerShape.p3.x));
			var maxX:int = Math.max(invokerShape.p1.x, Math.max(invokerShape.p2.x, invokerShape.p3.x));
			
			var minY:int = Math.min(invokerShape.p1.y, Math.min(invokerShape.p2.y, invokerShape.p3.y));
			var maxY:int = Math.max(invokerShape.p1.y, Math.max(invokerShape.p2.y, invokerShape.p3.y));
			
			var midX:int = (maxX + minX) / 2;
			
			var subY:Number = 1.6;
			var side:int = CollisionData.COLLISION_SIDE_NONE;
			var sub:int = 0;

			if (invokerShape.flipped)
			{
				if (minX <= ownerShape.x && ownerShape.x <= maxX)
				{
					if (ownerShape.y - ownerShape.radius/subY <= minY)
						return CollisionData.COLLISION_SIDE_BOTTOM;
					
					//if (midX - sub <= ownerShape.x && ownerShape.x <= midX + sub)
					//	return CollisionData.COLLISION_SIDE_TOP;
					
					if (ownerShape.x < midX)
						return CollisionData.COLLISION_SIDE_RIGHT;
					else//if (ownerShape.x > midX)
						return CollisionData.COLLISION_SIDE_LEFT;
				}
			}
			else
			{
				if (minX <= ownerShape.x && ownerShape.x <= maxX)
				{
					if (ownerShape.y + ownerShape.radius/subY <= minY)
						return CollisionData.COLLISION_SIDE_BOTTOM;
						
					//if (midX - sub <= ownerShape.x && ownerShape.x <= midX + sub)
					//	return CollisionData.COLLISION_SIDE_BOTTOM;
						
					if (ownerShape.x < midX)
						return CollisionData.COLLISION_SIDE_RIGHT;
					else//if (ownerShape.x > midX)
						return CollisionData.COLLISION_SIDE_LEFT;
				}
			}
			return side;
		}
		
		private function collisionSideBox(invokerShape:BoundingBox):int
		{
			var ownerShape:BoundingSphere = this;
	
			var side:int = CollisionData.COLLISION_SIDE_NONE;
	
			var minX:Number = invokerShape.x - invokerShape.width / 2;
			var minY:Number = invokerShape.y - invokerShape.height / 2;
	
			var maxX:Number = invokerShape.x + invokerShape.width / 2;
			var maxY:Number = invokerShape.y + invokerShape.height / 2;
	
			var margin:int = 12;
			var marginX:Number = ownerShape.width / margin;
			var marginY:Number = ownerShape.height / margin;
			
			if (minX <= (ownerShape.x + marginX) && (ownerShape.x - marginX) <= maxX)
			{
				if (ownerShape.y - marginY < minY)
					side = CollisionData.COLLISION_SIDE_BOTTOM;
				else if (ownerShape.y + marginY > minY)
					side = CollisionData.COLLISION_SIDE_TOP;
			}
			else
			{
				if (ownerShape.x - marginX >= maxX)
					side = CollisionData.COLLISION_SIDE_LEFT;
				else if (ownerShape.x + marginX < maxX)
					side = CollisionData.COLLISION_SIDE_RIGHT;
			}
			
			return side;
		}
		
		private function intersectsSphere(sphere:BoundingSphere):Boolean
		{
			return (Math.pow(sphere.x - this.x, 2) + Math.pow(sphere.y - this.y, 2)) <= 
					Math.pow(sphere.radius + radius, 2);
		}
		
		public function closestLine(shape:Shape):Vector.<Point>
		{
			if (shape is BoundingTriangle)
			{
				var line:Vector.<Point> = new Vector.<Point>;
				var tri:BoundingTriangle = BoundingTriangle(shape);
				
				var distance:Number = lineDistance(tri.p1, tri.p2);
				
				var p1:Point = tri.p1;
				var p2:Point = tri.p2;
				
				var t:Number = lineDistance(tri.p1, tri.p3);
				if (t < distance)
				{
					distance = t;
					p2 = tri.p3;
				}
					
				t = lineDistance(tri.p2, tri.p3);
				if (t < distance)
				{
					p1 = tri.p2;
					p2 = tri.p3;
				}
				
				line.push(p1);
				line.push(p2);
				return line;
			}
			else if (shape is BoundingBox)
			{
				var box:BoundingBox = BoundingBox(shape);
				
				this.p1.x = box.x - box.width / 2;
				this.p1.y = box.y - box.height / 2;
			
				this.p2.x = box.x + box.width / 2;
				this.p2.y = box.y - box.height / 2;
			
				this.p3.x = box.x - box.width / 2;
				this.p3.y = box.y + box.height / 2;
			
				this.p4.x = box.x + box.width / 2;
				this.p4.y = box.y + box.height / 2;
			
				line = new Vector.<Point>;
				
				distance = lineDistance(this.p1, this.p2);
				
				p1 = this.p1;
				p2 = this.p2;
				
				t = lineDistance(this.p1, this.p3);
				if (t < distance)
				{
					distance = t;
					p2 = this.p3;
				}
					
				t = lineDistance(this.p2, this.p4);
				if (t < distance)
				{
					distance = t;
					p1 = this.p2;
					p2 = this.p4;
				}
				
				t = lineDistance(this.p3, this.p4);
				if (t < distance)
				{
					p1 = this.p3;
					p2 = this.p4;
				}
				
				line.push(p1);
				line.push(p2);
				return line;
			}
			
			return null;
		}
		
		public function distanceToLine(shape:Shape):Number
		{
			if (shape is BoundingBox)
			{
				var box:BoundingBox = BoundingBox(shape);
				
				p1.x = box.x - box.width / 2;
				p1.y = box.y - box.height / 2;
			
				p2.x = box.x + box.width / 2;
				p2.y = box.y - box.height / 2;
			
				p3.x = box.x - box.width / 2;
				p3.y = box.y + box.height / 2;
			
				p4.x = box.x + box.width / 2;
				p4.y = box.y + box.height / 2;
				
				return Math.min(Math.min(lineDistance(p1, p2), lineDistance(p1, p4)), Math.min(lineDistance(p2, p3), lineDistance(p3, p4)));
			}
			else if (shape is BoundingSphere)
				return 0.0;
			else if (shape is BoundingTriangle)
			{
				var tri:BoundingTriangle = BoundingTriangle(shape);
				
				var distance:Number = lineDistance(tri.p1, tri.p2);
				
				var p1:Point = tri.p1;
				var p2:Point = tri.p2;
				
				var t:Number = lineDistance(tri.p1, tri.p3);
				if (t < distance)
					p2 = tri.p3;
					
				t = lineDistance(tri.p2, tri.p3);
				if (t < distance)
				{
					p1 = tri.p2;
					p2 = tri.p3;
				}
				return distance;
			}
			
			return 0.0;
		}
		
		public function get radius():int
		{
			return int(width / 2);
		}
	}
}