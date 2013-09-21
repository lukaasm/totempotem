package pl.fabrykagier.totempotem.core 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.behaviours.DisappearBehaviour;
	import pl.fabrykagier.totempotem.behaviours.KillBehaviour;
	import pl.fabrykagier.totempotem.behaviours.MoveBehaviour;
	import pl.fabrykagier.totempotem.behaviours.TransparentBehaviour;
	import pl.fabrykagier.totempotem.behaviours.UpdateBehaviour;
	import pl.fabrykagier.totempotem.bosses.Sting;
	import pl.fabrykagier.totempotem.data.CollisionData;
	import pl.fabrykagier.totempotem.data.fireboss.FireBossEncounter;
	import pl.fabrykagier.totempotem.data.GameData;
	import pl.fabrykagier.totempotem.data.PlatformMovementDirection;
	import pl.fabrykagier.totempotem.data.SoundsData;
	import pl.fabrykagier.totempotem.level.Level;
	import pl.fabrykagier.totempotem.managers.CollisionManager;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.managers.LevelManager;
	import pl.fabrykagier.totempotem.managers.SoundManager;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
	public class Canon extends GameObject
	{
		private var shootTimer:int;
		
		private var timer:int;
		
		public function Canon(atlases:Vector.<TextureAtlas>, timer:int) 
		{
			super(atlases, "canon0001");
			
			this.timer = timer;
			shootTimer = timer;
			
			addAnimation("canon");
		}
		
		public override function update(diff:Number):void
		{
			if (shootTimer <= diff)
			{
				shoot();
				shootTimer = 100000;
			}
			else
				shootTimer -= diff;
		}
		
		private function shoot():void
		{
			stopAnimation();
			playAnimation("canon", onAnimationComplete, false);
		}
		
		private function onAnimationComplete():void
		{
			var level:Level = LevelManager.instance.level;
			var spike:Item = new Item(atlases, "spike");
			
			spike.x = this.x - 25;
			spike.y = this.y + 5;
			
			if(Utils.magPointPoint(this.position, GameManager.instance.player.position) < 1000)
				SoundManager.instance.playSound(SoundsData.CANNON_SHOOT, 0, 0.6 * SoundsData.MUTE_SOUND);
			
			//spike.addBehaviour(new UpdateBehaviour(spike, this.moveSpike));
			spike.addBehaviour(new TransparentBehaviour(spike, new Point(0, 0), new Point(30, 15), CollisionData.COLLISION_GROUP_ITEM));
			spike.addBehaviour(new KillBehaviour(this, CollisionData.COLLISION_SIDE_NONE));
			spike.addBehaviour(new DisappearBehaviour(spike, 7, true, true));
			level.addElement(spike);
			
			var t:Tween = new Tween(spike, 10);
			t.moveTo(spike.x - 5024, spike.y);
			Starling.juggler.add(t);
			
			//Starling.juggler.delayCall(level.removeElement, 5, spike);
			
			shootTimer = timer;
		}
		
		public function moveSpike(owner:GameObject):void
		{
			owner.x += FireBossEncounter.STING_SPEED;
		}
	}
}