package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	public class UpdateBehaviour implements IBehaviour 
	{
		private var owner:GameObject;
		private var updateCallback:Function;
		
		public function UpdateBehaviour(owner:GameObject, callback:Function) 
		{
			this.owner = owner;
			updateCallback = callback;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
			
		}
		
		public function update(diff:Number):void
		{
			updateCallback(owner);
		}
	}
}