package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	
	public class AddDamageBehaviour implements IBehaviour 
	{
		private var damage:int;
		
		public function AddDamageBehaviour(damage:int = 1 ) 
		{
			this.damage = damage;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void 
		{
			if (invoker is Player)
			{
				if (Player(invoker).agent.stateMachine.currentState.name != PlayerStates.STATE_PLAYER_HURT)
				{
					Player(invoker).life.subLife(damage);
					if(Player(invoker).life.lives > 0)
						Player(invoker).changeState(PlayerStates.STATE_PLAYER_HURT);
					else
					{
						var level:Level = LevelManager.instance.level;
						if (level.isBossFight())
							level.boss.handlePlayerDeath();
						else
							Player(invoker).changeState(PlayerStates.STATE_PLAYER_DYING);
					}
				}
			}
		}
		
		public function onNoCollision(invoker:ICollidable):void 
		{
			
		}
		
		public function update(diff:Number):void 
		{
			
		}
		
	}

}