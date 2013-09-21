package pl.fabrykagier.totempotem.data 
{
	import flash.geom.Point;
	public class PlatformMovementDirection 
	{
		public static const UP:Point = new Point(0, -1);
		public static const DOWN:Point = new Point(0, 1);
		public static const LEFT:Point = new Point(-1, 0);
		public static const RIGHT:Point = new Point(1, 0);
	}
}