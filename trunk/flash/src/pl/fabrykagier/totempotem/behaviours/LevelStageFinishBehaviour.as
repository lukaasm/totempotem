package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.data.BossData;
	import pl.fabrykagier.totempotem.data.LevelStates;
	import pl.fabrykagier.totempotem.data.Popups;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	
	public class LevelStageFinishBehaviour implements IBehaviour 
	{
		public function LevelStageFinishBehaviour()
		{}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void 
		{
			var level:Level = LevelManager.instance.level;
			
			switch (level.boss.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					return GameManager.instance.showPopup(Popups.POPUP_STAGECLEAR1);
				case BossData.TYPE_FIRE_BOSS:
					return GameManager.instance.showPopup(Popups.POPUP_STAGECLEAR2);
			}
		}
		
		public function onNoCollision(invoker:ICollidable):void 
		{}
		
		public function update(diff:Number):void 
		{}
	}
}