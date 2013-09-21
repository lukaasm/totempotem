package pl.fabrykagier.totempotem.managers 
{
	import flash.utils.Dictionary;
	import pl.fabrykagier.totempotem.behaviours.IBehaviour;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.collisions.BoundingSphere;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.statemachine.IPlayerState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import starling.display.Sprite;
	
	public class CollisionManager 
	{
		private static var _instance:CollisionManager;
		private var objects:Dictionary;
		private var _debugSprite:Sprite;
		
		public function CollisionManager() 
		{
			_instance = this;
			
			_debugSprite = new Sprite();
			
			objects = new Dictionary;
		}
		
		public function register(element:ICollidable):void 
		{
			if (objects[element.collisionGroup] == null)
				objects[element.collisionGroup] = new Vector.<ICollidable>;
				
			var idx:int = objects[element.collisionGroup].indexOf(element);
			if (idx > 0 )
				return;
				
			objects[element.collisionGroup].push(element);
		}
		
		public function unregister(element:ICollidable):void 
		{
			if (element is Platform)
			{
				for each (var coll:IBehaviour in Platform(element).behaviours)
				{
					if (coll is ICollidable)
						unregister(ICollidable(coll));
				}
			}
			else if (element is Item)
			{
				for each (var coll2:IBehaviour in Item(element).behaviours)
				{
					if (coll2 is ICollidable)
						unregister(ICollidable(coll2));
				}
			}
			
			if (objects[element.collisionGroup] == null)
				return;
				
			var idx:int = objects[element.collisionGroup].indexOf(element);
			if (idx < 0 )
				return;
				
			objects[element.collisionGroup].splice(idx, 1);
			
			_debugSprite.removeChildren();
		}
		
		public function unregisterAll():void
		{
			objects = new Dictionary;
			_debugSprite.removeChildren();
		}
		
		public function intersectionTest(element:ICollidable, group:String):Vector.<ICollidable>
		{
			var colliding:Vector.<ICollidable> = new Vector.<ICollidable>;
			
			if (objects[element.collisionGroup] == null || objects[element.collisionGroup].indexOf(element) < 0)
				return colliding;
			
			if (element.boundingShape is BoundingSphere)
			{
				var bsphere:BoundingSphere = BoundingSphere(element.boundingShape);
				for each (var ob:ICollidable in objects[group])
				{
					if (ob == element)
						continue;
						
					if (Math.abs(bsphere.x - ob.boundingShape.x) >= ob.boundingShape.width + bsphere.radius)
						continue;
						
					if (bsphere.intersects(ob.boundingShape))
						colliding.push(ob);
					else
						ob.noHitHandler(element);
				}
				
				return colliding;
			}
			
			return colliding;
		}

		public function update(diff:Number):void
		{
			if (!Debug.DEBUG_DRAW_COLLISION)
				return;
				
			_debugSprite.removeChildren();
			
			for each (var vec:Vector.<ICollidable> in objects)
			{
				for each (var ob:ICollidable in vec)
					_debugSprite.addChild(ob.boundingShape);
			}
		}
		
		public static function get instance():CollisionManager
		{
			return _instance;
		}
		
		public function get debugSprite():Sprite 
		{
			return _debugSprite;
		}
	}
}