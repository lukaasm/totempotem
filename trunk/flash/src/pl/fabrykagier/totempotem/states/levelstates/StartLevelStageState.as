package pl.fabrykagier.totempotem.states.levelstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class StartLevelStageState implements IState 
	{
		protected var enterTime:int;
		
		private var currentLevel:Level;
		private var currentLevelStateMachine:StateMachine;
		
		public function StartLevelStageState(self:Level) 
		{
			this.currentLevel = self;
			this.currentLevelStateMachine = currentLevel.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return LevelStates.START_LEVEL_STAGE;
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] START LEVEL STAGE STATE] ENTER() ");
			
			currentLevelStateMachine.setNextState(currentLevel.states[LevelStates.PLATFORMS_STAGE]);
			
			currentLevel.player.rigidBody.position.x = currentLevel.player.startPosition.x;
			currentLevel.player.rigidBody.position.y = currentLevel.player.startPosition.y;
				
			currentLevel.target.x = int( -currentLevel.player.x + currentLevel.screenShiftLeft);
			currentLevel.target.y = 0;
			
			currentLevelStateMachine.goToNextState(IState(currentLevel.states[LevelStates.PLATFORMS_STAGE]));
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] START LEVEL STAGE STATE] EXIT() ");
		}
		
		public function update(diff:Number):void 
		{}
	}
}