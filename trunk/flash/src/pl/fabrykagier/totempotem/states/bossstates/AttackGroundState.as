package pl.fabrykagier.totempotem.states.bossstates 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.behaviours.AddDamageBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransparentBehaviour;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.BossAttack;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IBossState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	
	public class AttackGroundState implements IState, IBossState 
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		
		protected var enterTime:int;
		
		private var attacksNumber:int;
		private var handsCollider:BossAttack;
		private var nails:BossAttack;
		private var nailsCollider:TransparentBehaviour;
		private var attack:Function;
		private var sound:Boolean;
		
		private var calls:Vector.<DelayedCall>;
		
		public function AttackGroundState(self:Boss) 
		{
			this.boss = self;
		
			calls = new Vector.<DelayedCall>;
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
				
			attacksNumber = 0;
			attack = null;
		}
		
		public function get name():String 
		{
			return BossStates.ATTACK_GROUND;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			enterTime = getTimer();
			
			sound = true;
			
			if (boss.type == BossData.TYPE_EARTH_BOSS)
			{
				attack = null;
				
				attacksNumber = int((int(Math.random() * 10) + 1) % 3) + 2;
				trace("Attack number: " + attacksNumber);
				
				handsCollider = new BossAttack(boss, null, "", 120, 100);
				handsCollider.addBehaviour(new TransparentBehaviour(
								handsCollider, new Point(0, 0), handsCollider.size, handsCollider.collisionGroup));
				handsCollider.addBehaviour(new AddDamageBehaviour(1));
				GameManager.instance.addChild(handsCollider);
				
				nails = new BossAttack(boss, boss.atlases, "", 70, 450);
				nails.x = -50;
				
				nailsCollider = new TransparentBehaviour(nails, new Point(0, 510), nails.size, nails.collisionGroup);
				
				nails.addBehaviour(nailsCollider);
				nails.addBehaviour(new AddDamageBehaviour(1));
				
				nails.addAnimation(EarthBossAnimations.GROUND_SHAKING, 6);
				nails.addAnimation(EarthBossAnimations.NAILS, 20);
				
				GameManager.instance.addChild(nails);
				
				boss.playAnimation(EarthBossAnimations.ATTACK_GROUND, onAnimationComplite, false);
			}
		}
		
		private function restart():void
		{
			boss.stopAnimation();
			boss.playAnimation(EarthBossAnimations.ATTACK_GROUND, onAnimationComplite, false);
		}
		
		private function onAnimationComplite():void
		{
			attacksNumber--;
			
			if (attacksNumber > 0)
			{
				attack = null;
				calls.push(Starling.juggler.delayCall(restart, 1));
			}
			else
				boss.changeState(BossStates.RESTING);
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
			
			for each (var call:DelayedCall in calls)
			{
				if (Starling.juggler.contains(call))
					Starling.juggler.remove(call);
			}
			
			clearHandsColliderPosition();
		}
		
		public function update(diff:Number):void 
		{
			nails.update(diff);
			handsCollider.update(diff);
			
			if (boss.isAnimationInProgress(EarthBossAnimations.ATTACK_GROUND))
			{
				var bossCurrentFrame:int = boss.animationClip(EarthBossAnimations.ATTACK_GROUND).currentFrame;
				if (bossCurrentFrame > 10 && bossCurrentFrame < 36)
				{
					setHandsColliderPosition();
					
					if (sound == true)
					{
						SoundManager.instance.playSound(SoundsData.EARTH_BOSS_ATTACK_GROUND_HIT, 0, 1 * SoundsData.MUTE_SOUND);
						sound = false;
					}
					
					if (bossCurrentFrame > 15 && attack == null)
						attack = setNailsPosition;
				}
				else
				{
					clearHandsColliderPosition();
					sound = true;
				}
				
				if(attack != null)
					attack();
			}
		}
		
		private function setHandsColliderPosition():void
		{
			handsCollider.x = boss.position.x - 180;
			handsCollider.y = boss.position.y + 250;
		}
		
		private function clearHandsColliderPosition():void
		{
			handsCollider.x = boss.position.x + 500;
			handsCollider.y = boss.position.y - 500;
		}
		
		private function setNailsPosition():void
		{
			nails.x = GameManager.instance.player.position.x;
			nails.y = 465;
			
			nails.playAnimation(EarthBossAnimations.GROUND_SHAKING, null, true);
			
			Starling.juggler.delayCall(activateNails, 0.25);
			
			if (attack == setNailsPosition)
				attack = Dumy;
		}
		
		public function activateNails():void
		{
			nails.stopAnimation();
			nails.playAnimation(EarthBossAnimations.NAILS, resetNails, false);
			
			SoundManager.instance.playSound(SoundsData.EARTH_BOSS_ATTACK_GROUND_NAILS, 0, 1 * SoundsData.MUTE_SOUND);
			
			nails.y -= 35;
			attack = nailsAttack;
		}
		
		private function nailsAttack():void
		{
			if (nails.isAnimationInProgress(EarthBossAnimations.NAILS))
			{
				var nailsCurrentFrame:int = nails.animationClip(EarthBossAnimations.NAILS).currentFrame;
				
				if (nailsCurrentFrame >= 5 && nailsCurrentFrame < 14)
				{
					if (nailsCurrentFrame >= 6 )
					{
						nailsCollider.offset.y = 0;
						return;
					}
					
					boss.pauseAnimation();
					nailsCollider.offset.y = 420;
				}
				else if (nailsCurrentFrame >= 14 && nailsCurrentFrame < 21)
				{
					if (nailsCurrentFrame >= 20 )
					{
						nailsCollider.offset.y = 480;
						boss.playAnimation(EarthBossAnimations.ATTACK_GROUND);
						return;
					}
					else if (nailsCurrentFrame >= 19 )
					{
						nailsCollider.offset.y = 420;
						return;
					}
					else if (nailsCurrentFrame >= 18 )
					{
						nailsCollider.offset.y = 350;
						return;
					}
					else if (nailsCurrentFrame >= 17 )
					{
						nailsCollider.offset.y = 280;
						return;
					}
					else if (nailsCurrentFrame >= 16 )
					{
						nailsCollider.offset.y = 220;
						return;
					}
					else if (nailsCurrentFrame >= 15 )
					{
						nailsCollider.offset.y = 150;
						return;
					}
					
					nailsCollider.offset.y = 80;
				}
				else 
				{
					nailsCollider.offset.y = 510;
				}
			}
		}
		
		private function resetNails():void
		{
			nails.x = -50;
			nails.y = 0;
		}
		
		private function Dumy():void
		{
			
		}
	}
}