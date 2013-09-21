package pl.fabrykagier.totempotem.core 
{
	import flash.geom.*;
	import flash.utils.*;
	import pl.fabrykagier.totempotem.behaviours.*;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.EarthBoss;
	import pl.fabrykagier.totempotem.bosses.FireBoss;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.level.*;
	import starling.textures.*;
	public class XMLUtils 
	{
		public static function createPlatform(atlases:Vector.<TextureAtlas>, xml:XML):Platform
		{
			var texture:String = xml.attribute("texture");
			var width:int = xml.attribute("width") * GameData.PLATFORM_HEIGHT;
			var height:int = xml.attribute("height") * GameData.PLATFORM_SPACE;
			
			var platform:Platform = new Platform(atlases, texture, width, height);
			platform.x = xml.attribute("x") * GameData.PLATFORM_HEIGHT;
			platform.y = xml.attribute("y") * GameData.PLATFORM_SPACE;
			platform.name = texture;
			
			var collider:IBehaviour = new SolidBehaviour(platform, new Point(0, 0), platform.size, platform.collisionGroup, xml.attribute("shape"));
			var hasCollider:Boolean = false;
			
			for each (var behaviour:XML in xml.elements("Behaviour"))
			{
				var behav:IBehaviour = createBehaviour(behaviour, platform);
				if (behaviour.attribute("type") == BehaviourType.SOLID_OBSTACLE || behaviour.attribute("type") == BehaviourType.TRANSPARENT_OBSTACLE)
					hasCollider = true;
					
				platform.addBehaviour(behav);
			}
			
			if (!hasCollider && xml.attribute("collider") != "false")
				platform.addBehaviour(collider);
			
			return platform;
		}
	
		public static function createItem(atlases:Vector.<TextureAtlas>, xml:XML):Item
		{
			var texture:String = xml.attribute("texture");
			var width:int = xml.attribute("width") * GameData.PLATFORM_HEIGHT;
			var height:int = xml.attribute("height") * GameData.PLATFORM_HEIGHT;
			
			var item:Item = new Item(atlases, texture, width, height);
			item.x = xml.attribute("x") * GameData.PLATFORM_HEIGHT;
			item.y = xml.attribute("y") * GameData.PLATFORM_SPACE;
			item.name = texture;
			
			for each (var behaviour:XML in xml.elements("Behaviour"))
				item.addBehaviour(createBehaviour(behaviour, item));
				
			item.addBehaviour(new TransparentBehaviour(item, new Point(0, 0), item.size, item.collisionGroup, xml.attribute("shape")));
			
			return item;
		}
		
		public static function createBoss(xml:XML):Boss
		{
			var name:String = xml.attribute("name");
			var width:int = xml.attribute("width");
			var height:int = xml.attribute("height");
			
			var offset:Point = null;
			var size:Point = null;
			var boss:Boss = null;
			
			if (name == BossData.TYPE_EARTH_BOSS)
			{
				boss = new EarthBoss(width, height);
				offset = new Point(0, -100);
				size =  boss.size;
			}
			else if (name == BossData.TYPE_FIRE_BOSS)
			{
				boss = new FireBoss(width, height);
				offset = new Point(0, -100);
				size = new Point(200, 200);
			}
			
			boss.x = xml.attribute("x") * GameData.PLATFORM_HEIGHT;
			boss.y = xml.attribute("y") * GameData.PLATFORM_SPACE;
			boss.name = name;
			
			boss.addBehaviour(new SolidBehaviour(boss,offset, size, CollisionData.COLLISION_GROUP_BOSS, xml.attribute("shape")));
			return boss;
		}
		
		public static function createCanon(atlases:Vector.<TextureAtlas>, xml:XML):Canon
		{
			var timer:int = xml.attribute("timer");
			if (timer == 0)
				timer = GameData.CANON_SHOOT_TIMER;
				
			var canon:Canon = new Canon(atlases, timer);
			
			canon.x = xml.attribute("x") * GameData.PLATFORM_HEIGHT;
			canon.y = xml.attribute("y") * GameData.PLATFORM_SPACE;
			
			return canon;
		}
		
		public static function createBehaviour(xml:XML, owner:GameObject):IBehaviour
		{
			var type:String = xml.attribute("type");
			switch (type)
			{
				case BehaviourType.MOVE:
				{
					var moveDirection:Point = null;
					if (xml.attribute("direction") == "UP")
						moveDirection = PlatformMovementDirection.UP;
					else if (xml.attribute("direction") == "DOWN")
						moveDirection = PlatformMovementDirection.DOWN;
					else if (xml.attribute("direction") == "LEFT")
						moveDirection = PlatformMovementDirection.LEFT;
					else if (xml.attribute("direction") == "RIGHT")
						moveDirection = PlatformMovementDirection.RIGHT;
						
					var shift:int = xml.attribute("shift");
					var speed:Number = xml.attribute("speed");
					
					return new MoveBehaviour(owner, moveDirection, shift, speed);
				}
				case BehaviourType.CRASH:
				{
					moveDirection = null;
					if (xml.attribute("direction") == "UP")
						moveDirection = PlatformMovementDirection.UP;
					else if (xml.attribute("direction") == "DOWN")
						moveDirection = PlatformMovementDirection.DOWN;
					else if (xml.attribute("direction") == "LEFT")
						moveDirection = PlatformMovementDirection.LEFT;
					else if (xml.attribute("direction") == "RIGHT")
						moveDirection = PlatformMovementDirection.RIGHT;
						
					shift = xml.attribute("shift");
					speed = xml.attribute("speed");
					var delay:Number = xml.attribute("delay");
					
					return new CrashBehaviour(owner, moveDirection, shift, speed, delay);
				}
				case BehaviourType.KILL:
				case BehaviourType.ANIMATION:
				{
					var collisionSide:int;
					if (xml.attribute("collisionSide") == "TOP")
						collisionSide = CollisionData.COLLISION_SIDE_BOTTOM;
					else if (xml.attribute("collisionSide") == "BOTTOM")
						collisionSide = CollisionData.COLLISION_SIDE_TOP;
					else if (xml.attribute("collisionSide") == "LEFT")
						collisionSide = CollisionData.COLLISION_SIDE_RIGHT;
					else if (xml.attribute("collisionSide") == "RIGHT")
						collisionSide = CollisionData.COLLISION_SIDE_LEFT;
					else if (xml.attribute("collisionSide") == "ALL")
						collisionSide = CollisionData.COLLISION_SIDE_NONE;
					else
						collisionSide = CollisionData.COLLISION_SIDE_BOTTOM;
						
					if (type == BehaviourType.KILL)
						return new KillBehaviour(owner, collisionSide);
						
					var name:String = xml.attribute("name");
					if (name == "")
						name = owner.name;
					
					return new AnimationBehaviour(owner, name, collisionSide, xml.attribute("loop") == "true", xml.attribute("repeat") == "false");
				}
				case BehaviourType.TRANSPARENT_OBSTACLE:
				case BehaviourType.SOLID_OBSTACLE:
				{
					var offset:Point = new Point(xml.attribute("x") * GameData.PLATFORM_HEIGHT, xml.attribute("y") * GameData.PLATFORM_SPACE);
					var size:Point = new Point(xml.attribute("width") * GameData.PLATFORM_HEIGHT, xml.attribute("height")  * GameData.PLATFORM_SPACE);
					var group:String = xml.attribute("group");
					
					if (size.x == 0)
						size.x = owner.width;
					
					if (size.y == 0)
						size.y = owner.height;
					
					if (group == "" && owner is ICollidable)
						group = ICollidable(owner).collisionGroup;
						
					if (type == BehaviourType.SOLID_OBSTACLE)
						return new SolidBehaviour(owner, offset, size, group, xml.attribute("shape"), xml.attribute("flip") == "true");
						
					return new TransparentBehaviour(owner, offset, size, group, xml.attribute("shape"), xml.attribute("flip") == "true");
				}
				case BehaviourType.TRANSPORT:
					return new TransportBehaviour(owner);
				case BehaviourType.DISAPPEAR:
					var time:int = xml.attribute("time");
					if (time == 0)
						time = GameData.ITEM_DISAPPEAR_TIME;
						
					return new DisappearBehaviour(owner, time);
				case BehaviourType.ADD_AMMO:
					return new AddAmmoBehaviour();
				case BehaviourType.ADD_LIFE:
					return new AddLifeBehaviour(int(xml.attribute("lives")) == 0?1:xml.attribute("lives"));
				case BehaviourType.CHECKPOINT:
					return new CheckpointBehaviour(owner);
				case BehaviourType.CHANGE_LEVEL_STAGE:
					return new ChangeLevelStageBehaviour(xml.attribute("newStage"));
				case BehaviourType.ADD_DAMAGE:
				case BehaviourType.ADD_POWER_UP:
				case BehaviourType.FALL_ON_HIT:
				case BehaviourType.FALL_WHEN_NEAR:
					return null;
				case BehaviourType.WARNING:
					return new WarningBehaviour();
			}
			return null;
		}
	}
}