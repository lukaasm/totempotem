package pl.fabrykagier.totempotem.states.playerstates 
{
	import flash.events.VideoEvent;
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.core.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.*;
	import pl.fabrykagier.totempotem.physics.*;
	import pl.fabrykagier.totempotem.collisions.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	import starling.display.MovieClip;
	
	public class AttackState implements IState, IPlayerState
	{
		private var stateMachine:StateMachine;
		private var self:Player;
		private var done:Boolean;
		
		private var prevState:String;
		
		protected var enterTime:int;
		
		public function AttackState(self:Player) 
		{
			this.self = self;
			
			if (self.agent != null)
				stateMachine = self.agent.stateMachine;
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			
		}
		
		public function onData(key:int, value:int):void
		{
			
		}
		
		public function enter():void
		{		
			self.playAnimation(Animations.ANIMATION_PLAYER_ATTACK, restore, false);
			
			var clip:MovieClip = self.getAnimationClip(self.currentAnimation);
			clip.currentFrame = 6;
			
			enterTime = getTimer();
			
			if (self.agent.stateMachine.previousState && self.agent.stateMachine.previousState.name != "")
				prevState = self.agent.stateMachine.previousState.name;
			else
				prevState = PlayerStates.STATE_PLAYER_IDLE;
				
			done = false;
		}
		
		private function restore():void
		{
			self.changeState(prevState);
		}
		
		public function exit():void
		{
		}
		
		public function update( diff:Number ):void
		{
			var clip:MovieClip = self.getAnimationClip(self.currentAnimation);
			if (clip.currentFrame < 3 || done)
				return;
			
			done = true;
			
			var level:Level = LevelManager.instance.level;
			var bullet:GameObject = null;
			switch (level.type)
			{
				case BossData.TYPE_EARTH_BOSS:
					--PlayerData.PLAYER_AMMO_EARTH_COUNT;
					
					bullet = new Bullet (self.atlases, "ammo_earth");
					break;
				case BossData.TYPE_FIRE_BOSS:
					--PlayerData.PLAYER_AMMO_FIRE_COUNT;
					
					bullet = new Bullet (self.atlases, "ammo_fire");
					break;
			}
			
			bullet.x = self.position.x + GameData.PLAYER_RADIUS;
			bullet.y = self.y;
			
			self.bullets.push(bullet);
			
			GameManager.instance.addChild(bullet);
			CollisionManager.instance.register(ICollidable(bullet));
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return PlayerStates.STATE_PLAYER_ATTACK;
		}
	}
}