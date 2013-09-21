package pl.fabrykagier.totempotem.core 
{
	import pl.fabrykagier.totempotem.managers.GameManager;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	public class Steam extends GameObject 
	{	
		private var object:GameObject;
		
		public function Steam(atlases:Vector.<TextureAtlas>, scale:Number, object:GameObject) 
		{
			super(atlases, "");
			
			this.object = object;
			
			addAnimation("steam");
			
			this.scaleX = scale;
			this.scaleY = scale;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		public function doubleJump():void
		{
			this.x = object.x;
			
			if (object is Player)
				this.y = object.y + object.height / 4;
			else
				this.y = object.y + object.height / 2.3;
			
			stopAnimation();
			playAnimation("steam", null, false);
		}
	}
}