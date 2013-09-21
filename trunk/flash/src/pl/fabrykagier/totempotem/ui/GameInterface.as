package pl.fabrykagier.totempotem.ui 
{
	import flash.text.TextField;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameInterface extends Sprite 
	{
		public function GameInterface() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		public function cleanup():void
		{
		}
	}
}