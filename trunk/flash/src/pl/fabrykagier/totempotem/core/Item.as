package pl.fabrykagier.totempotem.core 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.behaviours.IBehaviour;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class Item extends GameObject implements ICollidable
	{
		public var behaviours:Vector.<IBehaviour>;
		public var size:Point;
		
		public function Item(atlases:Vector.<TextureAtlas>, textureName:String, w:int = 0, h:int = 0)
		{
			super(atlases, textureName);
			
			behaviours = new Vector.<IBehaviour>();

			if (w != 0 && h != 0)
				size = new Point(w, h);
			else
				size = new Point(width, height);
				
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
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
			return null;
		}
		
		public function addBehaviour(behaviour:IBehaviour):void
		{
			if (behaviour != null)
				behaviours.push(behaviour);
		}
		
		public function get collisionGroup():String
		{
			return CollisionData.COLLISION_GROUP_ITEM;
		}
		
		public function noHitHandler(invoker:ICollidable):void
		{
			for each(var behaviour:IBehaviour in behaviours) 
			{
				behaviour.onNoCollision(invoker);
			}
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
			for each(var behaviour:IBehaviour in behaviours)
			{
				behaviour.onCollision(invoker, collisionSide);
			}
		}
		
		public override function update(diff:Number):void
		{
			for each (var behaviour:IBehaviour in behaviours) 
			{
				behaviour.update(diff);
			}
		}
		
		public override function cleanup():void
		{
			removeChildren();

			for each (var behaviour:IBehaviour in behaviours) 
			{
				if (behaviour is ICollidable)
					CollisionManager.instance.unregister(ICollidable(behaviour));
			}
			
			super.cleanup();
		}
	}
}