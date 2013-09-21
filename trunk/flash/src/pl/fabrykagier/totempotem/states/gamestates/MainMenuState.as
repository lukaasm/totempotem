package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import pl.fabrykagier.totempotem.ui.Popup;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class MainMenuState implements IState 
	{
		private var stateMachine:StateMachine;
		private var gameManager:GameManager;
		
		protected var enterTime:int;
		
		private var menu:Sprite;
		
		public function MainMenuState(gameManager:GameManager) 
		{
			menu = new Sprite;
			
			this.gameManager = gameManager;
			
			if (gameManager.agent != null)
				stateMachine = gameManager.agent.stateMachine;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] ENTER() ");
			
			if (gameManager.player == null)
				gameManager.player = new Player();
			
			menu.removeChildren();
			menu.addChild(new Image(gameManager.assets.getTexture("MENU")));

			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlases.push(gameManager.assets.getTextureAtlas("popups"));
			
			var start:Button = Popup.createButton(atlases, "start game", "");
			start.x = gameManager.stage.stageWidth / 2 - 150;
			start.y = 465;
			
			start.addEventListener(Event.TRIGGERED, startGame);
			
			var quit:Button = Popup.createButton(atlases, "quit1", "");
			quit.x = gameManager.stage.stageWidth / 2 - 150;
			quit.y = 565;
			
			quit.addEventListener(Event.TRIGGERED, gameManager.exitGame);
			
			menu.addChild(start);
			menu.addChild(quit);
			GameManager.instance.addChild(menu);
			
			SoundManager.instance.playSound(SoundsData.MENU_MUSIC, 9999, 0.4);
		}
		
		public function startGame():void
		{
			stateMachine.changeState(IState(gameManager.states[GameStates.INTRO]));
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] EXIT() ");
			
			SoundManager.instance.stopAllSounds();
			
			GameManager.instance.removeChild(menu);
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
			return GameStates.MAIN_MENU;
		}
	}
}