package pl.fabrykagier.totempotem.behaviours
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	
	public class AddAmmoBehaviour implements IBehaviour
	{
		private var done:Boolean;
		
		public function AddAmmoBehaviour()
		{
			done = false;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (done)
				return;
			
			done = true;
			
			SoundManager.instance.playSound(SoundsData.PICK_UP, 0, 0.3 * SoundsData.MUTE_SOUND);
			
			switch (LevelManager.instance.level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					++PlayerData.PLAYER_AMMO_EARTH_COUNT;
					break;
				case BossData.TYPE_FIRE_BOSS:
					++PlayerData.PLAYER_AMMO_FIRE_COUNT;
					break;
			}
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
		}
		
		public function update(diff:Number):void
		{
		}
	}
}