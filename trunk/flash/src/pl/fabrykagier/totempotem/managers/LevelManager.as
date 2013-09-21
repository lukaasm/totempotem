package pl.fabrykagier.totempotem.managers 
{
	import flash.utils.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.level.*;
	import pl.fabrykagier.totempotem.level.backgound.EarthLevelBackground;
	import pl.fabrykagier.totempotem.level.backgound.FireLevelBackground;
	import pl.fabrykagier.totempotem.level.backgound.LevelBackground;
	import pl.fabrykagier.totempotem.statemachine.*;
	import starling.display.*;
	
	public class LevelManager extends Sprite
	{
		public var restart:Boolean;
		private static var _instance:LevelManager;

		private var _level:Level;
		private var _levelBackground:LevelBackground;
		private var _agent:Agent;
		
		private var _levels:Dictionary;
		private var _backgrounds:Dictionary;
			
		public function LevelManager() 
		{
			_instance = this;
			
			_agent = new Agent();
			
			restart = false;
			
			_levels = new Dictionary();
			_backgrounds = new Dictionary();
		}
			
		public function selectLevel(name:String, callback:Function):void
		{
			removeChildren();
			
			if (_level)
				_level.cleanup();
				
			if (_levelBackground)
				_levelBackground.cleanup();
				
			switch (name)
			{
				case BossData.TYPE_EARTH_BOSS:
				{	
					_level = new EarthLevel();
					
					if (Debug.DEBUG_LEVEL_LITE == false)
						_levelBackground = new EarthLevelBackground();
						
					break;
				}
				case BossData.TYPE_FIRE_BOSS:
				{	
					_level = new FireLevel();
					
					if (Debug.DEBUG_LEVEL_LITE == false)
						_levelBackground = new FireLevelBackground();
					
					break;
				}
				default:
					return;
			}
			
			_level.loadAssets(callback);
		}
		
		public function playLevel():void
		{
			GameManager.instance.hidePopup();
			CollisionManager.instance.register(level.player);
			
			level.player.changeState(PlayerStates.STATE_PLAYER_IDLE);
			
			level.player.rigidBody.position.x = level.player.startPosition.x;
			level.player.rigidBody.position.y = level.player.startPosition.y;
			
			level.agent.stateMachine.changeState(IState(level.states[LevelStates.START_LEVEL_STAGE]));
		}
		
		public function update(diff:Number):void
		{
			if (Debug.DEBUG_LEVEL_LITE == false)
				levelBackground.update(diff);
				
			level.update(diff);
		}
		
		public function loadingDone():void 
		{
			if (Debug.DEBUG_LEVEL_LITE == false)
				addChild(_levelBackground);
				
			addChild(_level);
			
			GameManager.instance.hud.levelInProgress(_level.type);
			
			playLevel();
		}
		
		public static function get instance():LevelManager 
		{
			return _instance;
		}
		
		public function get level():Level 
		{
			return _level;
		}
		
		public function get agent():Agent 
		{
			return _agent;
		}
		
		public function get levelBackground():LevelBackground 
		{
			return _levelBackground;
		}
	}
}