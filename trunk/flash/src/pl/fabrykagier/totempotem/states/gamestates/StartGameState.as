package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.assets.SharedAssets;
	import pl.fabrykagier.totempotem.assets.SoundAssets;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.core.Starling;
	import starling.display.Image;
	
	public class StartGameState implements IState 
	{
		private var stateMachine:StateMachine;
		private var gameManager:GameManager;
		
		protected var enterTime:int;
		
		private var screen:Image;
		
		public function StartGameState(gameManager:GameManager) 
		{
			this.gameManager = gameManager;
			
			if (gameManager.agent != null)
				stateMachine = gameManager.agent.stateMachine;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME STARTGAME STATE] ENTER() ");
			
			enterTime = getTimer();
			
			screen = new Image(gameManager.assets.getTexture("LOGO"));
			gameManager.addChild(screen);
			
			gameManager.assets.enqueue(SharedAssets);
			gameManager.assets.enqueue(SoundAssets);
			
			gameManager.assets.verbose = Debug.DEBUG_TRACE_ASSETS;
			gameManager.assets.loadQueue(onAssetsLoadChangeHandler);
		}
		
		private function onAssetsLoadChangeHandler(ratio:Number):void 
		{
			trace("Loading shared assets: " + int(ratio * 100) + "%");
			
			if (ratio != 1)
				return;
			
			if (activeTime >= GameData.SPLASH_SCREEN_MIN_TIME)
				loadingDone();
			else
				Starling.juggler.delayCall(loadingDone, (GameData.SPLASH_SCREEN_MIN_TIME - activeTime)*0.001);
		}
		
		private function loadingDone():void 
		{
			gameManager.createPopups();
			stateMachine.changeState(IState(gameManager.states[GameStates.MAIN_MENU]));
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME STARTGAME STATE] EXIT() ");
			
			gameManager.removeChild(screen);
		}
		
		public function update(diff:Number):void
		{
			
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return GameStates.START_GAME;
		}
	}
}