package pl.fabrykagier.totempotem.ui 
{
	import pl.fabrykagier.totempotem.assets.SharedAssets;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	
	public class GameHUD extends Sprite 
	{
		private var atlases:Vector.<TextureAtlas>;

		public var loading:TextField;
		
		private var lives2:Vector.<GameObject>;
		private var lives:Vector.<GameObject>;
		
		private var body:GameObject;
		
		private var lifeSprite:Sprite;
		private var ammoSprite:Sprite;
		private var totemSprite:Sprite;
		private var optionsSprite:Sprite;

		private var ammoText:TextField;

		public function GameHUD() 
		{
			atlases = new Vector.<TextureAtlas>;

			lives = new Vector.<GameObject>;
			lives2 = new Vector.<GameObject>;
			
			lifeSprite = new Sprite();
			ammoSprite = new Sprite();
			totemSprite = new Sprite();
			optionsSprite = new Sprite();
			
			ammoText = new TextField(100, 32, "", "font", 32);
			loading = new TextField(400, 32, "", "font", 32);
			loading.x = 300;
			loading.y = 300;
			addChild(loading);
		}
		
		private function addHUDLife():void
		{
			lifeSprite.removeChildren();
			
			var offset:int = 35;
			for (var i:int = 0; i < PlayerData.PLAYER_START_LIVES; ++i)
			{
				var go:GameObject = new GameObject(atlases, "HUD no life");
				go.x = offset;
				
				lives.push(go);
				lifeSprite.addChild(go);

				addLife();

				offset += go.width + 6;
			}
			
			lifeSprite.x = -body.width / 2;
			
			body.addChild(lifeSprite);
		}
		
		private function addHUDAmmo():void 
		{
			ammoSprite.removeChildren();
			
			var level:Level = LevelManager.instance.level;
			
			var texture:String = "";
			switch (level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					texture = "HUD ammo earth";
					break;
				case BossData.TYPE_FIRE_BOSS:
					texture = "HUD ammo fire";
					break;
			}
			
			var ammoImage:GameObject = new GameObject(atlases, texture);
			ammoSprite.addChild(ammoImage);
			
			ammoText.text = "x 0";
			ammoText.hAlign = HAlign.LEFT;
			
			ammoText.x = ammoImage.width - 20;
			ammoSprite.addChild(ammoText);
			
			ammoText.y = -16;

			ammoSprite.x = -body.width / 2 + lifeSprite.width + 56;
			body.addChild(ammoSprite);
		}
		
		private function addHUDOptions():void 
		{
			optionsSprite.removeChildren();
			
			var menu:Button = Popup.createButton(atlases, "HUD menu", "");
			menu.x = 55 / 2 - menu.width / 2;
			menu.y = -menu.height / 2;
			
			var sound:Button = Popup.createButton(atlases, "HUD sound", "");
			sound.x = 55 + 55 / 2 - sound.width/2;
			sound.y = -sound.height / 2;
			
			menu.addEventListener(Event.TRIGGERED, onMenuButtonClickedHandler);
			sound.addEventListener(Event.TRIGGERED, SoundManager.instance.toggleSounds);
			
			optionsSprite.addChild(sound);
			optionsSprite.addChild(menu);

			optionsSprite.x = body.width / 2 - 110;
			body.addChild(optionsSprite);
		}
		
		private function onMenuButtonClickedHandler(e:Event):void 
		{
			GameManager.instance.showPopup(Popups.POPUP_PAUSE);
		}
		
		private function addHUDTotems():void
		{
			totemSprite.removeChildren();
			
			var level:Level = LevelManager.instance.level;
			
			var earthTexture:String = "HUD earth totem 1";
			var fireTexture:String = "HUD fire totem 1";
			
			switch (level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					break;
				case BossData.TYPE_FIRE_BOSS:
					earthTexture = "HUD earth totem 2";
					fireTexture = "HUD fire totem 2";
					break;
			}
			
			var earthTotem:GameObject = new GameObject(atlases, earthTexture);
			var fireTotem:GameObject = new GameObject(atlases, fireTexture);
			
			fireTotem.x = earthTotem.width / 2 + fireTotem.width / 2 + 10;
			
			totemSprite.addChild(earthTotem);
			totemSprite.addChild(fireTotem);
			
			totemSprite.x = body.width / 2 - optionsSprite.width - totemSprite.width;
			body.addChild(totemSprite);
		}
		
		public function levelInProgress(level:String):void
		{
			removeChildren();
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("player"));
			
			body = new GameObject(atlases, "HUD body");
			body.x = body.width / 2;
			body.y = body.height / 2;
			
			addHUDLife();
			addHUDAmmo();
			addHUDOptions();
			addHUDTotems();
			
			addChild(body);
		}
		
		public function takeLife():void
		{
			if (lives2.length == 0)
				return;
				
			lifeSprite.removeChild(lives2[lives2.length - 1]);
			
			lives2.splice(lives2.length - 1, 1);
		}
		
		public function addLife():void
		{
			if (lives.length == lives2.length)
				return;
				
			var place:GameObject = lives[lives2.length];
			var life:GameObject = new GameObject(atlases, "HUD life");
			life.x = place.x;
			
			lives2.push(life);
			lifeSprite.addChild(life);
		}
		
		public function update(diff:Number):void
		{
			if (!body)
				return;
				
			switch (LevelManager.instance.level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					ammoText.text = "x " + PlayerData.PLAYER_AMMO_EARTH_COUNT;
					break;
				case BossData.TYPE_FIRE_BOSS:
					ammoText.text = "x " + PlayerData.PLAYER_AMMO_FIRE_COUNT;
					break;
			}
		}
		
		public function cleanup():void
		{
		}
	}
}