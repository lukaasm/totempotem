package pl.fabrykagier.totempotem.states.levelstates 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.behaviours.IBehaviour;
	import pl.fabrykagier.totempotem.behaviours.SolidBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransportBehaviour;
	import pl.fabrykagier.totempotem.data.Animations;
	import pl.fabrykagier.totempotem.data.BackgroundLayers;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.EarthLevel;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class BossStageState implements IState 
	{
		protected var enterTime:int;
		
		private var currentLevel:Level;
		private var currentLevelStateMachine:StateMachine;
		
		private var leftBoarder:Platform;
		private var rightBoarder:Platform;
		
		public function BossStageState(self:Level) 
		{
			this.currentLevel = self;
			this.currentLevelStateMachine = currentLevel.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return LevelStates.BOSS_STAGE;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] BOSS STAGE STATE] ENTER() ");
			currentLevel.player.changeState(PlayerStates.STATE_PLAYER_TRANSITION);
			
			currentLevel.bossStage = true;
			
			if (SoundManager.instance.soundOn == true)
				SoundManager.instance.playSound(SoundsData.BOSS_FIGHT_MUSIC, 9999, 0.3);
			
			spawnBoss();
			
			spawnScreenBoarders();
			
			moveScreenToStageStar();
		}
		
		private function spawnBoss():void
		{
			currentLevel.loadBossAssets();
		}
		
		private function spawnScreenBoarders():void
		{
			leftBoarder = new Platform(null, "", GameData.PLATFORM_HEIGHT, GameData.PLATFORM_SPACE * 15);
			leftBoarder.x = -currentLevel.x - GameData.PLATFORM_HEIGHT/2;
			leftBoarder.y = -currentLevel.y;
			leftBoarder.name = "leftBoarder";
			
			var collider:IBehaviour = new SolidBehaviour(leftBoarder, new Point(0, 0), leftBoarder.size, leftBoarder.collisionGroup);
			leftBoarder.addBehaviour(collider);
			
			collider = new TransportBehaviour(leftBoarder);
			leftBoarder.addBehaviour(collider);
			
			currentLevel.addElement(leftBoarder);
			
			rightBoarder = new Platform(null, "", GameData.PLATFORM_HEIGHT, GameData.PLATFORM_SPACE * 15);
			rightBoarder.x = -currentLevel.x + currentLevel.stage.stageWidth + GameData.PLATFORM_HEIGHT/2;
			rightBoarder.y = -currentLevel.y;
			rightBoarder.name = "rightBoarder";
			
			collider = new SolidBehaviour(rightBoarder, new Point(0, 0), rightBoarder.size, rightBoarder.collisionGroup);
			rightBoarder.addBehaviour(collider);
			
			collider = new TransportBehaviour(rightBoarder);
			rightBoarder.addBehaviour(collider);
			
			currentLevel.addElement(rightBoarder);
		}
		
		private function moveScreenToStageStar():void
		{
			currentLevel.x = currentLevel.bossStageStart.x;
			currentLevel.y = currentLevel.bossStageStart.y;
			
			leftBoarder.x = -currentLevel.bossStageStart.x - GameData.PLATFORM_HEIGHT / 2;
			leftBoarder.y = -currentLevel.bossStageStart.y;
			
			rightBoarder.x = -currentLevel.bossStageStart.x + currentLevel.stage.stageWidth + GameData.PLATFORM_HEIGHT / 2;
			rightBoarder.y = -currentLevel.bossStageStart.y;
			
			moveBackground();
			movePlayer();
		}
		
		private function movePlayer():void
		{
			currentLevel.player.rigidBody.position.x = -currentLevel.bossStageStart.x + currentLevel.stage.stageWidth * GameData.SCREEN_PROCENT;
			currentLevel.player.rigidBody.position.y = 5 * GameData.PLATFORM_SPACE;
			
			currentLevel.player.changeState(PlayerStates.STATE_PLAYER_IDLE);
		}
		
		private function moveBackground():void
		{
			currentLevel.target.x = currentLevel.bossStageStart.x;
			currentLevel.target.y = currentLevel.bossStageStart.y;
		}
		
		private function turnOffPlayerControll():void
		{
			currentLevel.player.changeState(PlayerStates.STATE_PLAYER_TRANSITION);
		}
		
		private function turnOnPlayerControll():void
		{
			currentLevel.player.changeState(Animations.ANIMATION_PLAYER_IDLE);
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] BOSS STAGE STATE] EXIT() ");
			
			SoundManager.instance.stopSound(SoundsData.BOSS_FIGHT_MUSIC);
		}
		
		public function update(diff:Number):void 
		{
		}
	}
}