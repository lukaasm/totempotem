package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class ChangeLevelStageBehaviour implements IBehaviour 
	{
		private var newStage:String;
		
		public function ChangeLevelStageBehaviour(newStage:String)
		{
			this.newStage = newStage;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void 
		{
			var level:Level = LevelManager.instance.level;
			var levelStateMachine:StateMachine = level.agent.stateMachine;
			
			levelStateMachine.changeState(IState(level.states[newStage]));
		}
		
		public function onNoCollision(invoker:ICollidable):void 
		{}
		
		public function update(diff:Number):void 
		{}
	}
}