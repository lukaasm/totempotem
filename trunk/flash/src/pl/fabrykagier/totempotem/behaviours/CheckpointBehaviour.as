package pl.fabrykagier.totempotem.behaviours
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	
	public class CheckpointBehaviour implements IBehaviour
	{
		private var active:Boolean;
		private var owner:GameObject;
		
		public function CheckpointBehaviour(owner:GameObject)
		{
			active = false;
			
			this.owner = owner;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (active || !(invoker is Player))
				return;
			
			active = true;
			
			SoundManager.instance.playSound(SoundsData.CHECKPOINT, 0, 1 * SoundsData.MUTE_SOUND);
			
			Player(invoker).startPosition.x = owner.x;
			Player(invoker).startPosition.y = owner.y;
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
		
		}
		
		public function update(diff:Number):void
		{
		
		}
	}
}