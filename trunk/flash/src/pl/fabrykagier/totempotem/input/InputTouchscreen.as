package pl.fabrykagier.totempotem.input 
{
	import extensions.advancedjoystick.JoyStick;
	import pl.fabrykagier.totempotem.assets.SharedAssets;
	import pl.fabrykagier.totempotem.data.Controls;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
		
	public class InputTouchscreen extends Sprite implements IInput 
	{
		private var _state:int;
		private var joyStick:JoyStick;
		
		public function InputTouchscreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			initJoyStick();
			initShootButton();
			
			addEventListener( Event.ENTER_FRAME, onEnterFrameHandler );
		}
		
		private function initJoyStick():void 
		{
			var holderTexture:Texture = Texture.fromBitmap(new SharedAssets.DEFAULT_HOLDER_TEXTURE());
			var stickTexture:Texture = Texture.fromBitmap(new SharedAssets.DEFAULT_STICK_TEXTURE());
			
			joyStick = new JoyStick(holderTexture, stickTexture);
			joyStick.setPosition( joyStick.minOffsetX, stage.stageHeight - joyStick.minOffsetY );
			addChild( joyStick );
		}
		
		private function initShootButton():void
		{
			//TODO:
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function cleanup():void
		{
		}
		
		private function onEnterFrameHandler( event:Event ):void
		{
			if( joyStick.touched )
				setControls();
			else
				zeroState();
		}
		
		private function zeroState():void
		{
			_state = 0x00;
		}
		
		private function setControls():void
		{
			joyStickControl();
			shootButtonControl();
		}
		
		private function joyStickControl():void
		{
			if (joyStick.velocityX  >= Controls.CONTOL_STICK_SENSIVITY)
			{
				_state &= ~Controls.CONTROL_LEFT;
				_state |= Controls.CONTROL_RIGHT;
			}
			else if (joyStick.velocityX  <= -Controls.CONTOL_STICK_SENSIVITY)
			{
				_state &= ~Controls.CONTROL_RIGHT;
				_state |= Controls.CONTROL_LEFT;
			}
			else if (joyStick.velocityX  < Controls.CONTOL_STICK_SENSIVITY && 
						joyStick.velocityX  > -Controls.CONTOL_STICK_SENSIVITY)
			{
				_state &= ~Controls.CONTROL_RIGHT;
				_state &= ~Controls.CONTROL_LEFT;
			}
				
			if (joyStick.velocityY  >= Controls.CONTOL_STICK_SENSIVITY)
			{
				_state &= ~Controls.CONTROL_UP;
				_state |= Controls.CONTROL_DOWN;
			}
			else if (joyStick.velocityY  <= -Controls.CONTOL_STICK_SENSIVITY)
			{
				_state &= ~Controls.CONTROL_DOWN;
				_state |= Controls.CONTROL_UP;
			}
			else if (joyStick.velocityY  < Controls.CONTOL_STICK_SENSIVITY && 
						joyStick.velocityY  > -Controls.CONTOL_STICK_SENSIVITY)
			{
				_state &= ~Controls.CONTROL_UP;
				_state &= ~Controls.CONTROL_DOWN;
			}
		}
		
		private function shootButtonControl():void
		{
			
		}
	}
}