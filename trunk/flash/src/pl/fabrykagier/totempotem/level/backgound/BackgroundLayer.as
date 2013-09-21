package pl.fabrykagier.totempotem.level.backgound 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.behaviours.AnimationBehaviour;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class BackgroundLayer extends Sprite 
	{
		public var objects:Vector.<GameObject>;
		private var shift:Point;
		
		public function BackgroundLayer(...args)
		{
			if (args.length == 1)
			{
				var back:Quad = new Quad(1024, 768, args[0]); 
				addChild(back);
			}
			else 
				objects = new Vector.<GameObject>;
				
			shift = new Point(0, 0);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			for each(var element:GameObject in objects)
			{
				addElement(element);
			}
		}
		
		public function addObjects(atlases:Vector.<TextureAtlas>, textureName:String, multiplier:int = 1):void
		{
			for each (var atlas:TextureAtlas in atlases)
			{
				var textures:Vector.<Texture> = atlas.getTextures(textureName);
				for each(var texture:Texture in textures)
				{
					for (var i:int = 0; i < multiplier; i++)
					{
						objects.push(new GameObject(atlases, texture.name));
					}
				}
			}
		}
		
		public function addObject(atlases:Vector.<TextureAtlas>, textureName:String):void
		{
			objects.push(new GameObject(atlases));
			
			objects[0].addAnimation(textureName, (textureName == "sun" ? 8 : 1));
			objects[0].playAnimation(textureName, null, true);
		}
		
		public function addElement(element:GameObject):void
		{
			addChild(element);
		}
		
		public function update(diff:Number, speed:Number = 0, shift:Number = 0):void
		{
			if (shift != 0)
			{
				this.shift.x += shift;
				this.x += int((((LevelManager.instance.level.target.x * speed) - this.x) / GameData.SCREEN_TEMPO) - this.shift.x);
			}
			else
			{
				this.x += int(((LevelManager.instance.level.target.x * speed) - this.x) / GameData.SCREEN_TEMPO);
			}
				
			this.y += int((LevelManager.instance.level.target.y - this.y) / GameData.SCREEN_TEMPO);
		}
		
		public function cleanup():void
		{
			removeChildren();
			
			if (objects && objects.length)
			{
				for each (var o:GameObject in objects)
					o.cleanup();
			}
			
			objects = null;
		}
	}

}