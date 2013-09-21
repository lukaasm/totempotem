package pl.fabrykagier.totempotem.states.bossstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IBossState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class WinState implements IState, IBossState 
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		protected var enterTime:int;
		
		public function WinState(self:Boss) 
		{
			this.boss = self;
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return BossStates.WIN;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			enterTime = getTimer();
			
			boss.stopAnimation();
			
			SoundManager.instance.playSound(SoundsData.BOSS_WIN, 0, 1 * SoundsData.MUTE_SOUND);
			
			switch (boss.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					return boss.playAnimation(EarthBossAnimations.WIN);
				case BossData.TYPE_FIRE_BOSS:
					return boss.playAnimation(FireBossAnimations.WIN);
			}
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
		}
		
		public function update(diff:Number):void 
		{
			
		}
	}

}