package pl.fabrykagier.totempotem.behaviours 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.PlayerStates;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	
	public class KillBehaviour implements IBehaviour 
	{
		private var collisionSide:int;
		private var owner:GameObject;
		
		public function KillBehaviour(owner:GameObject, collisionSide:int) 
		{
			this.collisionSide = collisionSide;
			this.owner = owner;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (this.collisionSide == collisionSide || this.collisionSide == CollisionData.COLLISION_SIDE_NONE)
			{
				if (invoker is Player)
				{
					if (Player(invoker).agent.stateMachine.currentState.name != PlayerStates.STATE_PLAYER_DYING)
					{
						var player:Player = Player(invoker);
						
						var level:Level = LevelManager.instance.level;
						if (level.isBossFight())
							level.boss.handlePlayerDeath();
						else
						{
							if (owner is Platform)
							{
								if (Platform(owner).kill == true)
								{
									player.life.subLife(1);
									player.changeState(PlayerStates.STATE_PLAYER_DYING);
								}
							}
							else
							{
								player.life.subLife(1);
								player.changeState(PlayerStates.STATE_PLAYER_DYING);
							}
						}
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