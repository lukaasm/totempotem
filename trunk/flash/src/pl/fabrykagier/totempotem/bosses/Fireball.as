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

	public class Fireball extends GameObject implements ICollidable
	{
		private var fall:Boolean;
		private var shape:BoundingSphere;
		
		public function Fireball(atlases:Vector.<TextureAtlas>) 
		{
			super(atlases);
			
			addAnimation(FireBossAnimations.FIREBALL_START);
			addAnimation(FireBossAnimations.FIREBALL_END);
			addAnimation(FireBossAnimations.FIREBALL_FLY);
			
			shape = new BoundingSphere(new Point(0, 200), 50);
			
			fall = true;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			playAnimation(FireBossAnimations.FIREBALL_START, nextAnimation, false);
			
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
			
			playAnimation(FireBossAnimations.FIREBALL_END, stopAnimation, false);
			
			fall = false;
			
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
			if (!fall)
				return;
				
			this.y += FireBossEncounter.FIREBALL_SPEED;
			shape.y = position.y;
			
			var collidable:Vector.<ICollidable> = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_PLAYER);
			if (collidable.length > 0)
				hitHandler(collidable[0], 0);
				
			collidable = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_PLATFORM);
			if (collidable.length > 0)
				hitHandler(collidable[0], 0);

			super.update(diff);
		}
	}
}