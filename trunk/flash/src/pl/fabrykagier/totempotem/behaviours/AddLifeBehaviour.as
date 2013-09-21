package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	
	public class AddLifeBehaviour implements IBehaviour 
	{
		private var livesToAdd:int;
		private var done:Boolean;
		
		public function AddLifeBehaviour(livesToAdd:int = 1)
		{
			Debug.log(Debug.DEBUG_VERBOSE_ITEM_BEHAVIOURS, 
					"[ADD LIFE] CREATE ITEM lives to add: " + livesToAdd.toString());
			
			this.livesToAdd = livesToAdd;
			done = false;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void 
		{
			if (invoker is Player)
			{
				if (done)
					return;
				
				SoundManager.instance.playSound(SoundsData.PICK_UP, 0, 0.3 * SoundsData.MUTE_SOUND);
				
				Player(invoker).life.addLife(this.livesToAdd);
				done = true;
			}
		}
		
		public function onNoCollision(invoker:ICollidable):void 
		{}
		
		public function update(diff:Number):void 
		{}
	}
}