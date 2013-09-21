package pl.fabrykagier.totempotem.collisions 
{
	import starling.display.Shape;
	
	public interface ICollidable 
	{
		function get boundingShape():Shape;
		function get collisionGroup():String;
		
		function hitHandler(invoker:ICollidable, collisionSide:int):void;
		
		function noHitHandler(invoker:ICollidable):void;
	}
}