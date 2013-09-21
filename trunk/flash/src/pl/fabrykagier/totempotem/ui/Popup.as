package pl.fabrykagier.totempotem.ui 
{
	import flash.events.MouseEvent;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	
	public class Popup extends GameObject
	{
		private var quad:Quad;
		
		public function Popup(atlases:Vector.<TextureAtlas>, texture:String)
		{
			super(atlases, texture);
			
			quad = new Quad(1024, 768, 0x000000);
			quad.alpha = 0.8;
			
			quad.x = -quad.width / 2;
			quad.y = -quad.height / 2;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeChildren();
			addChild(quad);
			addChild(objectImage);

			switch (this.name)
			{
				case Popups.POPUP_GAMEOVER:
					createGameOverPopup();
					break;
				case Popups.POPUP_PAUSE:
					createPausePopup();
					break;
				case Popups.POPUP_STAGECLEAR1:
				case Popups.POPUP_STAGECLEAR2:
					createStageClearPopup();
					break;
				case Popups.POPUP_BOSS_WARN:
					createBossWarningPopup();
					break;
			}
		}
		
		public static function createButton(atlases:Vector.<TextureAtlas>, up:String, down:String):Button
		{
			var upTexture:Texture = null;
			var downTexture:Texture = null;
			
			for each (var atlas:TextureAtlas in atlases)
			{
				if (upTexture == null)
					upTexture = atlas.getTexture(up);
				
				if (downTexture == null)
					downTexture = atlas.getTexture(down);
			}
			
			return new Button(upTexture, "", downTexture);
		}
		
		private function createGameOverPopup():void
		{
			var tryAgain:Button = createButton(atlases, "try again", "try again choosen");
			var quit:Button = createButton(atlases, "quit", "quit choosen");
			
			tryAgain.addEventListener(Event.TRIGGERED, onTryAgainClickedHandler);
			quit.addEventListener(Event.TRIGGERED, onQuitClickedHandler);
			
			tryAgain.y = 115;
			tryAgain.x = -180;
			
			quit.y = 115;
			quit.x = 20;
			
			addChild(tryAgain);
			addChild(quit);
		}
		
		private function createPausePopup():void
		{
			var resume:Button = createButton(atlases, "resume", "resume choosen");
			var quit:Button = createButton(atlases, "quit", "quit choosen");

			resume.addEventListener(Event.TRIGGERED, onResumeClickedHandler);
			quit.addEventListener(Event.TRIGGERED, onQuitClickedHandler);
			
			resume.y = 90;
			resume.x = -180;
			
			quit.y = 90;
			quit.x = 20;
			
			addChild(resume);
			addChild(quit);
		}
		
		private function createBossWarningPopup():void
		{
			var resume:Button = createButton(atlases, "resume", "resume choosen");

			resume.addEventListener(Event.TRIGGERED, onResumeClickedHandler);
			
			resume.x = -resume.width/2;
			resume.y = 110;
			
			addChild(resume);
		}
		
		private function onQuitClickedHandler(e:Event):void 
		{
			GameManager.instance.hidePopup();
			GameManager.instance.exitGame();
		}
		
		private function onTryAgainClickedHandler(e:Event):void 
		{
			GameManager.instance.hidePopup();
			GameManager.instance.restartGame();
		}
		
		private function onResumeClickedHandler(e:Event):void 
		{
			GameManager.instance.hidePopup();
		}
		
		private function createStageClearPopup():void
		{	
			var resume:Button = createButton(atlases, "start level", "start level choosen");
			var quit:Button = createButton(atlases, "quit", "quit choosen");

			if (name == Popups.POPUP_STAGECLEAR2)
				resume.addEventListener(Event.TRIGGERED, GameManager.instance.ending);
			else
				resume.addEventListener(Event.TRIGGERED, onNextStageClickedHandler);
				
			quit.addEventListener(Event.TRIGGERED, onQuitClickedHandler);
			
			quit.y = 110;
			quit.x = -180;
			
			resume.y = 110;
			resume.x = 20;
			
			var lifes:Sprite = new Sprite();
			var offset:int = 30;

			var plr:Player = GameManager.instance.player;
			for (var i:int = 0; i < PlayerData.PLAYER_START_LIVES; ++i)
			{
				var go:GameObject = new GameObject(atlases, (i < plr.life.lives ? "HUD life" : "HUD no life"));
				go.x = offset;
				
				lifes.addChild(go);

				offset += go.width + 2;
			}
			
			lifes.y = 25;
			lifes.x = 60;
			
			addChild(lifes);
			
			var level:Level = LevelManager.instance.level;
			
			var texture:String = "";
			var count:int = 0;
			switch (level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					texture = "HUD ammo earth";
					count = PlayerData.PLAYER_AMMO_EARTH_COUNT;
					break;
				case BossData.TYPE_FIRE_BOSS:
					texture = "HUD ammo fire";
					count = PlayerData.PLAYER_AMMO_FIRE_COUNT;
					break;
			}
			
			var ammoSprite:Sprite = new Sprite();
			var ammoImage:GameObject = new GameObject(atlases, texture);
			ammoSprite.addChild(ammoImage);
			
			var ammoText:TextField = new TextField(100, 32, "", "font", 32);
			ammoText.text = "x " + count;
			ammoText.hAlign = HAlign.LEFT;
			
			ammoText.x = ammoImage.width - 20;
			ammoSprite.addChild(ammoText);
			
			ammoText.y = -16;
			
			ammoSprite.y = 75;
			ammoSprite.x = 85;
			addChild(ammoSprite);
			
			addChild(resume);
			addChild(quit);
		}
		
		private function onNextStageClickedHandler(e:Event):void 
		{
			GameManager.instance.changeLevel();
		}
		
		public override function cleanup():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);

			removeChildren();
		}
	}
}