package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	
	public class PauseGameState implements IState 
	{
		private var stateMachine:StateMachine;
		private var gameManager:GameManager;
	
		protected var enterTime:int;
		
		public function PauseGameState(gameManager:GameManager) 
		{
			this.gameManager = gameManager;
			
			if (gameManager.agent != null)
				stateMachine = gameManager.agent.stateMachine;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME PAUSEGAME STATE] ENTER() ");
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME PAUSEGAME STATE] EXIT() ");
		}
		
		public function update( diff:Number ):void
		{
			
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return GameStates.PAUSE_GAME;
		}
	}
}