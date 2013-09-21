package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	
	public interface IBehaviour
	{
		function onCollision(invoker:ICollidable, collisionSide:int):void;
		function onNoCollision(invoker:ICollidable):void;
		
		function update(diff:Number):void;
	}
	
}