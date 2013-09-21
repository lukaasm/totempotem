package pl.fabrykagier.totempotem.collections 
{
	internal final class StackNode 
	{
		public var value:Object;
		public var next:StackNode;
 
		public function StackNode(value:Object):void
		{
			this.value = value;
		}
	}
}