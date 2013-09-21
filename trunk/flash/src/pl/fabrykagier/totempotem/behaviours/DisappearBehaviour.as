package pl.fabrykagier.totempotem.behaviours 
{
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Item;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.Platform;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class DisappearBehaviour implements IBehaviour 
	{
		private var owner:GameObject;
		private var fadeTime:Number;
		
		private var started:Boolean;
		private var destroyOnComplite:Boolean;
		
		public function DisappearBehaviour(owner:GameObject, time:Number, destroyOnComplite:Boolean = true, start:Boolean = false) 
		{
			this.owner = owner;
			
			fadeTime = time;
			this.destroyOnComplite = destroyOnComplite;
			started = false;
			
			if (start)
				onCollision(null, 0);
		}
		
		public function onCollision(invoker:ICollidable, collisionSide:int):void
		{
			if (started)
				return;
			
			Debug.log(Debug.DEBUG_VERBOSE_ITEM_BEHAVIOURS, "[DISAPPEAR] CREATE TWEEN");
			
			var tween:Tween = new Tween(owner, fadeTime, Transitions.EASE_IN_OUT);
			tween.scaleTo(1.5);
			tween.fadeTo(0);
			
			if (this.destroyOnComplite == true)
				tween.onComplete = destroy;
			
			Starling.juggler.add(tween);
			
			if (owner is Platform)
				SoundManager.instance.playSound(SoundsData.PLATFORM_DISAPPEAR, 0, 5 * SoundsData.MUTE_SOUND);
			
			if (this.destroyOnComplite == true)
				Starling.juggler.delayCall(CollisionManager.instance.unregister, fadeTime / 2, owner);
			
			if (owner is Item && owner.name != "spike")
			{
				tween = new Tween(owner, fadeTime, Transitions.EASE_IN_OUT);
				tween.animate("rotation", 200);
				Starling.juggler.add(tween);
				
				tween = new Tween(owner, fadeTime, Transitions.EASE_IN_OUT_BOUNCE);
				tween.moveTo(owner.x, owner.y - 200);
				Starling.juggler.add(tween);
			}
			
			started = true;
		}
		
		private function destroy():void
		{
			//Debug.log(Debug.DEBUG_VERBOSE_ITEM_BEHAVIOURS, "[DISAPPEAR] DESTROY ITEM");

			LevelManager.instance.level.removeElement(owner);
		}
		
		public function onNoCollision(invoker:ICollidable):void
		{
			
		}
		
		public function update(diff:Number):void
		{
			
		}
	}
}