package pl.fabrykagier.totempotem.core 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.collisions.BoundingSphere;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class Bullet extends GameObject implements ICollidable
	{
		private var shape:BoundingSphere;
		
		public function Bullet(atlases:Vector.<TextureAtlas>, texture:String) 
		{
			super(atlases, texture);
			
			shape = new BoundingSphere(new Point(0, 0), 20);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		public function get boundingShape():Shape
		{
			shape.x = position.x;
			shape.y = position.y;
			
			return shape;
		}
		
		public function get collisionGroup():String
		{
			return CollisionData.COLLISION_GROUP_PLAYER_ATTACK;
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
			var plr:Player = LevelManager.instance.level.player;
			var idx:int = plr.bullets.indexOf(this);
			if (idx >= 0)
				plr.bullets.splice(idx, 1);
				
			CollisionManager.instance.unregister(this);
			GameManager.instance.removeChild(this);
		}
		
		public function noHitHandler(invoker:ICollidable):void
		{
			
		}
		
		public override function update(diff:Number):void
		{
			this.x += PlayerData.PLAYER_BULLET_SPEED;
			shape.x = position.x;
			
			this.rotation += 0.1;
			
			var collidable:Vector.<ICollidable> = CollisionManager.instance.intersectionTest(this, CollisionData.COLLISION_GROUP_BOSS);
			if (collidable.length > 0)
			{
				collidable[0].hitHandler(this, 0);
				this.hitHandler(collidable[0], 0);
			}
			
			super.update(diff);
		}
	}
}