package pl.fabrykagier.totempotem.level 
{
	import flash.geom.*;
	import flash.utils.*;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.managers.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	import pl.fabrykagier.totempotem.states.levelstates.*;
	import starling.display.*;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.*;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Level extends Sprite
	{
		private var screen:GameObject;
		private var bar:GameObject;
		private var quad:Quad;
		private var text:TextField;
		
		public var prevInput:int;
		public var target:Point;
		public var bossStage:Boolean;
		
		protected var _type:String;
		public var player:Player;
		protected var _atlases:Vector.<TextureAtlas>;
		protected var _screenShiftLeft:int;
		protected var _screenShiftRight:int;
		protected var _screenShiftDiff:int
		protected var shift:Number;
		
		protected var _bossStageStart:Point;
				
		protected var _platforms:Vector.<Platform>;
		protected var _items:Vector.<Item>;
		protected var _other:Vector.<GameObject>;
		protected var _agent:Agent;
		protected var _states:Dictionary;
		
		protected var _boss:Boss;
		protected var levelXML:XML;

		public function Level() 
		{
			_atlases = new Vector.<TextureAtlas>;
			
			quad = new Quad(1024, 760, 0x000000);

			bossStage = false;
			
			this.x = 150;
			prevInput = 0x00;
			
			_agent = new Agent();
			_platforms = new Vector.<Platform>;
			_items = new Vector.<Item>;
			_other = new Vector.<GameObject>;
			target = new Point(0, 0);
			shift = 0;
			
			_states = new Dictionary();
			_states[LevelStates.START_LEVEL_STAGE] = new StartLevelStageState(this);
			_states[LevelStates.PLATFORMS_STAGE] = new PlatformsStageState(this);
			_states[LevelStates.BOSS_STAGE] = new BossStageState(this);
			_states[LevelStates.END_LEVEL_STAGE] = new EndLevelStageState(this);
			
			_screenShiftRight = 
					int(GameManager.instance.stage.stageWidth - GameManager.instance.stage.stageWidth * GameData.SCREEN_PROCENT);
			_screenShiftLeft = int(GameManager.instance.stage.stageWidth * GameData.SCREEN_PROCENT);
			_screenShiftDiff = int(screenShiftRight - screenShiftLeft);
		}
		
		public function loadBossAssets():void
		{
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlases.push(GameManager.instance.assets.getTextureAtlas("loading"));
			
			//quad.x = -quad.width / 2;
			//quad.y = -quad.height / 2;
			
			GameManager.instance.addChild(quad);
			
			if (bar)
				bar.cleanup();
				
			bar = new GameObject(atlases, (type == BossData.TYPE_EARTH_BOSS ? "loading bar earth" : "loading bar fire"));
			bar.x = GameManager.instance.stage.stageWidth / 2 - bar.width;
			bar.y = 686 + bar.height / 2;
			
			GameManager.instance.addChild(bar);
			
			if (screen)
				screen.cleanup();
				
			screen = new GameObject(atlases, (type == BossData.TYPE_EARTH_BOSS ? "loading boss fight1" : "loading boss fight2"));
			screen.x = GameManager.instance.stage.stageWidth / 2;
			screen.y = GameManager.instance.stage.stageHeight / 2;
			//686
			GameManager.instance.addChild(screen);
		}
		
		public function onBossAssetsLoadProgresshandler(ratio:Number):void
		{
			bar.x =  GameManager.instance.stage.stageWidth / 2 - bar.width + bar.width * ratio;
			
			if (ratio != 1.0)
				return;
				
			GameManager.instance.removeChild(bar);

			text = new TextField(bar.width, bar.height, "Press any key to continue ...", "font", 16, 0xFFFFFF);
			text.x = bar.x - bar.width / 2;
			text.y = bar.y - bar.height / 2;
			
			text.hAlign = HAlign.CENTER;
			text.vAlign = VAlign.CENTER;
			
			GameManager.instance.addChild(text);
			
			addEventListener(KeyboardEvent.KEY_DOWN, onBossKeyHandler);
		}
		
		private function onBossKeyHandler(e:KeyboardEvent):void 
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, onBossKeyHandler);
			
			GameManager.instance.removeChild(screen);
			GameManager.instance.removeChild(quad);
			GameManager.instance.removeChild(text);
			
			screen.cleanup();
			bar.cleanup();
			
			createBoss();
			boss.startFight();
		}
		
		public function loadAssets(callback:Function):void
		{
			trace("not implemented!");
		}
		
		public function createBoss():void
		{
		}
		
		public function onAddedToStageHandler(e:Event):void 
		{
			for each(var xml:XML in levelXML.elements("Canon"))
			{
				var canon:Canon = XMLUtils.createCanon(atlases, xml);
				addElement(canon);
			}
			
			for each(var xml2:XML in levelXML.elements("Item"))
			{
				var item:Item = XMLUtils.createItem(atlases, xml2);
				addElement(item);
			}
			
			for each(var xml3:XML in levelXML.elements("Platform"))
			{
				var platform:Platform = XMLUtils.createPlatform(atlases, xml3);
				addElement(platform);
			}
			
			var bossStageStart:XML = levelXML.elements("BossStageStart")[0];
			this._bossStageStart = new Point( -(bossStageStart.attribute("x") * GameData.PLATFORM_HEIGHT),
												-bossStageStart.attribute("y"));
												
			var player:Player = GameManager.instance.player;
			var position:XML = levelXML.elements("Start")[0];
			
			player.startPosition = new Point(position.attribute("x"), position.attribute("y"));
			player.rigidBody.position.x = player.startPosition.x;
			player.rigidBody.position.y = player.startPosition.y;
			
			CollisionManager.instance.register(player);
			
			addChild(player);
			addChild(player.doubleJumpEffect);
		}
		
		public function addElement(element:GameObject):void
		{
			if (element is Platform)
				_platforms.push(element);
			else if (element is Item)
				_items.push(element);
			else if (element is Boss)
				_boss = Boss(element);
			else
				_other.push(element);
				
			addChild(element);
		}
		
		public function removeElement(element:GameObject):void
		{
			var idx:int = 0;
			if (element is Platform)
			{
				idx = _platforms.indexOf(element);
				_platforms.splice(idx, 1);
			}
			else if (element is Item)
			{
				idx = _items.indexOf(element);
				_items.splice(idx, 1);
			}
			else if (element is Boss)
			{
				_boss = null;
			}
			else
			{
				idx = _other.indexOf(element);
				_other.splice(idx, 1);
			}

			removeChild(element);
			element.cleanup();
		}
		
		public function hasInput(input:int):Boolean
		{
			return false;
		}
		
		public function handlePlayerInput(player:Player):void
		{
		}
		
		public function isBossFight():Boolean
		{
			return _agent.stateMachine.currentState.name == LevelStates.BOSS_STAGE; 
		}
		
		public function changeState(name:String, force:Boolean = false):IState
		{
			if (states[name] == null)
			{
				trace("[Level] there is no state with name: " + name);
				return _agent.stateMachine.currentState;
			}
			
			return _agent.stateMachine.changeState(states[name], force);
		}
		
		public function update(diff:Number):void 
		{
			if (agent)
				agent.update(diff);
				
			if (player && player.isInTransitionState())
				return;
				
			if (player)
				handlePlayerInput(player);
			
			updatePlatforms(diff);
			updateItems(diff);
			updateBoss(diff);
			updateOther(diff);
			updatePlayer(diff);
		}
			
		public function checkShift():void
		{}
		
		public function setTarget():void
		{}
		
		protected function updatePlatforms(diff:Number):void
		{
			for each(var platform:Platform in _platforms)
			{
				if (Math.abs(player.position.x - platform.position.x) <= stage.stageWidth)
					platform.update(diff);
			}
		}
		
		protected function updateOther(diff:Number):void
		{
			for each(var other:GameObject in _other)
			{
				//if (Math.abs(player.position.x - other.position.x) <= stage.stageWidth)
					other.update(diff);
			}
		}
		
		protected function updateItems(diff:Number):void
		{
			for each(var item:GameObject in _items)
			{
				//if (Math.abs(player.position.x - item.position.x) <= stage.stageWidth)
					item.update(diff);
			}
		}
		
		protected function updateBoss(diff:Number):void
		{
			if (_boss != null)
				_boss.update(diff);
		}
		
		protected function updatePlayer(diff:Number):void
		{
			if (player != null)
				player.update(diff);
		}
		
		public function handleAssetsReloadProgress(ratio:Number):void 
		{
			if (ratio != 1)
				return;
				
			levelXML = null;
			 
			CollisionManager.instance.unregisterAll();
			LevelManager.instance.removeChild(this);
			
			removeChildren();
			
			for each(var platform:Platform in _platforms)
				platform.cleanup();
			
			for each(var item:GameObject in _items)
				item.cleanup();
				
			for each(var other:GameObject in _other)
				other.cleanup();
				
			if (_boss)
				_boss.cleanup();
			
			_boss = null;
			_other.splice(0, _other.length);
			
			_platforms.splice(0, _platforms.length);
			_items.splice(0, _items.length);

			atlases.splice(0, atlases.length);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			LevelManager.instance.addChild(this);
		}
		
		public function reloadLevel():void
		{
			
		}
		
		public function cleanup():void
		{
			removeChildren();
			
			_states = null;
						
			for each(var platform:Platform in _platforms)
				platform.cleanup();
			
			for each(var item:GameObject in _items)
				item.cleanup();
				
			for each(var other:GameObject in _other)
				other.cleanup();
				
			if (_boss)
				_boss.cleanup();
				
			_boss = null;

			for each (var atlas:TextureAtlas in atlases)
			{
				if (atlas.texture.name == "player")
					continue;
					
				GameManager.instance.assets.removeTextureAtlas(atlas.texture.name);
				atlas.dispose();
			}
				
			_atlases.splice(0, atlases.length);
			
			_platforms = null;
			_items = null;
			_other = null;
			
			_agent = null;
			_atlases = null;
			
			dispose();
		}
		
		public function get agent():Agent 
		{
			return _agent;
		}
		
		public function get states():Dictionary 
		{
			return _states;
		}
		
		public function get screenShiftLeft():int 
		{
			return _screenShiftLeft;
		}
		
		public function get screenShiftRight():int 
		{
			return _screenShiftRight;
		}
		
		public function get screenShiftDiff():int 
		{
			return _screenShiftDiff;
		}
		
		public function get bossStageStart():Point 
		{
			return _bossStageStart;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get boss():Boss 
		{
			return _boss;
		}
		
		public function get atlases():Vector.<TextureAtlas> 
		{
			return _atlases;
		}
	}
}