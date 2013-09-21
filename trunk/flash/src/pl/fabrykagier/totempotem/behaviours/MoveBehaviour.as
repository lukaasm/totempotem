package pl.fabrykagier.totempotem.behaviours 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.PlatformMovementDirection;
	import pl.fabrykagier.totempotem.data.PlatformMovementType;
	
	public class MoveBehaviour implements IBehaviour
	{
		private var owner:GameObject;
		
		private var moveType:String;
		
		private var startPosition:Point;
		private var stopPosition:Point;
		private var moveDirection:Point;
		private var endPosition:Point;
		private var localPos:Point;
		
		private var platformSpeed:Number;
		private var smooth:Number;
		private var distance:Number;
		private var newDistance:Number;
		private var subDistance:Number;
		
		public function MoveBehaviour(owner:GameObject, moveDirection:Point, shift:int, platformSpeed:Number) 
		{
			this.owner = owner;
			this.smooth = 1;
			
			var shiftWithDirection:Point;
			
			if (moveDirection == PlatformMovementDirection.LEFT)
			{
				this.stopPosition = new Point(this.owner.x, this.owner.y);
				shiftWithDirection =  Utils.multiplyPointNum(PlatformMovementDirection.RIGHT, shift);
				this.startPosition = Utils.addPointPoint(stopPosition, shiftWithDirection);
				
				owner.x = startPosition.x;
				owner.y = startPosition.y;
			}
			else
			{
				this.startPosition = new Point(this.owner.x, this.owner.y);
				shiftWithDirection =  Utils.multiplyPointNum(moveDirection, shift);
				this.stopPosition = Utils.addPointPoint(startPosition, shiftWithDirection);
			}
			
			this.endPosition = stopPosition;
			this.moveDirection = moveDirection;
			this.platformSpeed = platformSpeed;
			
			this.localPos = new Point(0,0);
			
			if(moveDirection==PlatformMovementDirection.RIGHT || moveDirection==PlatformMovementDirection.LEFT)
				this.moveType = PlatformMovementType.HORIZONTAL;
			else if(moveDirection==PlatformMovementDirection.UP || moveDirection==PlatformMovementDirection.DOWN)
				this.moveType = PlatformMovementType.VERTICAL;
			else
				this.moveType = PlatformMovementType.BOTH;
				
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
			checkMoveDirection();
			checkSmoothValue();
			
			var moveX:int = int(moveDirection.x * diff * platformSpeed * smooth);
			var moveY:int = int(moveDirection.y * diff * platformSpeed * smooth);
			
			if(moveType == PlatformMovementType.HORIZONTAL)
				owner.x += moveX == 0 ? moveDirection.x : moveX;
			if(moveType == PlatformMovementType.VERTICAL)
				owner.y += moveY == 0 ? moveDirection.y : moveY;
		}
		
		private function checkMoveDirection():void 
		{
			if (moveType == PlatformMovementType.HORIZONTAL)
			{
				if (stopPosition.x > startPosition.x)
				{
					if (owner.x > stopPosition.x)
					{
						moveDirection = PlatformMovementDirection.LEFT;
						endPosition = startPosition;
					}
					else if (owner.x < startPosition.x)
					{
						moveDirection = PlatformMovementDirection.RIGHT;
						endPosition = stopPosition;
					}
				}
				else if (stopPosition.x < startPosition.x)
				{
					if (owner.x < stopPosition.x)
					{
						moveDirection = PlatformMovementDirection.RIGHT;
						endPosition = startPosition;
					}
					else if (owner.x > startPosition.x)
					{
						moveDirection = PlatformMovementDirection.LEFT;
						endPosition = stopPosition;
					}
				}
			}
			else if (moveType == PlatformMovementType.VERTICAL)
			{
				if (stopPosition.y < startPosition.y)
				{
					if (owner.y < stopPosition.y) 
					{
						moveDirection = PlatformMovementDirection.DOWN;
						endPosition = stopPosition;
					}
					else if (owner.y > startPosition.y)
					{
						moveDirection = PlatformMovementDirection.UP;
						endPosition = startPosition;
					}
				}
				else if (stopPosition.y > startPosition.y)
				{
					if (owner.y > stopPosition.y)
					{
						moveDirection = PlatformMovementDirection.UP;
						endPosition = stopPosition;
					}
					else if (owner.y < startPosition.y)
					{
						moveDirection = PlatformMovementDirection.DOWN;
						endPosition = startPosition;
					}
				}
			}
			else if (moveType == PlatformMovementType.BOTH)
			{
				// TODO: jak bedzie potrzebny to sie dorobi
			}
		}
		
		private function checkSmoothValue():void 
		{
			localPos.x = owner.x;
			localPos.y = owner.y;
			
			newDistance = Utils.magPointPoint(localPos, endPosition);
			subDistance = distance - newDistance;
			
			if (newDistance < distance * 0.1 || subDistance < distance * 0.1)
				smooth = 0.25;
			else if (newDistance < distance * 0.2 || subDistance < distance * 0.2)
				smooth = 0.5;
			else if (newDistance < distance * 0.35 || subDistance < distance * 0.35)
				smooth = 0.75;
			else
				smooth = 1;
		}
	}

}