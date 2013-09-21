package pl.fabrykagier.totempotem.bosses 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import pl.fabrykagier.totempotem.behaviours.AddAmmoBehaviour;
	import pl.fabrykagier.totempotem.behaviours.DisappearBehaviour;
	import pl.fabrykagier.totempotem.behaviours.IBehaviour;
	import pl.fabrykagier.totempotem.behaviours.MoveBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransparentBehaviour;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Bullet;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.core.Life;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.PlatformMovementDirection;
	import pl.fabrykagier.totempotem.data.PlatformMovementType;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class Boss extends GameObject implements ICollidable
	{
		private var behaviours:Vector.<IBehaviour>;
		
		private var spawnAmmoTimer:int;
		
		private var nolives:Vector.<GameObject>;
		private var lives:Vector.<GameObject>;
		private var lifeSprite:GameObject;
		
		protected var _bounds:Shape;
		
		public var type:String;
		public var size:Point;
		
		protected var _life:Life;
		
		protected var states:Dictionary;
		
		public function Boss(atlases:Vector.<TextureAtlas>=null, w:int = 0, h:int = 0)
		{
			super(atlases);
			
			lives = new Vector.<GameObject>;
			nolives = new Vector.<GameObject>;
			behaviours = new Vector.<IBehaviour>;
			
			if (w != 0 && h != 0)
				size = new Point(w, h);
			else
				size = new Point(width, height);
				
			spawnAmmoTimer = GameData.AMMO_SPAWN_TIMER;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function spawnAmmo():void
		{
			var ammoCount:int = PlayerData.PLAYER_AMMO_EARTH_COUNT;
			var ammoName:String = "ammo_earth";
			if (type == BossData.TYPE_FIRE_BOSS)
			{
				ammoCount = PlayerData.PLAYER_AMMO_FIRE_COUNT;
				ammoName = "ammo_fire";
			}
				
			if (ammoCount > 0)
			{
				spawnAmmoTimer = GameData.AMMO_SPAWN_TIMER;
				return;
			}
				
			var plr:Player = GameManager.instance.player;
			var item:Item = new Item(plr.atlases, ammoName);
			item.x = this.x - 700;
			item.y = this.y;
			
			item.addBehaviour(new TransparentBehaviour(item, new Point(0, 0), new Point(50, 50), CollisionData.COLLISION_GROUP_ITEM));
			item.addBehaviour(new AddAmmoBehaviour());
			item.addBehaviour(new DisappearBehaviour(item, GameData.ITEM_DISAPPEAR_TIME));
			item.addBehaviour(new MoveBehaviour(item, PlatformMovementDirection.LEFT, 150, 0.3));
			item.addBehaviour(new MoveBehaviour(item, PlatformMovementDirection.DOWN, 150, 0.3));
			
			LevelManager.instance.level.addElement(item);
			spawnAmmoTimer = GameData.AMMO_SPAWN_TIMER;
		}
		
		private function takeLife():void
		{
			var life:GameObject = lives[0];
			lifeSprite.removeChild(life);
			lives.splice(0, 1);
		}
		
		private function addHUDHealth():void
		{
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlases.push(GameManager.instance.assets.getTextureAtlas("player"));
			
			lifeSprite = new GameObject(atlases, "HUD body");
			lifeSprite.y = stage.stageHeight - lifeSprite.height / 2;
			
			var lifeCount:int = type == BossData.TYPE_EARTH_BOSS ? BossData.EARTH_BOSS_START_LIVES : BossData.FIRE_BOSS_START_LIVES;
			var offset:int = stage.stageWidth;

			for (var i:int = 0; i < lifeCount; ++i)
			{
				var nolife:GameObject = new GameObject(atlases, "boss life none");
				var life:GameObject = new GameObject(atlases, (type == BossData.TYPE_EARTH_BOSS ? "boss life earth" : "boss life fire"));
				
				life.y = 0;//lifeSprite.height / 2;
				nolife.y = 0;// lifeSprite.height / 2;
				
				life.x = stage.stageWidth - offset;
				nolife.x = stage.stageWidth - offset;
				
				lifeSprite.addChild(nolife);
				lifeSprite.addChild(life);

				nolives.push(nolife);
				lives.push(life);
				
				offset -= life.width + 2;
			}
			lifeSprite.x = stage.stageWidth - lifeSprite.width/2 - 100;

			GameManager.instance.addChild(lifeSprite);
		}
		
		public function startFight():void
		{
			addHUDHealth();
		}
		
		public function isIdle():Boolean
		{
			return agent && agent.stateMachine.currentState && agent.stateMachine.currentState.name == BossStates.IDLE;
		}
		
		public function isResting():Boolean
		{
			return agent && agent.stateMachine.currentState && agent.stateMachine.currentState.name == BossStates.RESTING;
		}
		
		public function isDying():Boolean
		{
			return agent && agent.stateMachine.currentState && agent.stateMachine.currentState.name == BossStates.DYING;
		}
		
		private function onAddedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			for each (var behaviour:IBehaviour in behaviours) 
			{
				if (behaviour is ICollidable)
					CollisionManager.instance.register(ICollidable(behaviour));
			}
		}
		
		public function get boundingShape():Shape 
		{
			_bounds.x = this.x;
			_bounds.y = this.y;
			
			return _bounds;
		}
		
		public function get collisionGroup():String 
		{
			return CollisionData.COLLISION_GROUP_BOSS;
		}
		
		public function get life():Life 
		{
			return _life;
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void 
		{
			if (invoker is Player)
			{
				Player(invoker).life.subLife(1);
				
				if (Player(invoker).life.lives <= 0)
					handlePlayerDeath();
			}
			else if (invoker is Bullet)
			{
				if (life.lives <= 0)
					return;
					
				takeLife();
				
				var tween:Tween = new Tween(this, 0.5, Transitions.EASE_IN_OUT_BOUNCE);
				tween.fadeTo(0.2);
				
				var tween2:Tween = new Tween(this, 0.5, Transitions.EASE_IN_OUT_BOUNCE);
				tween2.fadeTo(1.0);
				
				tween.onComplete = Starling.juggler.add;
				tween.onCompleteArgs = [tween2];
				
				Starling.juggler.add(tween);

				life.subLife(1);
				if (life.lives <= 0)
				{
					GameManager.instance.removeChild(lifeSprite);
					changeState(BossStates.DYING);
				}
				else if (isIdle() || isResting())
					changeState(BossStates.WOUNDED);
			}
		}
		
		public function noHitHandler(invoker:ICollidable):void 
		{
			
		}
		
		public function handlePlayerDeath():void
		{
			
		}
		
		public override function update(diff:Number):void
		{
			agent.update(diff);
			
			if (isDying())
				return;
				
			if (spawnAmmoTimer <= diff)
				spawnAmmo();
			else
				spawnAmmoTimer -= diff;
		}
		
		public function changeState(name:String, force:Boolean = false):IState
		{
			if (isDying())
				return null;
				
			if (states[name] == null)
			{
				trace("[Boss] there is no state with name: " + name);
				return _agent.stateMachine.currentState;
			}
			
			return _agent.stateMachine.changeState(states[name], force);
		}
		
		public function addBehaviour(behaviour:IBehaviour):void
		{
			if (behaviour != null)
				behaviours.push(behaviour);
		}
	}
}