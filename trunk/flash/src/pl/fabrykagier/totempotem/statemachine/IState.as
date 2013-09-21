package pl.fabrykagier.totempotem.statemachine 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	
	public interface IState 
	{
		function enter():void;
		function exit():void;
		function update(diff:Number):void;
		
		function get name():String;
		function get activeTime():int;
	}
}