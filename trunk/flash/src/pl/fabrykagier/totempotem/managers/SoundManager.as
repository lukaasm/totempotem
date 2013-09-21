package pl.fabrykagier.totempotem.managers 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.GameManager;
	
	public class SoundManager 
	{
		private static var _instance:SoundManager;
		private var channels:Dictionary;
		public var soundOn:Boolean;
		
		public function SoundManager() 
		{
			_instance = this;
			soundOn = true;
			channels = new  Dictionary();
		}
		
		public static function get instance():SoundManager 
		{
			return _instance;
		}
		
		public function toggleSounds():void
		{
			if (soundOn == true)
			{
				SoundsData.MUTE_SOUND = 0;
				
				stopAllSounds();
				
				soundOn = false;
			}
			else
			{
				SoundsData.MUTE_SOUND = 1;
				
				if (LevelManager.instance.level.bossStage == true)
					SoundManager.instance.playSound(SoundsData.BOSS_FIGHT_MUSIC, 9999, 0.3 * SoundsData.MUTE_SOUND);
				else
				{
					if (LevelManager.instance.level.type == BossData.TYPE_EARTH_BOSS)
						SoundManager.instance.playSound(SoundsData.EARTH_LEVEL_MUSIC, 9999, 0.3 * SoundsData.MUTE_SOUND);
					else if (LevelManager.instance.level.type == BossData.TYPE_FIRE_BOSS)
						SoundManager.instance.playSound(SoundsData.FIRE_LEVEL_MUSIC, 9999, 0.15 * SoundsData.MUTE_SOUND);
				}
				
				soundOn = true;
			}
		}
		
		public function playSound(name:String, loops:int = 0, volume:Number = 1):void 
		{
			var sound:Sound = GameManager.instance.assets.getSound(name);
			if (sound == null)
				return;
			
			channels[name] = sound.play(0, loops, new SoundTransform(volume));
		}
		
		public function stopSound(name:String):void 
		{
			if (channels[name] != null)
				SoundChannel(channels[name]).stop();
		}
		
		public function stopAllSounds():void
		{
			for each (var channel:SoundChannel in channels)
				channel.stop();
				
			channels = new  Dictionary();
		}
	}
}