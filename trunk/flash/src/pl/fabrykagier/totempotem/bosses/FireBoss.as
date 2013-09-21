package pl.fabrykagier.totempotem.bosses 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Bullet;
	import pl.fabrykagier.totempotem.core.Life;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossAnimations;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossEncounter;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.Agent;
	import pl.fabrykagier.totempotem.states.bossstates.*;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class FireBoss extends Boss 
	{
		private var fireballTimer:int;
		private var stingTimer:int;
		
		public function FireBoss(w:int=0, h:int=0) 
		{
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_boss_0"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_boss_1"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_boss_2"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_boss_3"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_fire_boss_4"));

			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_0"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_1"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_2"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_3"));
			
			super(atlases, w, h);
			
			type = BossData.TYPE_FIRE_BOSS;
			
			_life = new Life(BossData.FIRE_BOSS_START_LIVES, this);
			
			addAnimation(FireBossAnimations.IDLE);
			addAnimation(FireBossAnimations.RESTING);
			addAnimation(FireBossAnimations.WIN);
			addAnimation(FireBossAnimations.DYING);

			addAnimation(FireBossAnimations.ATTACK_FIREBALL);
			addAnimation(FireBossAnimations.ATTACK_STING);
			
			addAnimation(FireBossAnimations.WOUNDED_BEGIN);
			addAnimation(FireBossAnimations.WOUNDED_END);
			
			_agent = new Agent();
			
			states = new Dictionary();
			states[BossStates.DYING] = new DyingState(this);
			states[BossStates.WIN] = new WinState(this);
			states[BossStates.IDLE] = new IdleState(this);
			states[BossStates.RESTING] = new RestingState(this);
			states[BossStates.WOUNDED] = new WoundedState(this);
			
			states[BossStates.ATTACK_FIREBALL] = new FireballAttackState(this);	
			states[BossStates.ATTACK_STING] = new StingAttackState(this);	
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			fireballTimer = FireBossEncounter.FIREBALL_TIMER;
			stingTimer = FireBossEncounter.STING_TIMER;
		}
		
		public override function startFight():void
		{
			super.startFight();
			
			changeState(BossStates.IDLE);
		}
		
		public override function handlePlayerDeath():void
		{
			var level:Level = LevelManager.instance.level;

			level.player.life.subLife(level.player.life.lives);
			
			changeState(BossStates.WIN);
			level.player.changeState(PlayerStates.STATE_PLAYER_DYING);
			
			//Starling.juggler.delayCall(GameManager.instance.showPopup, 3, Popups.POPUP_GAMEOVER);
		}
		
		public override function update(diff:Number):void
		{
			super.update(diff);
			
			if (!isIdle())
				return;
				
			if (fireballTimer <= diff)
			{
				if (stingTimer < 3000)
					stingTimer = 3000;
					
				fireballTimer = FireBossEncounter.FIREBALL_TIMER;
				return void(changeState(BossStates.ATTACK_FIREBALL));
			}
			else
				fireballTimer -= diff;
				
			if (stingTimer <= diff)
			{
				if (fireballTimer < 3000)
					fireballTimer = 3000;
					
				stingTimer = FireBossEncounter.STING_TIMER;
				return void(changeState(BossStates.ATTACK_STING));
			}
			else
				stingTimer -= diff;
		}
	}
}