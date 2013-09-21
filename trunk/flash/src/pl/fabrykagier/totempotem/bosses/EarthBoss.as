package pl.fabrykagier.totempotem.bosses 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import pl.fabrykagier.totempotem.collisions.BoundingBox;
	import pl.fabrykagier.totempotem.core.Life;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.BossStates;
	import pl.fabrykagier.totempotem.data.EarthBossAnimations;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.Agent;
	import pl.fabrykagier.totempotem.states.bossstates.*;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class EarthBoss extends Boss 
	{
		private var distance:Number;
		
		public function EarthBoss(w:int=0, h:int=0) 
		{
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_boss_0"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_boss_1"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_boss_2"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("level_earth_boss_3"));
			
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_0"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_1"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_2"));
			atlases.push(GameManager.instance.assets.getTextureAtlas("boss_effects_3"));
			
			super(atlases, w, h);
			
			type = BossData.TYPE_EARTH_BOSS;
			
			_life = new Life(BossData.EARTH_BOSS_START_LIVES, this);
			distance = 0;
			
			addAnimation(EarthBossAnimations.IDLE);
			addAnimation(EarthBossAnimations.ATTACK_GROUND);
			addAnimation(EarthBossAnimations.ATTACK_FIST, 20);
			addAnimation(EarthBossAnimations.DYING, 16);
			addAnimation(EarthBossAnimations.GROUND_SHAKING);
			addAnimation(EarthBossAnimations.RESTING);
			addAnimation(EarthBossAnimations.WOUNDED_BEGIN);
			addAnimation(EarthBossAnimations.WOUNDED_END);
			addAnimation(EarthBossAnimations.NAILS);
			addAnimation(EarthBossAnimations.WIN);
			
			_agent = new Agent();
			
			states = new Dictionary();
			
			states[BossStates.ATTACK_FIST] = new AttackFistState(this);
			states[BossStates.ATTACK_GROUND] = new AttackGroundState(this);
			states[BossStates.DYING] = new DyingState(this);
			states[BossStates.IDLE] = new IdleState(this);
			states[BossStates.RESTING] = new RestingState(this);
			states[BossStates.WOUNDED] = new WoundedState(this);
			states[BossStates.WIN] = new WinState(this);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		public override function startFight():void
		{
			super.startFight();
			
			changeState(BossStates.IDLE);
			Starling.juggler.delayCall(AI, 2);
		}
		
		public override function handlePlayerDeath():void
		{
			var level:Level = LevelManager.instance.level;
			
			level.player.life.subLife(level.player.life.lives);
			
			changeState(BossStates.WIN);
			level.player.changeState(PlayerStates.STATE_PLAYER_DYING);
		}
		
		private function AI():void
		{
			if (this.agent.stateMachine.currentState.name == BossStates.IDLE)
			{
				if (distance > 420)
					this.changeState(BossStates.ATTACK_GROUND);
				else if(distance <= 420)
					this.changeState(BossStates.ATTACK_FIST);
			}
			
			Starling.juggler.delayCall(AI, 2);
		}
		
		public override function update(diff:Number):void
		{
			super.update(diff);
			
			distance = Utils.magPointPoint(GameManager.instance.player.position, this.position);
		}
	}
}