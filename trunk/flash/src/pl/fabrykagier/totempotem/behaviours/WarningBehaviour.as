package pl.fabrykagier.totempotem.behaviours
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.managers.GameManager;
	
	public class WarningBehaviour implements IBehaviour
	{
		private var done:Boolean;
		
		public function WarningBehaviour()
		{
			done = false;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (done)
				return;
			
			done = true;
			GameManager.instance.showPopup(Popups.POPUP_BOSS_WARN);
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
		
		}
		
		public function update(diff:Number):void
		{
		
		}
	}
}