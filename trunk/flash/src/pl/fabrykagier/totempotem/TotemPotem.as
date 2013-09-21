package pl.fabrykagier.totempotem 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import pl.fabrykagier.totempotem.assets.SharedAssets;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	
	import pl.fabrykagier.totempotem.data.GameData;
	
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="60", wmode="direct")]
	public class TotemPotem extends Sprite
	{
		private var starling:Starling;
		
		public function TotemPotem() 
		{
			super();

			if (stage != null)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			init();
		}
		
		private function init():void 
		{
			var sceneManager:LevelManager = new LevelManager();
			var soundManager:SoundManager = new SoundManager();
			var collisionManager:CollisionManager = new CollisionManager();
			
			Starling.multitouchEnabled = true;
			
			starling = new Starling(GameManager, stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			starling.showStats = Debug.DEBUG_SHOW_STATS;
			
			starling.start();
			
			starling.addEventListener(Event.ROOT_CREATED, onRootCreatedHandler);
		}
		
		private function onRootCreatedHandler(e:Event, game:GameManager):void 
		{
			starling.removeEventListener(Event.ROOT_CREATED, onRootCreatedHandler);
			
			var assets:AssetManager = new AssetManager();
			game.start(assets, starling);
		}
	}
}