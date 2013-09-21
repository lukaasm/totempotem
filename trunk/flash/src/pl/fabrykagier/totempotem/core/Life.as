package pl.fabrykagier.totempotem.core 
{
	import pl.fabrykagier.totempotem.managers.GameManager;
	
	public class Life 
	{
		private var _lives:int;
		private var owner:GameObject;
		
		public function Life(numOfLives:int, owner:GameObject) 
		{
			this.owner = owner;
			
			_lives = numOfLives;
		}
		
		public function addLife(numToAdd:int):void
		{
			_lives += numToAdd;
			
			if (owner is Player)
			{
				for (var i:int = 0; i < numToAdd; ++i)
					GameManager.instance.hud.addLife();
			}
		}
		
		public function subLife(numToSub:int):void
		{
			_lives -= numToSub;
			
			if (owner is Player)
			{
				for (var i:int = 0; i < numToSub; ++i)
					GameManager.instance.hud.takeLife();
			}
		}
		
		public function get lives():int 
		{
			return _lives;
		}
		
		public function set lives(value:int):void 
		{
			_lives = value;
		}
	}
}