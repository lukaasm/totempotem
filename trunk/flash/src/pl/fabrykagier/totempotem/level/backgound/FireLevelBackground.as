package pl.fabrykagier.totempotem.level.backgound 
{
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.BackgroundLayers;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class FireLevelBackground extends LevelBackground 
	{
		public function FireLevelBackground() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_background_0"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_background_1"));
			
			layers[BackgroundLayers.FIRE_LAYER_BACK] = new BackgroundLayer();
			layers[BackgroundLayers.FIRE_LAYER_SMOKE1] = new BackgroundLayer();
			layers[BackgroundLayers.FIRE_LAYER_SMOKE2] = new BackgroundLayer();
			layers[BackgroundLayers.FIRE_LAYER_SUN] = new BackgroundLayer();
			
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_BACK]).addObjects(atlases, "background");
			
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]).addObjects(atlases, "smoke1");
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]).addObjects(atlases, "smoke4");
			
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).addObjects(atlases, "smoke3");
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).addObjects(atlases, "smoke2");
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).addObjects(atlases, "smoke3");
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).addObjects(atlases, "smoke4");
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).addObjects(atlases, "smoke3");
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).addObjects(atlases, "smoke2");
			
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SUN]).addObjects(atlases, "sun");
			
			setSunPosition();
			setbackgroundPosition();
			setSmokePosition();
			
			addChild(layers[BackgroundLayers.FIRE_LAYER_BACK]);
			addChild(layers[BackgroundLayers.FIRE_LAYER_SUN]);
			addChild(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]);
			addChild(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]);
		}
		
		private function setbackgroundPosition():void 
		{
			var posX:int = -BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_BACK]).objects[0].width * 3 / 4;
			var posY:int = stage.stageHeight / 2;
			
			for each(var back:GameObject in BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_BACK]).objects)
			{
				back.x = posX + back.width;
				back.y = posY;
				
				posX += back.width;
			}
		}
		
		private function setSunPosition():void
		{
			var posX:int = 210;
			var posY:int = 250;
			
			var sun:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SUN]).objects[0];
			
			sun.x = posX;
			sun.y = posY;
		}
		
		private function setSmokePosition():void
		{
			var smoke:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]).objects[0];
			
			smoke.x = 900;
			smoke.y = stage.stageHeight;
			
			var smoke1:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]).objects[1];
			
			smoke1.x = 1500;
			smoke1.y = stage.stageHeight;
			
			var smoke2:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects[0];
			
			smoke2.x = 300;
			smoke2.y = stage.stageHeight;
			
			var smoke3:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects[1];
			
			smoke3.x = 1000;
			smoke3.y = stage.stageHeight;
			
			var smoke4:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects[2];
			
			smoke4.x = 1600;
			smoke4.y = stage.stageHeight;
			
			var smoke5:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects[3];
			
			smoke5.x = 2000;
			smoke5.y = stage.stageHeight;
			
			var smoke6:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects[4];
			
			smoke6.x = 3000;
			smoke6.y = stage.stageHeight;
			
			var smoke7:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects[5];
			
			smoke7.x = 3300;
			smoke7.y = stage.stageHeight;
		}
		
		public override function update(diff:Number):void 
		{
			var sun:GameObject = BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SUN]).objects[0];
			sun.rotation += 0.00001 * diff;
			
			super.update(diff);
			
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_BACK]).update(diff, 0.01, 0.0);
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]).update(diff, 0.03, 0.0);
			BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).update(diff, 0.1, 0.0);
			
			restartSmoke();
		}
		
		private function restartSmoke():void 
		{
			for each(var smoke:GameObject in BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE1]).objects)
			{
				smoke.y -= 0.3;
			
				if (smoke.y + smoke.height / 2 < stage.stageHeight)
				{
					smoke.y = stage.stageHeight;
				}
			}
			
			for each(var smoke2:GameObject in BackgroundLayer(layers[BackgroundLayers.FIRE_LAYER_SMOKE2]).objects)
			{
				smoke2.y -= 0.6;
				
				if (smoke2.y + smoke2.height / 2 < stage.stageHeight)
					smoke2.y = stage.stageHeight;
			}
		}
		
		public override function handlePlayerInput(player:Player):void
		{}
	}
}