package pl.fabrykagier.totempotem.states.bossstates
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.behaviours.AddDamageBehaviour;
	import pl.fabrykagier.totempotem.behaviours.SolidBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransparentBehaviour;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.Fireball;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossEncounter;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IBossState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	
	public class FireballAttackState implements IState, IBossState
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		
		protected var enterTime:int;
		private var count:int;
		
		protected var fireballs:Vector.<Fireball>;
		private var delays:Vector.<DelayedCall>;
		
		public function FireballAttackState(self:Boss)
		{
			this.boss = self;
			
			fireballs = new Vector.<Fireball>;
			delays = new Vector.<DelayedCall>;
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
		}
		
		public function get name():String
		{
			return BossStates.ATTACK_FIREBALL;
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
		
			castFireball();
			
			enterTime = getTimer();
		}
		
		private function castFireball():void
		{
			var level:Level = LevelManager.instance.level;
			
			for (var i:int = 0; i < FireBossEncounter.FIREBALL_COUNT; ++i)
			{
				var of:int = 60;
				
				var fb:Fireball = new Fireball(boss.atlases);
				fb.x = 120 + of * Utils.urandom(0, 7);
			
				var delay:Number = Utils.frandom(0.3, 1.5);
				
				delays.push(Starling.juggler.delayCall(fireballs.push, delay, fb));
				delays.push(Starling.juggler.delayCall(playSound, delay));
				delays.push(Starling.juggler.delayCall(GameManager.instance.addChild, delay, fb));
			}

			boss.stopAnimation();
			boss.playAnimation(FireBossAnimations.ATTACK_FIREBALL, onAnimationComplete, false);
		}
		
		private function playSound():void
		{
			SoundManager.instance.playSound(SoundsData.FIRE_BOSS_ATTACK_FIRE_IGNITION, 0, 6 * SoundsData.MUTE_SOUND);
		}
		
		private function onAnimationComplete():void
		{
			if (fireballs.length < FireBossEncounter.FIREBALL_ATTACK_REPEATS*FireBossEncounter.FIREBALL_COUNT)
				delays.push(Starling.juggler.delayCall(castFireball, 1.0));
			else
			    delays.push(Starling.juggler.delayCall(boss.changeState, 1, BossStates.RESTING));
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
			
			for each (var fb:Fireball in fireballs)
			{
				CollisionManager.instance.unregister(fb);
				GameManager.instance.removeChild(fb);
			}
				
			for each (var dc:DelayedCall in delays)
			{
				if (Starling.juggler.contains(dc))
					Starling.juggler.remove(dc);
			}
			
			delays.splice(0, delays.length);
			fireballs.splice(0, fireballs.length);
		}
		
		public function update(diff:Number):void
		{
			for each (var fb:Fireball in fireballs)
				fb.update(diff);
		}
	}
}