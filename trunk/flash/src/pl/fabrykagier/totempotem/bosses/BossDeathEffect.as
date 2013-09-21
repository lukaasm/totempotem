package pl.fabrykagier.totempotem.bosses 
{
	import flash.geom.Point;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.data.BossData;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class BossDeathEffect extends GameObject 
	{
		public var size:Point;
		
		public function BossDeathEffect(atlases:Vector.<TextureAtlas>, textureName:String = "", w:int = 0, h:int = 0)
		{
			super(atlases, textureName);
			
			if (w != 0 && h != 0)
				size = new Point(w, h);
			else
				size = new Point(width, height);
				
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
		}
		
		public override function cleanup():void
		{
			removeChildren();

			super.cleanup();
		}
	}
}