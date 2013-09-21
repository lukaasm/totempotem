package pl.fabrykagier.totempotem.collisions 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.data.Debug;
	import starling.display.Shape;
	
	public class BoundingTriangle extends Shape 
	{
		private var _lp1:Point;
		private var _lp2:Point;
		private var _lp3:Point;
		private var _width:int;
		private var _height:int;
		
		public var p1:Point;
		public var p2:Point;
		public var p3:Point;
		
		protected var _flipped:Boolean;
		
		public function BoundingTriangle(center:Point, width:int, height:int, flipped:Boolean = false) 
		{
			this.x = center.x;
			this.y = center.y;
			
			_flipped = flipped;
			
			var s:int = flipped ? -1 : 1;
			_lp1 = new Point(-int(width / 2), int(height / 2)*s);
			_lp2 = new Point(int(width / 2), int(height / 2)*s);
			
			s = flipped ? 1 : -1;
			_lp3 = new Point(0, int(height / 2)*s);
			
			if (Debug.DEBUG_DRAW_COLLISION)
			{
				graphics.beginFill(0xCC0000);
				graphics.lineStyle(2);
				graphics.moveTo(_lp1.x, _lp1.y);
				graphics.lineTo(_lp2.x, _lp2.y);
				graphics.lineTo(_lp3.x, _lp3.y);
				graphics.lineTo(_lp1.x, _lp1.y);
				graphics.endFill();
			}
			
			alpha = 0.55;
			
			this.p1 = new Point();
			this.p2 = new Point();
			this.p3 = new Point();
			
			_width = width;
			_height = height;
			
			this.width = width;
			this.height = height;
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
			this.p1.x = this.x + _lp1.x;
			this.p1.y = this.y + _lp1.y;
			
			this.p2.x = this.x + _lp2.x;
			this.p2.y = this.y + _lp2.y;
			
			this.p3.x = this.x + _lp3.x;
			this.p3.y = this.y + _lp3.y;
			
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
			return false;
		}
		
		private function intersectsSphere(sphere:BoundingSphere):Boolean 
		{
			if (sphere.pointIntersection(p1) || sphere.pointIntersection(p2) || sphere.pointIntersection(p3))
				return true;
			
			if (sphere.lineIntersection(p1, p2))
				return true;
				
			if (sphere.lineIntersection(p1, p3))
				return true;
				
			if (sphere.lineIntersection(p2, p3))
				return true;
				
			return false;
		}
		
		private function intersectsBox(boundingBox:BoundingBox):Boolean
		{
			return false;
		}
		
		public function get flipped():Boolean 
		{
			return _flipped;
		}
	}
}