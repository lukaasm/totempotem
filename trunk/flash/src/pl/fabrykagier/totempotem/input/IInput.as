package pl.fabrykagier.totempotem.input 
{
	public interface IInput
	{
		function get state():int;
		
		function cleanup():void;
	}
}