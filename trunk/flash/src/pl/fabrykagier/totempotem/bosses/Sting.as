package pl.fabrykagier.totempotem.bosses 
{
	import flash.geom.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossEncounter;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;

	public class Sting extends GameObject implements ICollidable
	{
		private var shape:BoundingSphere;
		
		public function Sting(atlases:Vector.<TextureAtlas>) 
		{
			super(atlases, "spike");
			
			shape = new BoundingSphere(new Point(0, 0), 30);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			CollisionManager.instance.register(this);
		}
		
		public function nextAnimation():void
		{
			playAnimation(FireBossAnimations.FIREBALL_FLY);
		}
		
		public function get boundingShape():Shape
		{
			shape.x = position.x;
			shape.y = position.y;
			
			return shape;
		}
		
		public function get collisionGroup():String
		{
			return CollisionData.COLLISION_GROUP_BOSS_ATTACK;
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
			CollisionManager.instance.unregister(this);
			
			if (invoker is Player)
			{
				Player(invoker).changeState(PlayerStates.STATE_PLAYER_HURT);
				LevelManager.instance.level.boss.hitHandler(invoker, collisionSide);
			}
		}
		
		public function noHitHandler(invoker:ICollidable):void
		{
			
		}
		
		override public function update(diff:Number):void 
		{
			this.x += FireBossEncounter.STING_SPEED;
			shape.x = position.x;
			
			var collidable:Vector.<ICollidable> = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_PLAYER);
			if (collidable.length > 0)
				hitHandler(collidable[0], 0);
				
			//var collidable:Vector.<ICollidable> = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_PLATFORM);
			//if (collidable.length > 0)
				//hitHandler(collidable[0], 0);

			super.update(diff);
		}
	}

}