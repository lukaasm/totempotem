package pl.fabrykagier.totempotem.level.backgound 
{
	import flash.utils.*;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	
	public class LevelBackground extends Sprite
	{
		protected var atlases:Vector.<TextureAtlas>;
		public var layers:Dictionary;
		
		public function LevelBackground() 
		{
			atlases = new Vector.<TextureAtlas>;
			layers = new Dictionary;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		public function addElement(element:GameObject):void
		{
			addChild(element);
		}
		
		public function handlePlayerInput(player:Player):void
		{
		}
		
		public function update(diff:Number):void 
		{
		}
		
		public function cleanup():void
		{
			removeChildren();
			
			for each (var atlas:TextureAtlas in atlases)
			{
				if (atlas.texture.name == "player")
					continue;
					
				GameManager.instance.assets.removeTextureAtlas(atlas.texture.name);
				atlas.dispose();
			}
				
			atlases.splice(0, atlases.length);
			
			for each (var layer:BackgroundLayer in layers)
				layer.cleanup();
				
			layers = null;
			atlases = null;
		}
	}

}