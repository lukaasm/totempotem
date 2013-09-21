package pl.fabrykagier.totempotem.level 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.assets.EarthAssets;
	import pl.fabrykagier.totempotem.assets.EarthBossAssets;
	import pl.fabrykagier.totempotem.behaviours.*;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.EarthBoss;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.core.XMLUtils;
	import pl.fabrykagier.totempotem.data.BehaviourType;
	import pl.fabrykagier.totempotem.data.PlatformMovementDirection;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IPlayerState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class EarthLevel extends Level 
	{
		private var moveStateTime:Number;
		
		public function EarthLevel() 
		{
			super();
			
			_type = BossData.TYPE_EARTH_BOSS;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		public override function reloadLevel():void
		{
			GameManager.instance.assets.removeXml("level_earth_design");
			GameManager.instance.assets.enqueue("C:/level_earth_design.xml");
			
			GameManager.instance.assets.loadQueue(handleAssetsReloadProgress);
		}
			
		public override function loadBossAssets():void
		{
			trace("Loading earth boss assets!");
			
			super.loadBossAssets();

			GameManager.instance.assets.enqueue(EarthBossAssets);
			GameManager.instance.assets.loadQueue(onBossAssetsLoadProgresshandler);
		}
		
		public override function loadAssets(callback:Function):void
		{
			trace("Loading earth assets!");
			
			GameManager.instance.assets.enqueue(EarthAssets);
			GameManager.instance.assets.loadQueue(callback);
		}
		
		public override function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("player"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_0"));
			
			if (Debug.DEBUG_LEVEL_LITE == false)
				atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_1"));
			
			if (levelXML == null)
				levelXML = GameManager.instance.assets.getXml("level_earth_design");

			super.onAddedToStageHandler(e);
		}
		
		public override function createBoss():void
		{
			for each(var xml:XML in levelXML.elements("Boss"))
			{
				var boss:Boss = XMLUtils.createBoss(xml);
				addElement(boss);
			}
		}
		
		public override function checkShift():void
		{
			shift += GameData.SCREEN_SHIFT * -player.direction;
			shift = Math.max(shift, 0);
			shift = Math.min(shift, 1);
		}
		
		public override function setTarget():void
		{
			//target.x = int( -player.x + screenShiftLeft + int(screenShiftDiff * shift));
			target.x = int( -player.x + screenShiftLeft);
		}
		
		public override function hasInput(input:int):Boolean
		{
			return (prevInput & input) != 0;
		}
		
		public override function handlePlayerInput(player:Player):void
		{
			var currInput:int = GameManager.instance.input.state;
			
			var state:IState = player.agent.stateMachine.currentState;
			
			if(state &&  state.name == PlayerStates.STATE_PLAYER_TRANSITION)
				return
				
			player.rigidBody.addForce(GameData.FORCE_GRAVITY);

			if(state &&  state.name == PlayerStates.STATE_PLAYER_HURT)
				return
			
			if (state && state.name == PlayerStates.STATE_PLAYER_DYING) 
				return;
				
			if ((currInput & Controls.CONTROL_UP) && !(prevInput & Controls.CONTROL_UP))
			{
				var nextState:String = PlayerStates.STATE_PLAYER_JUMPING;
				if (currInput & (Controls.CONTROL_RIGHT | Controls.CONTROL_LEFT))
					nextState = PlayerStates.STATE_PLAYER_JUMPING_STRAFE;
					
				state = player.changeState(nextState);
				
				if (state is IPlayerState)
					IPlayerState(state).onData(0, 0);
			}
			
			if ((currInput & (Controls.CONTROL_RIGHT | Controls.CONTROL_LEFT)) != (prevInput & (Controls.CONTROL_RIGHT | Controls.CONTROL_LEFT)))
			{
				var pressed:Boolean = (currInput & (Controls.CONTROL_LEFT | Controls.CONTROL_RIGHT)) != 0;
				
				nextState = pressed ? PlayerStates.STATE_PLAYER_MOVING : PlayerStates.STATE_PLAYER_SLIDING;

				if (player.isJumping())
					nextState = pressed ? PlayerStates.STATE_PLAYER_JUMPING_STRAFE : PlayerStates.STATE_PLAYER_JUMPING;
				else if (player.isFalling())
					nextState = pressed ? PlayerStates.STATE_PLAYER_FALLING_STRAFE : PlayerStates.STATE_PLAYER_FALLING;
				else if (!pressed && Math.abs(player.rigidBody.velocity.x) <= GameData.VELOCITY_STRAFE_TO_SLIDE)
					nextState = PlayerStates.STATE_PLAYER_IDLE;
					
				if (currInput & Controls.CONTROL_RIGHT)
					player.direction = GameData.DIRECTION_RIGHT;
				else if (currInput & Controls.CONTROL_LEFT)
					player.direction = GameData.DIRECTION_LEFT;
					
				player.changeState(nextState);
			}
			
			if ((currInput & Controls.CONTROL_SHOOT)/* && !(prevInput & Controls.CONTROL_SHOOT)*/)
				player.shoot();
			
			prevInput = currInput;
		}
	}
}