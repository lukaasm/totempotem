package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class LevelChangeState implements IState 
	{
		private var stateMachine:StateMachine;
		private var gameManager:GameManager;
		private var quad:Quad;
		
		protected var enterTime:int;
		protected var type:String;
		
		protected var screen:GameObject;
		protected var bar:GameObject;
		
		public function LevelChangeState(gameManager:GameManager) 
		{
			this.gameManager = gameManager;
			
			quad = new Quad(1024, 768, 0x000000);
			
			if (gameManager.agent != null)
				stateMachine = gameManager.agent.stateMachine;
		}
		
		public function enter():void
		{
			CollisionManager.instance.unregisterAll();
			GameManager.instance.removeChildren();
			GameManager.instance.addChildren();
			
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[LevelChange STATE] ENTER() ");
			
			stateMachine.setNextState(IState(gameManager.states[GameStates.GAMEPLAY]));
			
			var levelManager:LevelManager = LevelManager.instance;
			
			type = BossData.TYPE_EARTH_BOSS;
			if (levelManager.level && !levelManager.restart || Debug.DEBUG_FIRE_LEVEL)
				type = BossData.TYPE_FIRE_BOSS;
				
			//quad.x = -quad.width / 2;
			//quad.y = -quad.height / 2;
			
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlases.push(GameManager.instance.assets.getTextureAtlas("loading"));
			
			if (bar)
				bar.cleanup();
				
			bar = new GameObject(atlases, (type == BossData.TYPE_EARTH_BOSS ? "loading bar earth" : "loading bar fire"));
			bar.x = GameManager.instance.stage.stageWidth / 2 - bar.width;
			bar.y = 686 + bar.height / 2;
			
			levelManager.selectLevel(type, onLoadingProgressHandler);
			
			if (screen)
				screen.cleanup();
				
			screen = new GameObject(atlases, (type == BossData.TYPE_EARTH_BOSS ? "loading screen 1" : "loading screen 2"));
			screen.x = GameManager.instance.stage.stageWidth / 2;
			screen.y = GameManager.instance.stage.stageHeight / 2;
			//686
		
			var currentLevel:Level = levelManager.level;
			var currentLevelStateMachine:StateMachine = currentLevel.agent.stateMachine;
			
			currentLevel.player = gameManager.player;
			
			CollisionManager.instance.register(gameManager.player);
			
			GameManager.instance.addChild(quad);
			GameManager.instance.addChild(bar);
			GameManager.instance.addChild(screen);
		}
		
		public function onLoadingProgressHandler(ratio:Number):void
		{
			trace("Loading level assets: " + int(ratio * 100) + "%");
			
			bar.x =  GameManager.instance.stage.stageWidth / 2 - bar.width + bar.width*ratio;
			if (ratio != 1.0)
				return;
				
			GameManager.instance.removeChild(bar);
			
			var text:TextField = new TextField(bar.width, bar.height, "Press any key to continue ...", "font", 16, 0xFFFFFF);
			text.x = bar.x - bar.width / 2;
			text.y = bar.y - bar.height / 2;
			
			text.hAlign = HAlign.CENTER;
			text.vAlign = VAlign.CENTER;
			
			GameManager.instance.addChild(text);
			
			//GameManager.instance.stage.addEventListener(TouchEvent.TOUCH, continueIntoGame);
			GameManager.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, continueIntoGame);
		}
		
		public function continueIntoGame(e:KeyboardEvent):void
		{
			GameManager.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, continueIntoGame);
			
			LevelManager.instance.loadingDone();
			stateMachine.goToNextState(IState(gameManager.states[GameStates.GAMEPLAY]));
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[LevelChange STATE] EXIT() ");
			
			LevelManager.instance.restart = false;
			
			GameManager.instance.removeChild(quad);
			GameManager.instance.removeChild(screen);
		}
		
		public function update( diff:Number ):void
		{
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return GameStates.LEVEL_CHANGE;
		}
	}
}