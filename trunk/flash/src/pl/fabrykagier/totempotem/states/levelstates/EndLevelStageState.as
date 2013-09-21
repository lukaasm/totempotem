package pl.fabrykagier.totempotem.states.levelstates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class EndLevelStageState implements IState 
	{
		protected var enterTime:int;
		
		private var currentLevel:Level;
		private var currentLevelStateMachine:StateMachine;
		
		public function EndLevelStageState(self:Level) 
		{
			this.currentLevel = self;
			this.currentLevelStateMachine = currentLevel.agent.stateMachine;
		}
		
		public function get name():String 
		{
			return LevelStates.END_LEVEL_STAGE;
		}
		
		public function get activeTime():int 
		{
			return getTimer() - enterTime;
		}
		
		public function enter():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] END LEVEL STAGE STATE] ENTER() ");
			
			//TODO: dodac przejscie do nastepnego lvlu
		}
		
		public function exit():void 
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[[LEVEL] END LEVEL STAGE STATE] EXIT() ");
		}
		
		public function update(diff:Number):void 
		{
			
		}
	}
}