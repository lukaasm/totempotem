package pl.fabrykagier.totempotem.managers
{
	import flash.utils.*;
	import pl.fabrykagier.totempotem.assets.Logo;
	import pl.fabrykagier.totempotem.assets.SharedAssets;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.input.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	import pl.fabrykagier.totempotem.states.gamestates.*;
	import pl.fabrykagier.totempotem.ui.*;
	import starling.core.Starling;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.TextureAtlas;
	import starling.utils.*;
	
	public class GameManager extends Sprite
	{
		private static var _instance:GameManager;
		
		private var prevFrameTime:Number;
		private var accumulatedDiff:Number;
		
		private var startGameState:StartGameState;
		private var introState:IntroState;
		private var gameplayState:GameplayState;
		private var pauseGameState:PauseGameState;
		private var endGameState:EndGameState;
		
		private var _hud:GameHUD;
		private var _assets:AssetManager;
		private var _player:Player;
		private var _agent:Agent;
		private var _input:IInput;
		
		private var popups:Dictionary;
		private var starling:Starling;
		
		protected var _states:Dictionary;
		
		protected var currentPopup:Popup;
		
		public function GameManager()
		{
			_instance = this;
			
			_agent = new Agent();
			_hud = new GameHUD();
			
			popups = new Dictionary;
			
			_states = new Dictionary();

			states[GameStates.END_GAME] = new EndGameState(this);
			states[GameStates.PAUSE_GAME] = new PauseGameState(this);
			states[GameStates.GAMEPLAY] = new GameplayState(this);
			states[GameStates.INTRO] = new IntroState(this);
			states[GameStates.START_GAME] = new StartGameState(this);
			states[GameStates.LEVEL_CHANGE] = new LevelChangeState(this);
			states[GameStates.MAIN_MENU] = new MainMenuState(this);
			
			_input = GameData.INPUT_TYPE == GameData.INPUT_KEYBOARD ? new InputKeyboard() : new InputTouchscreen();
			
			prevFrameTime = getTimer();
			accumulatedDiff = 0;
		}
		
		public function start(assets:AssetManager, starling:Starling):void
		{
			this.starling = starling;
			_assets = assets;
			
			this.starling = starling;
			
			_assets.enqueue(Logo);
			_assets.loadQueue(onLogoLoadHandler);
		}
		
		private function onLogoLoadHandler(ratio:Number):void 
		{
			if (ratio != 1)
				return;
				
			agent.stateMachine.changeState(IState(states[GameStates.START_GAME]));
		}
		
		public function showPopup(name:String):void
		{
			if (currentPopup)
				removeChild(currentPopup);
			
			var p:Popup = popups[name];
			p.x = stage.stageWidth / 2;
			p.y = stage.stageHeight / 2;
			
			currentPopup = p;
			
			addChild(p);
			
			agent.stateMachine.changeState(IState(states[GameStates.PAUSE_GAME]));
		}
		
		public function hidePopup():void
		{
			if (currentPopup)
				removeChild(currentPopup);
			
			agent.stateMachine.changeState(IState(states[GameStates.GAMEPLAY]));
		}
		
		public function exitGame():void
		{
			//endGame();
			SoundManager.instance.stopAllSounds();
			removeChildren();
			launchCredits();
		}
		
		public function ending():void
		{
			agent.stateMachine.changeState(IState(states[GameStates.END_GAME]));
		}
		
		public function changeLevel():void 
		{
			hidePopup();
			SoundManager.instance.stopAllSounds();
			agent.stateMachine.changeState(IState(states[GameStates.LEVEL_CHANGE]));
		}
		
		public function launchCredits():void
		{
			removeChildren();
			addChild(new Quad(1024, 768, 0x0F0000));
		}
		
		public function startGame():void
		{
			removeChildren();
			addChildren();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		public function createPopups():void
		{
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlases.push(assets.getTextureAtlas("player"));
			atlases.push(assets.getTextureAtlas("popups"));
			
			popups[Popups.POPUP_GAMEOVER] = new Popup(atlases, Popups.POPUP_GAMEOVER);
			popups[Popups.POPUP_PAUSE] = new Popup(atlases, Popups.POPUP_PAUSE);
			popups[Popups.POPUP_STAGECLEAR1] = new Popup(atlases, Popups.POPUP_STAGECLEAR1);
			popups[Popups.POPUP_STAGECLEAR2] = new Popup(atlases, Popups.POPUP_STAGECLEAR2);
			popups[Popups.POPUP_BOSS_WARN] = new Popup(atlases, Popups.POPUP_BOSS_WARN);
		}
		
		public function addChildren():void
		{
			addChild(LevelManager.instance);
			
			if (Debug.DEBUG_DRAW_COLLISION)
				addChild(CollisionManager.instance.debugSprite);

			addChild(Sprite(_input));
			addChild(hud);
		}
		
		public function restartGame():void 
		{
			player.life.lives = PlayerData.PLAYER_START_LIVES;
			PlayerData.PLAYER_AMMO_EARTH_COUNT = 0;
			PlayerData.PLAYER_AMMO_FIRE_COUNT = 0;
			
			LevelManager.instance.restart = true;
			
			SoundManager.instance.stopAllSounds();
			agent.stateMachine.changeState(IState(states[GameStates.LEVEL_CHANGE]));
		}
		
		private function setStartingState(state:String):void
		{
			agent.stateMachine.changeState(IState(states[state]));
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
			var currFrameTime:int = getTimer();
			
			var diff:int = currFrameTime - prevFrameTime;
			prevFrameTime = currFrameTime;
			accumulatedDiff += diff;
			
			while (accumulatedDiff >= GameData.UPDATE_STEP)
			{
				update(GameData.UPDATE_STEP);
				
				accumulatedDiff -= GameData.UPDATE_STEP;
			}
		}
		
		private function endGame():void
		{
			removeChildren();
			
			_input.cleanup();
			_input = null;
			
			_player.cleanup()
			_player = null;
			
			//_assets = null;
		}
		
		private function update(diff:int):void
		{
			hud.update(diff);
			
			agent.update(diff);
			
			CollisionManager.instance.update(diff);
		}
		
		public static function get instance():GameManager
		{
			return _instance;
		}
		
		public function get assets():AssetManager
		{
			return _assets;
		}
		
		public function get player():Player
		{
			return _player;
		}
		
		public function get input():IInput
		{
			return _input;
		}
		
		public function get hud():GameHUD
		{
			return _hud;
		}
		
		public function get agent():Agent
		{
			return _agent;
		}
		
		public function get states():Dictionary
		{
			return _states;
		}
		
		public function set player(value:Player):void 
		{
			_player = value;
		}
	}
}