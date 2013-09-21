package pl.fabrykagier.totempotem.states.bossstates 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.behaviours.LevelStageFinishBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransparentBehaviour;
	import pl.fabrykagier.totempotem.bosses.Boss;
	import pl.fabrykagier.totempotem.bosses.BossDeathEffect;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.core.Totem;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.data.PlatformMovementDirection;
	import pl.fabrykagier.totempotem.data.PlayerData;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IBossState;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	
	public class DyingState implements IState, IBossState 
	{
		private var boss:Boss;
		private var stateMachine:StateMachine;
		protected var enterTime:int;
		
		private var totem:Totem;
		private var shiny:Item;
		private var clouds:BossDeathEffect;
		private var effectPosition:Point;
		
		private var shinyEffect:Function;
		private var cloudsEffect:Function;
		
		private var tween:Tween;
		
		public function DyingState(self:Boss) 
		{
			this.boss = self;
			
			if (boss.agent != null)
				this.stateMachine = boss.agent.stateMachine;
				
			shinyEffect = null;
			cloudsEffect = null;
		}
		
		public function get name():String 
		{
			return BossStates.DYING;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] enter()");
			
			enterTime = getTimer();
			
			effectPosition = boss.position;
			
			SoundManager.instance.playSound(SoundsData.BOSS_LOSSES, 0, 1 * SoundsData.MUTE_SOUND);
			
			switch (boss.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					totem = new Totem(GameManager.instance.player.atlases, "totem_earth", 100, 200);
					boss.playAnimation(EarthBossAnimations.DYING, onAnimationComplete, false);
					break;
				case BossData.TYPE_FIRE_BOSS:
					totem = new Totem(GameManager.instance.player.atlases, "totem_fire", 100, 200);
					boss.playAnimation(FireBossAnimations.DYING, onAnimationComplete, false);
					break;
				default:
					break;
			}
			
			totem.x = effectPosition.x;
			totem.y = effectPosition.y + 500;
			
			totem.startPosition.x = totem.x;
			totem.startPosition.y = effectPosition.y - 60;
			
			totem.addBehaviour(new TransparentBehaviour(totem, new Point(0, 0), totem.size, totem.collisionGroup));
			totem.addBehaviour(new LevelStageFinishBehaviour());
			
			shiny = new Item(boss.atlases, BossData.EFFECTS_SHINY);
			
			shiny.alpha = 0;
			shiny.x = effectPosition.x;
			shiny.y = effectPosition.y + 190;
			
			clouds = new BossDeathEffect(boss.atlases);
			clouds.addAnimation(BossData.EFFECTS_CLOUDS_START, 16);
			clouds.addAnimation(BossData.EFFECTS_CLOUDS_LOOP_RIGHT, 12);
			clouds.addAnimation(BossData.EFFECTS_CLOUDS_LOOP_LEFT, 12);
			
			clouds.x = effectPosition.x + 50;
			clouds.y = effectPosition.y;
			
			GameManager.instance.addChild(totem);
			GameManager.instance.addChild(shiny);
			GameManager.instance.addChild(clouds);
			
			clouds.playAnimation(BossData.EFFECTS_CLOUDS_START, startCloudsLoop, false);
			
			tween = new Tween(totem, 1, Transitions.EASE_IN_OUT_BACK);
			tween.moveTo(totem.x, effectPosition.y - 60);
			tween.delay = 1;
		}
		
		public function onAnimationComplete():void
		{
			shinyEffect = startShinyHalo;
			Starling.juggler.add(tween);
		}
		
		private function startCloudsLoop():void
		{
			cloudsEffect = moveCloudsDown;
			playLoopLeftAnimation();
		}
		
		private function playLoopRightAnimation():void
		{
			clouds.playAnimation(BossData.EFFECTS_CLOUDS_LOOP_RIGHT, playLoopLeftAnimation, false);
		}
		
		private function playLoopLeftAnimation():void
		{
			clouds.playAnimation(BossData.EFFECTS_CLOUDS_LOOP_LEFT, playLoopRightAnimation, false);
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[" + name + "] exit()");
		}
		
		public function update(diff:Number):void 
		{
			effectPosition = boss.position;
			
			if (totem != null)
				totem.update(diff);
			
			if (shinyEffect != null)
				shinyEffect();
				
			if (cloudsEffect != null)
				cloudsEffect();
		}
		
		private function moveCloudsDown():void
		{
			if (clouds.y < effectPosition.y + 35)
				clouds.y += 1;
			else
				cloudsEffect = null;
		}
		
		private function startShinyHalo():void
		{
			if(shiny.alpha < 0.4)
				shiny.alpha += 0.002;
			
			shiny.rotation += 0.01;
		}
	}
}