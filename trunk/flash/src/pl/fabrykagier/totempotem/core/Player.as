package pl.fabrykagier.totempotem.core 
{
	import flash.geom.*;
	import flash.utils.Dictionary;
	import mx.accessibility.ButtonAccImpl;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.*;
	import pl.fabrykagier.totempotem.physics.RigidBody;
	import pl.fabrykagier.totempotem.statemachine.*;
	import pl.fabrykagier.totempotem.states.playerstates.*;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class Player extends GameObject implements ICollidable
	{
		public var jumpCount:int;
		
		private var shootDelay:int;
		
		public var startPosition:Point;
		public var safePosition:Point;
		
		private var _direction:int;
		private var _prevDirection:int;
		private var _rigidBody:RigidBody;
		private var _bounds:Shape;
		private var _life:Life;
		private var _bullets:Vector.<Bullet>;
		
		protected var states:Dictionary;
		
		private var _doubleJumpEffect:Steam;
		private var previousAnimation:String;
		private var previousLooped:Boolean;

		public function Player()
		{
			var atlas:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlas.push(GameManager.instance.assets.getTextureAtlas("player"));
			
			super(atlas);

			safePosition = new Point;
			
			_bullets = new Vector.<Bullet>;
			_life = new Life(PlayerData.PLAYER_START_LIVES, this);
			
			_doubleJumpEffect = new Steam(atlas, 0.2, this);
			_doubleJumpEffect.alpha = 0.9;
			
			jumpCount = 0;
			
			_rigidBody = new RigidBody();
			
			_bounds = new BoundingSphere(new Point(this.x, this.y), GameData.PLAYER_RADIUS);
			
			addAnimation(Animations.ANIMATION_PLAYER_IDLE);
			addAnimation(Animations.ANIMATION_PLAYER_JUMP);
			addAnimation(Animations.ANIMATION_PLAYER_SLIDE);
			addAnimation(Animations.ANIMATION_PLAYER_MOVE, 48);
			addAnimation(Animations.ANIMATION_PLAYER_FALL);
			addAnimation(Animations.ANIMATION_PLAYER_ATTACK, 18);
			addAnimation(Animations.ANIMATION_PLAYER_TAKE_DAMAGE);
			addAnimation(Animations.ANIMATION_PLAYER_DIE_FROM_DAMAGE);
			addAnimation(Animations.ANIMATION_PLAYER_DIE);
			addAnimation(Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1);
			addAnimation(Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2);
			
			_agent = new Agent();
			
			states = new Dictionary();
			
			states[PlayerStates.STATE_PLAYER_IDLE] = new IdleState(this);
			states[PlayerStates.STATE_PLAYER_JUMPING] = new JumpingState(this);
			states[PlayerStates.STATE_PLAYER_JUMPING_STRAFE] = new StrafeJumpingState(this);
			states[PlayerStates.STATE_PLAYER_FALLING] = new FallingState(this);
			states[PlayerStates.STATE_PLAYER_FALLING_STRAFE] = new StrafeFallingState(this);
			states[PlayerStates.STATE_PLAYER_MOVING] = new MovingState(this);
			states[PlayerStates.STATE_PLAYER_SLIDING] = new SlidingState(this);
			states[PlayerStates.STATE_PLAYER_DYING] = new DyingState(this);
			states[PlayerStates.STATE_PLAYER_HURT] = new HurtState(this);
			states[PlayerStates.STATE_PLAYER_ATTACK] = new AttackState(this);
			states[PlayerStates.STATE_PLAYER_SLIDING_TRIANGLE] = new TriangleSlidingState(this);
			states[PlayerStates.STATE_PLAYER_TRANSITION] = new TransitionState(this);
			
			changeState(PlayerStates.STATE_PLAYER_IDLE);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			_direction = GameData.DIRECTION_RIGHT;
			
			rigidBody.initBody(new Vector3D(this.width/2, this.height/2, 0), GameData.PLAYER_MASS);
			rigidBody.initPosition(new Vector3D(this.position.x, this.position.y, 0), 0);
		}
		
		public override function playAnimation(name:String, callback:Function = null, loop:Boolean = true):void 
		{
			if (_direction == GameData.DIRECTION_LEFT)
				name += "_left";
				
			super.playAnimation(name, callback, loop);
		}
		
		public override function isAnimationInProgress(name:String = ""):Boolean
		{
			if (_direction == GameData.DIRECTION_LEFT && name != "")
				name += "_left";
							
			return super.isAnimationInProgress(name);
		}
		
		public function replaceAnimation(direction:int):void
		{
			var clip1:MovieClip = animationClip(currentAnimation);
			var clip2:MovieClip = null;
			
			if (direction == GameData.DIRECTION_LEFT)
				clip2 = animationClip(currentAnimation + "_left");
			else
			{
				var name:String = _currentAnimation.slice(0, _currentAnimation.length - 5);
				clip2 = animationClip(name);
			}
			
			switchAnimation(clip1, clip2);
		}
		
		public function noHitHandler(invoker:ICollidable):void
		{
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
		}
		
		public function changeState(name:String, force:Boolean = false):IState
		{
			if (states[name] == null)
			{
				trace("[Player] there is no state with name: " + name);
				return _agent.stateMachine.currentState;
			}
			
			return _agent.stateMachine.changeState(states[name], force);
		}
		
		public function shoot():void
		{
			var level:Level = LevelManager.instance.level;
			if (level.agent.stateMachine.currentState.name != LevelStates.BOSS_STAGE)
				return;
				
			if (_direction != GameData.DIRECTION_RIGHT)
				return;
				
			if (shootDelay > 0)
				return;
			
			shootDelay = PlayerData.PLAYER_SHOOT_DELAY;

			switch (level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					if (PlayerData.PLAYER_AMMO_EARTH_COUNT <= 0)
						return; 
					break;
				case BossData.TYPE_FIRE_BOSS:
					if (PlayerData.PLAYER_AMMO_FIRE_COUNT <= 0)
						return; 
					break;
			}
						
			changeState(PlayerStates.STATE_PLAYER_ATTACK);
		}
		
		private function restoreAnimation():void 
		{
			playAnimation(previousAnimation, null, previousLooped);
			shootDelay = PlayerData.PLAYER_SHOOT_DELAY;
		}
		
		public function isMoving():Boolean
		{
			var state:IState = agent.stateMachine.currentState;
			return state && state.activeTime >= 100 && 
					(state.name == PlayerStates.STATE_PLAYER_JUMPING_STRAFE || 
						state.name == PlayerStates.STATE_PLAYER_FALLING_STRAFE || 
						state.name == PlayerStates.STATE_PLAYER_MOVING);
		}
		
		public function isJumping():Boolean
		{
			var state:IState = agent.stateMachine.currentState;
			return state && 
				(state.name == PlayerStates.STATE_PLAYER_JUMPING || state.name == PlayerStates.STATE_PLAYER_JUMPING_STRAFE);
		}
		
		public function isInTransitionState():Boolean
		{
			var state:IState = agent.stateMachine.currentState;
			return state && (state.name == PlayerStates.STATE_PLAYER_TRANSITION);
		}
		
		public function isDying():Boolean
		{
			var state:IState = agent.stateMachine.currentState;
			return state && (state.name == PlayerStates.STATE_PLAYER_DYING);
		}
		
		public function isSliding():Boolean
		{
			var state:IState = agent.stateMachine.currentState;
			return state && (state.name == PlayerStates.STATE_PLAYER_SLIDING_TRIANGLE);
		}
		
		public function isFalling():Boolean
		{
			var state:IState = agent.stateMachine.currentState;
			return state && 
				(state.name == PlayerStates.STATE_PLAYER_FALLING || state.name == PlayerStates.STATE_PLAYER_FALLING_STRAFE);
		}
		
		public override function update(diff:Number):void
		{
			if (shootDelay > 0)
				shootDelay -= diff;
				
			this.x = int(rigidBody.position.x);
			this.y = int(rigidBody.position.y);
			
			safePosition.x = this.x;
			safePosition.y = this.y;
			
			rigidBody.update(diff);
			
			var colliding:Vector.<ICollidable>;
			colliding = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_PLATFORM);
			if (colliding.length > 0)
			{
				colliding.sort(Utils.shapeSort);
				
				for each (var ob:ICollidable in colliding)
				{
					var collisionSide:int = BoundingSphere(boundingShape).collisiongSide(ob.boundingShape);
					
					ob.hitHandler(this, collisionSide);
					hitHandler(ob, collisionSide);
					
					var state:IState = _agent.stateMachine.currentState;
					if (state && state is IPlayerState)
						IPlayerState(state).onCollision(ob, collisionSide);
				}
			}
			
			colliding = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_ITEM);
			if (colliding.length > 0)
			{
				for each (var ob2:ICollidable in colliding)
				{
					collisionSide = BoundingSphere(boundingShape).collisiongSide(ob2.boundingShape);
					
					ob2.hitHandler(this, collisionSide);
					hitHandler(ob2, collisionSide);
					
					state = _agent.stateMachine.currentState;
					if (state && state is IPlayerState)
						IPlayerState(state).onCollision(ob2, collisionSide);
				}
			}
			
			for each (var b:Bullet in bullets)
				b.update(diff);
			
			if (LevelManager.instance.level.boss != null)
			{
				colliding = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_BOSS_ATTACK);
				if (colliding.length > 0)
				{
					for each (var ob3:ICollidable in colliding)
					{
						collisionSide = BoundingSphere(boundingShape).collisiongSide(ob3.boundingShape);
						
						ob3.hitHandler(this, collisionSide);
						hitHandler(ob3, collisionSide);
						
						state = _agent.stateMachine.currentState;
						if (state && state is IPlayerState)
							IPlayerState(state).onCollision(ob3, collisionSide);
					}
				}
			}
			
			agent.update(diff);

			super.update(diff);
		}
		
		public function reset():void
		{
			rigidBody.position.x = startPosition.x;
			rigidBody.position.y = startPosition.y;
			
			CollisionManager.instance.register(ICollidable(this));
			
			changeState(PlayerStates.STATE_PLAYER_IDLE);
		}
		
		public function doubleJump():void
		{
			SoundManager.instance.playSound(SoundsData.PLAYER_DOUBLE_JUMP, 0, 0.2 * SoundsData.MUTE_SOUND);
			_doubleJumpEffect.doubleJump();
		}
		
		public function strafe():void
		{
			var speed:Number = GameData.VELOCITY_LIMIT_STRAFE;
			if (isJumping() || isFalling())
				speed = GameData.VELOCITY_LIMIT_STRAFE_MIDAIR;
				
			if (Math.abs(rigidBody.velocity.x) < speed)
				rigidBody.addForce(direction == GameData.DIRECTION_LEFT ? GameData.FORCE_MOVE_LEFT : GameData.FORCE_MOVE_RIGHT);
		}
		
		public function slide():void
		{
			if (_direction == GameData.DIRECTION_LEFT)
				rigidBody.addForce(GameData.FORCE_FRICTION_LEFT);
			else
				rigidBody.addForce(GameData.FORCE_FRICTION_RIGHT);
		}
		
		public function slideTriangle():void
		{
			if (_direction == GameData.DIRECTION_LEFT)
				rigidBody.addForce(GameData.FORCE_FRICTION_LEFT);
			else
				rigidBody.addForce(GameData.FORCE_FRICTION_RIGHT);
		}
		
		public function get boundingShape():Shape
		{
			_bounds.x = position.x;
			_bounds.y = position.y;
			
			return _bounds;
		}
		
		public function get collisionGroup():String
		{
			return CollisionData.COLLISION_GROUP_PLAYER;
		}
		
		public override function get rigidBody():RigidBody
		{
			return _rigidBody;
		}
		
		public override function get position():Point
		{
			if (parent)
			{
				_position.x = int(parent.x + rigidBody.position.x);
				_position.y = int(parent.y + rigidBody.position.y);
			}	
			return _position;
		}
		
		public function get life():Life 
		{
			return _life;
		}
		
		public function get direction():int 
		{
			return _direction;
		}
		
		public function set direction(value:int):void 
		{
			if (_direction != value)
			{
				rigidBody.velocity.x = 0;
				replaceAnimation(value);
			}
			
			_prevDirection = _direction;
			_direction = value;
		}
		
		public function get prevDirection():int 
		{
			return _prevDirection;
		}
		
		public function get bullets():Vector.<Bullet> 
		{
			return _bullets;
		}
		
		public function get doubleJumpEffect():Steam 
		{
			return _doubleJumpEffect;
		}

		public override function cleanup():void
		{
			removeChildren();
			
			CollisionManager.instance.unregister(this);
			
			_rigidBody.clean();
			_rigidBody = null;
			
			_bounds = null;
			
			super.cleanup();
		}
	}
}