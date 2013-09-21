package pl.fabrykagier.totempotem.behaviours 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Steam;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.PlatformMovementDirection;
	import pl.fabrykagier.totempotem.data.PlatformMovementType;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	
	public class CrashBehaviour implements IBehaviour
	{
		private var owner:GameObject;
		
		private var moveType:String;
		
		private var startPosition:Point;
		private var stopPosition:Point;
		private var moveDirection:Point;
		private var startMoveDirection:Point;
		private var endPosition:Point;
		private var localPos:Point;
		
		private var platformSpeed:Number;
		private var smooth:Number;
		private var distance:Number;
		private var newDistance:Number;
		private var subDistance:Number;
		
		private var crashEffect:Function;
		private var smokeEffect:Steam;
		
		private var delayDelta:Number;
		private var delay:Number;
		
		public function CrashBehaviour(owner:GameObject, moveDirection:Point, shift:int, platformSpeed:Number, delay:Number) 
		{
			this.owner = owner;
			this.smooth = 1;
			
			delayDelta = 0;
			
			owner.addAnimation(owner.name);
			
			var shiftWithDirection:Point;
			
			crashEffect = moveFast;
			smokeEffect = new Steam(GameManager.instance.player.atlases, 0.5, owner);
			LevelManager.instance.level.addChild(smokeEffect);
			
			this.startPosition = new Point(this.owner.x, this.owner.y);
			shiftWithDirection =  Utils.multiplyPointNum(moveDirection, shift);
			this.stopPosition = Utils.addPointPoint(startPosition, shiftWithDirection);
			
			this.endPosition = stopPosition;
			this.moveDirection = moveDirection;
			this.startMoveDirection = moveDirection;
			this.platformSpeed = platformSpeed;
			this.delay = delay;
			
			this.localPos = new Point(0,0);
			
			if(moveDirection==PlatformMovementDirection.UP || moveDirection==PlatformMovementDirection.DOWN)
				this.moveType = PlatformMovementType.VERTICAL;
				
			this.distance = Utils.magPointPoint(startPosition, stopPosition);
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
		}
		
		public function update(diff:Number):void
		{
			delayDelta += diff;
			
			if (delayDelta >= delay)
			{
				crashEffect();
				checkMoveDirection();
			
				var moveY:int = int(moveDirection.y * diff * platformSpeed * smooth);
				
				if(moveType == PlatformMovementType.VERTICAL)
					owner.y += moveY == 0 ? moveDirection.y : moveY;
			}
		}
		
		private function moveFast():void
		{
			smooth = 1;
		}
		
		private function activateSmoke():void
		{
			smokeEffect.doubleJump();
			
			if(Utils.magPointPoint(owner.position, GameManager.instance.player.position) < 800)
				SoundManager.instance.playSound(SoundsData.PLATFORM_CRASH, 0, 1 * SoundsData.MUTE_SOUND);
			
			owner.stopAnimation();
			owner.playAnimation(owner.name, null, false);
			
			crashEffect = moveSlow;
		}
		
		private function moveSlow():void
		{
			smooth = 0.2;
		}
		
		private function checkMoveDirection():void 
		{
			if (moveType == PlatformMovementType.VERTICAL)
			{
				if (stopPosition.y < startPosition.y)
				{
					if (owner.y < stopPosition.y) 
					{
						crashEffect = moveFast;
						
						Platform(owner).kill = true;
						moveDirection = PlatformMovementDirection.DOWN;
						endPosition = stopPosition;
					}
					else if (owner.y > startPosition.y)
					{
						crashEffect = activateSmoke;
						
						Platform(owner).kill = false;
						moveDirection = PlatformMovementDirection.UP;
						endPosition = startPosition;
					}
				}
				else if (stopPosition.y > startPosition.y)
				{
					if (owner.y > stopPosition.y)
					{
						crashEffect = activateSmoke;
						
						Platform(owner).kill = false;
						moveDirection = PlatformMovementDirection.UP;
						endPosition = stopPosition;
					}
					else if (owner.y < startPosition.y)
					{
						crashEffect = moveFast;
						
						Platform(owner).kill = true;
						moveDirection = PlatformMovementDirection.DOWN;
						endPosition = startPosition;
					}
				}
			}
		}
	}
}