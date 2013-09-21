package pl.fabrykagier.totempotem.states.bossstates
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.behaviours.AddDamageBehaviour;
	import pl.fabrykagier.totempotem.behaviours.SolidBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransparentBehaviour;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.BossAttack;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IBossState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class AttackFistState implements IState, IBossState
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		protected var enterTime:int;
		
		private var hitBoxCollider:BossAttack;
		private var hitBoxCollider2:BossAttack;
		
		public function AttackFistState(self:Boss)
		{
			this.boss = self;
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
		}
		
		public function get name():String
		{
			return BossStates.ATTACK_FIST;
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			enterTime = getTimer();
			
			if (boss.type == BossData.TYPE_EARTH_BOSS)
			{
				boss.playAnimation(EarthBossAnimations.ATTACK_FIST, onAnimationComplite, false);
				
				hitBoxCollider = new BossAttack(boss, null, "", 300, 300);
				hitBoxCollider.addBehaviour(new TransparentBehaviour(
								hitBoxCollider, new Point(0, 0), hitBoxCollider.size, hitBoxCollider.collisionGroup));
				hitBoxCollider.addBehaviour( new AddDamageBehaviour(2));
				GameManager.instance.addChild(hitBoxCollider);
				
				hitBoxCollider2 = new BossAttack(boss, null, "", 350, 450);
				hitBoxCollider2.addBehaviour(new TransparentBehaviour(
								hitBoxCollider2, new Point(0, 0), hitBoxCollider2.size, hitBoxCollider2.collisionGroup));
				hitBoxCollider2.addBehaviour( new AddDamageBehaviour(2));
				GameManager.instance.addChild(hitBoxCollider2);
			}
		}
		
		private function clearHandsColliderPosition():void
		{
			hitBoxCollider.x = boss.position.x + 500;
			hitBoxCollider.y = boss.position.y - 500;
			
			hitBoxCollider2.x = boss.position.x + 500;
			hitBoxCollider2.y = boss.position.y - 500;
		}
		
		private function onAnimationComplite():void
		{
			boss.changeState(BossStates.RESTING);
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
			
			clearHandsColliderPosition();
		}
		
		public function update(diff:Number):void
		{
			hitBoxCollider.update(diff);
			hitBoxCollider2.update(diff);
			
			if (boss.isAnimationInProgress(EarthBossAnimations.ATTACK_FIST))
			{
				if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 10)
				{
					hitBoxCollider2.x = boss.position.x - 160;
					hitBoxCollider2.y = boss.position.y + 100;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 11)
				{
					SoundManager.instance.playSound(SoundsData.EARTH_BOSS_ATTACK_FIST, 0, 1 * SoundsData.MUTE_SOUND);
					
					hitBoxCollider.x = boss.position.x - 190;
					hitBoxCollider.y = boss.position.y + 250;
					
					hitBoxCollider2.x = boss.position.x + 500;
					hitBoxCollider2.y = boss.position.y - 500;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 12)
				{
					hitBoxCollider.x = boss.position.x - 180;
					hitBoxCollider.y = boss.position.y + 250;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 13)
				{
					hitBoxCollider.x = boss.position.x - 170;
					hitBoxCollider.y = boss.position.y + 250;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 14)
				{
					hitBoxCollider.x = boss.position.x - 170;
					hitBoxCollider.y = boss.position.y + 250;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 15)
				{
					hitBoxCollider.x = boss.position.x - 150;
					hitBoxCollider.y = boss.position.y + 250;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 16)
				{
					hitBoxCollider.x = boss.position.x - 130;
					hitBoxCollider.y = boss.position.y + 250;
				}
				else if (boss.animationClip(EarthBossAnimations.ATTACK_FIST).currentFrame == 19)
				{
					hitBoxCollider.x = boss.position.x + 500;
					hitBoxCollider.y = boss.position.y - 500;
				}
			}
		}
	}
}