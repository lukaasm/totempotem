package pl.fabrykagier.totempotem.input 
{
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import flash.ui.Keyboard;
	
	import pl.fabrykagier.totempotem.data.Controls;
	
	public class InputKeyboard extends Sprite implements IInput 
	{
		private var _state:int;
		
		public function InputKeyboard() 
		{
			_state = 0x00;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		}
		
		private function onKeyUpHandler(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case Keyboard.W:
				case Keyboard.UP:
					_state &= ~Controls.CONTROL_UP;
					break;
				case Keyboard.S:
				case Keyboard.DOWN:
					_state &= ~Controls.CONTROL_DOWN;
					break;
				case Keyboard.D:
				case Keyboard.RIGHT:
					_state &= ~Controls.CONTROL_RIGHT;
					break;
				case Keyboard.A:
				case Keyboard.LEFT:
					_state &= ~Controls.CONTROL_LEFT;
					break;
				case Keyboard.SPACE:
					_state &= ~Controls.CONTROL_SHOOT;
					break;
				case Keyboard.P:
					if (LevelManager.instance.level)
						LevelManager.instance.level.reloadLevel();
					break;
				case Keyboard.O:
					GameManager.instance.showPopup(Popups.POPUP_STAGECLEAR1);
					break;
			}
		}
		
		private function onKeyDownHandler(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case Keyboard.W:
				case Keyboard.UP:
					_state |= Controls.CONTROL_UP;
					break;
				case Keyboard.S:
				case Keyboard.DOWN:
					_state |= Controls.CONTROL_DOWN;
					break;
				case Keyboard.D:
				case Keyboard.RIGHT:
					_state |= Controls.CONTROL_RIGHT;
					break;
				case Keyboard.A:
				case Keyboard.LEFT:
					_state |= Controls.CONTROL_LEFT;
					break;
				case Keyboard.SPACE:
					_state |= Controls.CONTROL_SHOOT;
					break;
			}
		}
		
		public function cleanup():void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			removeEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
		}
		
		public function get state():int
		{
			return _state;
		}
	}
}