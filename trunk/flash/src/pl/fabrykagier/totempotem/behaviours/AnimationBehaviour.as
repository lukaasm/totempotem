package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import starling.core.Starling;
	
	public class AnimationBehaviour implements IBehaviour 
	{
		private var owner:GameObject;
		private var animation:String;
		private var loop:Boolean;
		private var once:Boolean;
		private var collisionSide:int;
		
		public function AnimationBehaviour(owner:GameObject, name:String, collisionSide:int, loop:Boolean, once:Boolean) 
		{
			this.owner = owner;
			
			animation = name;
			this.loop = loop;
			owner.addAnimation(animation);
			
			this.once = once;
			
			if (loop)
				owner.playAnimation(animation, null, true);
				
			this.collisionSide = collisionSide;
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
			if (!loop && !once && !owner.getAnimationClip(animation).isPlaying)
				owner.stopAnimation();
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (!loop && (this.collisionSide == CollisionData.COLLISION_SIDE_NONE || this.collisionSide == collisionSide))
			{
				owner.playAnimation(animation, null, false);
			}
		}
		
		public function update(diff:Number):void
		{
			
		}
	}
}