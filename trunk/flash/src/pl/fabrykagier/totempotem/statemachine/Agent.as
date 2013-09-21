package pl.fabrykagier.totempotem.statemachine 
{
	public class Agent 
	{
		private var _stateMachine:StateMachine;
    
		public function Agent()
		{
			_stateMachine = new StateMachine();
		}
		
		public function update( diff:Number ):void
		{
			stateMachine.update( diff );
		}
		
		public function get stateMachine():StateMachine 
		{
			return _stateMachine;
		}
	}
}