package pl.fabrykagier.totempotem.statemachine 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	
	public interface IPlayerState 
	{
		function onCollision(invoker:ICollidable, collisionSide:int):void;
		function onData(key:int, value:int):void;
	}
}