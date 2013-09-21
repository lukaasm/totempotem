package pl.fabrykagier.totempotem.states.bossstates 
{
	import flash.events.*;
	import flash.utils.*;
	import pl.fabrykagier.totempotem.bosses.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.statemachine.*;
	
	public class RestingState implements IState, IBossState 
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		protected var enterTime:int;
		private var timer:Timer;
		
		public function RestingState(self:Boss) 
		{
			this.boss = self;
			
			timer = new Timer(BossData.EARTH_BOSS_RESTING_TIME, 1);
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return BossStates.RESTING;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			enterTime = getTimer();
			
			switch (boss.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					boss.playAnimation(EarthBossAnimations.RESTING);
					break;
				case BossData.TYPE_FIRE_BOSS:
					boss.playAnimation(FireBossAnimations.RESTING);
					break;
			}
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
			timer.start();
		}
		
		private function onTimerCompleteHandler(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
			
			boss.changeState(BossStates.IDLE);
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