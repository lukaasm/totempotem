package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	
	public class EndGameState implements IState 
	{
		private var gameManager:GameManager;
		private var next:Button;
		
		protected var enterTime:int;
		
		public function EndGameState(gameManager:GameManager) 
		{
			this.gameManager = gameManager;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME ENDGAME STATE] ENTER() ");
			
			GameManager.instance.removeChildren();
			GameManager.instance.addChild(new Quad(1024, 768, 0x000000));
			
			var rest:TextureAtlas = GameManager.instance.assets.getTextureAtlas("intro_2");
			GameManager.instance.addChild(new Image(rest.getTexture("ending_1")));
			next = new Button(rest.getTexture("nextbutton"), "");
			next.x = GameManager.instance.stage.stageWidth - next.width;
			next.y = 682;
			
			next.addEventListener(Event.TRIGGERED, onNextClick);
			
			GameManager.instance.addChild(next);
		}
		
		public function onNextClick():void
		{
			GameManager.instance.removeChildren();
			GameManager.instance.addChild(new Quad(1024, 768, 0x000000));
			
			var rest:TextureAtlas = GameManager.instance.assets.getTextureAtlas("intro_2");
			GameManager.instance.addChild(new Image(rest.getTexture("ending_2")));
			next = new Button(rest.getTexture("skip button"), "");
			next.x = GameManager.instance.stage.stageWidth - next.width;
			next.y = 682;
			GameManager.instance.addChild(next);
			next.addEventListener(Event.TRIGGERED, gameManager.launchCredits);
		}
	
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME ENDGAME STATE] EXIT() ");
		}
		
		public function update( diff:Number ):void
		{
			
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return GameStates.END_GAME;
		}
	}
}