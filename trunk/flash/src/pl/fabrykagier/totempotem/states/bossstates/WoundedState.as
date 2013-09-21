package pl.fabrykagier.totempotem.states.bossstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.EarthBoss;
	import pl.fabrykagier.totempotem.bosses.FireBoss;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.statemachine.IBossState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class WoundedState implements IState, IBossState 
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		protected var enterTime:int;
		
		public function WoundedState(self:Boss) 
		{
			this.boss = self;
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return BossStates.WOUNDED;
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
					return EarthBoss(boss).playAnimation(EarthBossAnimations.WOUNDED_BEGIN, setNextAnimation, false);
				case BossData.TYPE_FIRE_BOSS:
					return FireBoss(boss).playAnimation(FireBossAnimations.WOUNDED_BEGIN, setNextAnimation, false);
			}
		}
		
		private function setNextAnimation():void
		{
			switch (boss.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					return EarthBoss(boss).playAnimation(EarthBossAnimations.WOUNDED_END, onAnimationComplete, false);
				case BossData.TYPE_FIRE_BOSS:
					return FireBoss(boss).playAnimation(FireBossAnimations.WOUNDED_END, onAnimationComplete, false);
			}
		}
		
		private function onAnimationComplete():void
		{
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