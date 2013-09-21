package pl.fabrykagier.totempotem.statemachine 
{
	public class StateMachine 
	{
		private var _currentState:IState;
		private var _previousState:IState;
		private var nextStates:Vector.<IState>;
		
		public function StateMachine()
		{
			_currentState = null;
			_previousState = null;
			nextStates = new Vector.<IState>;
		}
		
		public function setNextState(state:IState):void
		{
			nextStates.push(state);
		}
		
		public function update(diff:Number):void
		{
			if (currentState)
				currentState.update(diff);
		}
		
		public function changeState(state:IState, force:Boolean = false):IState
		{
			if (!force && state == _currentState)
				return _currentState;
			
			if (_currentState != null)
			{
				_currentState.exit();
				_previousState = currentState;
			}
			else
				_previousState = state;
			
			_currentState = state;
			_currentState.enter();
			
			return _currentState;
		}
		
		public function goToPreviousState():void
		{
			changeState(previousState);
		}
		
		public function goToNextState(state:IState):void
		{
			changeState(nextStates[nextStates.indexOf(state)]);
		}
		
		public function get previousState():IState 
		{
			return _previousState;
		}
		
		public function get currentState():IState 
		{
			return _currentState;
		}
	}
}