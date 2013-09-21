package pl.fabrykagier.totempotem.states.levelstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class PlatformsStageState implements IState 
	{
		protected var enterTime:int;
		
		private var currentLevel:Level;
		private var currentLevelStateMachine:StateMachine;
		
		public function PlatformsStageState(self:Level) 
		{
			this.currentLevel = self;
			this.currentLevelStateMachine = currentLevel.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return LevelStates.PLATFORMS_STAGE;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] PLATFORMS STAGE STATE] ENTER() ");
			
			if (SoundManager.instance.soundOn == true)
			{
				if (currentLevel.type == BossData.TYPE_EARTH_BOSS)
					SoundManager.instance.playSound(SoundsData.EARTH_LEVEL_MUSIC, 9999, 0.3 * SoundsData.MUTE_SOUND);
				else if (currentLevel.type == BossData.TYPE_FIRE_BOSS)
					SoundManager.instance.playSound(SoundsData.FIRE_LEVEL_MUSIC, 9999, 0.15 * SoundsData.MUTE_SOUND);
			}
			currentLevelStateMachine.setNextState(currentLevel.states[LevelStates.BOSS_STAGE]);
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] PLATFORMS STAGE STATE] EXIT() ");
			
			SoundManager.instance.stopAllSounds();
		}
		
		public function update(diff:Number):void 
		{
			currentLevel.checkShift();
			currentLevel.setTarget();
			moveScreen();
		}
		
		private function moveScreen():void
		{
			currentLevel.x += int((currentLevel.target.x - currentLevel.x) / GameData.SCREEN_TEMPO);
			currentLevel.y += int((currentLevel.target.y - currentLevel.y) / GameData.SCREEN_TEMPO);
		}
	}
}