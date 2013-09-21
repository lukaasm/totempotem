package pl.fabrykagier.totempotem.level 
{
	import flash.geom.*;
	import pl.fabrykagier.totempotem.behaviours.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.managers.*;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	
	public class Platform extends GameObject implements ICollidable
	{
		public var behaviours:Vector.<IBehaviour>;
		public var size:Point;
		private var _name:String;
		public var kill:Boolean;
		
		public function Platform(atlases:Vector.<TextureAtlas>, textureName:String, w:int = 0, h:int = 0) 
		{
			super(atlases, textureName);
			
			kill = true;
			behaviours = new Vector.<IBehaviour>();
			
			size = new Point(w, h);
			if (w == 0)
				size.x = width;
				
			if (h == 0)
				size.y = height;
				
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

		public function noHitHandler(invoker:ICollidable):void
		{
			for each(var behaviour:IBehaviour in behaviours) 
				behaviour.onNoCollision(invoker);
		}
		
		public function hitHandler(invoker:ICollidable, collisionSide:int):void
		{
			for each(var behaviour:IBehaviour in behaviours) 
				behaviour.onCollision(invoker, collisionSide);
		}
		
		public function addBehaviour(behaviour:IBehaviour):void
		{
			if (behaviour != null)
				behaviours.push(behaviour);
		}
		
		public override function update(diff:Number):void
		{
			for each (var behaviour:IBehaviour in behaviours) 
				behaviour.update(diff);
		}
			
		public override function cleanup():void
		{
			removeChildren();
			
			for each (var behaviour:IBehaviour in behaviours) 
			{
				if (behaviour is ICollidable)
				{
					CollisionManager.instance.unregister(ICollidable(behaviour));
					ICollidable(behaviour).boundingShape.dispose();
				}
			}
			
			behaviours.splice(0, behaviours.length);
			
			super.cleanup();
		}
		
		public function get boundingShape():Shape
		{
			return null;
		}
		
		public function get collisionGroup():String
		{
			return CollisionData.COLLISION_GROUP_PLATFORM;
		}
	}
}