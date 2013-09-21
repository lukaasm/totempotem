package pl.fabrykagier.totempotem.collisions 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pl.fabrykagier.totempotem.data.Debug;
	import starling.display.DisplayObject;
	import starling.display.Shape;
	
	public class BoundingBox extends Shape 
	{
		private var _width:int;
		private var _height:int;
		
		public function BoundingBox(center:Point, width:int, height:int) 
		{
			this.x = center.x;
			this.y = center.y;
			
			if (Debug.DEBUG_DRAW_COLLISION)
			{
				graphics.beginFill(0xCC0000);
				graphics.lineStyle(2);
				graphics.drawRect(-int(width/2), -int(height/2), width, height);
				graphics.endFill();
			}
			
			alpha = 0.55;
			
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
			if (shape is BoundingBox)
				return intersectsBox(BoundingBox(shape));
			else if (shape is BoundingSphere)
				return intersectsSphere(BoundingSphere(shape));
				
			return false;
		}
		
		private function intersectsBox(box:BoundingBox):Boolean
		{
			if (this == box)
				return false;
				
			return (Math.abs(this.x - box.x) * 2 < (this.width + box.width)) 
					&& (Math.abs(this.y - box.y) * 2 < (this.height + box.height));
		}
		
		private function intersectsSphere(sphere:BoundingSphere):Boolean
		{
			return sphere.intersects(this);
		}
	}
}