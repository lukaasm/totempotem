package pl.fabrykagier.totempotem.level.backgound 
{
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.BackgroundLayers;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class EarthLevelBackground extends LevelBackground 
	{
		public function EarthLevelBackground() 
		{
			super();
				
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_background"));

			layers[BackgroundLayers.EARTH_LAYER_BACK] = new BackgroundLayer(0x75634F);
			layers[BackgroundLayers.EARTH_LAYER_TREES] = new BackgroundLayer();
			layers[BackgroundLayers.EARTH_LAYER_CLOUDS] = new BackgroundLayer();
			layers[BackgroundLayers.EARTH_LAYER_SUN] = new BackgroundLayer();
			
			BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_SUN]).addObject(atlases, "sun");
			BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_CLOUDS]).addObjects(atlases, "cloud_earth", 6);
			BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_TREES]).addObjects(atlases, "tree", 4);
			
			setSunPosition();
			setCloudsPosition();
			setTreesPosition();
			
			addChild(layers[BackgroundLayers.EARTH_LAYER_BACK]);
			addChild(layers[BackgroundLayers.EARTH_LAYER_SUN]);
			addChild(layers[BackgroundLayers.EARTH_LAYER_CLOUDS]);
			addChild(layers[BackgroundLayers.EARTH_LAYER_TREES]);
		}
		
		private function setSunPosition():void
		{
			var posX:int = stage.stageWidth/2;
			var posY:int = stage.stageHeight/2;
			
			var sun:GameObject = BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_SUN]).objects[0];
			
			sun.x = posX;
			sun.y = posY;
		}
		
		private function setTreesPosition():void
		{
			var posX:int = 0;
			var posY:int = 0;
			
			for each(var tree:GameObject in BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_TREES]).objects)
			{
				posY = stage.stageHeight - tree.height/2;
				
				tree.x = posX;
				tree.y = posY;
				
				posX += tree.width/2 + stage.stageWidth * Utils.frandom(0.2, 0.4);
			}
		}
		
		private function setCloudsPosition():void
		{
			var posX:int = 0;
			var posY:int = stage.stageHeight*0.3;
			
			for each(var cloud:GameObject in BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_CLOUDS]).objects)
			{
				cloud.x = posX;
				cloud.y = posY;
				posX +=  stage.stageWidth * Utils.frandom(0.05, cloud.width > 100 ? 0.8 : 0.2);
				posY = stage.stageHeight * Utils.frandom(0.1, 0.6);
			}
		}
		
		public override function update(diff:Number):void 
		{
			super.update(diff);
			
			BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_SUN]).update(diff);
			BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_CLOUDS]).update(diff, 0.15, 0.05);
			BackgroundLayer(layers[BackgroundLayers.EARTH_LAYER_TREES]).update(diff, 0.35);
		}
		
		public override function handlePlayerInput(player:Player):void
		{
		}
	}
}