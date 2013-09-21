package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class GameplayState implements IState 
	{
		private var stateMachine:StateMachine;
		private var gameManager:GameManager;
		
		protected var enterTime:int;
		
		public function GameplayState(gameManager:GameManager) 
		{
			this.gameManager = gameManager;
			
			if (gameManager.agent != null)
				stateMachine = gameManager.agent.stateMachine;
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME GAMEPLAY STATE] ENTER() ");
			
			gameManager.startGame();
			
			stateMachine.setNextState(IState(gameManager.states[GameStates.PAUSE_GAME]));
			stateMachine.setNextState(IState(gameManager.states[GameStates.END_GAME]));
		}
		
		public function exit():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME GAMEPLAY STATE] EXIT() ");
		}
		
		public function update( diff:Number ):void
		{
			LevelManager.instance.update(diff);
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
			return GameStates.GAMEPLAY;
		}
	}
}