package pl.fabrykagier.totempotem.states.gamestates 
{
	import flash.utils.getTimer;
	import pl.fabrykagier.totempotem.collisions.ICollidable;
	import pl.fabrykagier.totempotem.core.GameObject;
	import pl.fabrykagier.totempotem.core.Player;
	import pl.fabrykagier.totempotem.core.Utils;
	import pl.fabrykagier.totempotem.data.Debug;
	import pl.fabrykagier.totempotem.data.GameStates;
	import pl.fabrykagier.totempotem.managers.GameManager;
	import pl.fabrykagier.totempotem.statemachine.IState;
	import pl.fabrykagier.totempotem.statemachine.StateMachine;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class IntroState implements IState 
	{
		private var stateMachine:StateMachine;
		private var gameManager:GameManager;
		
		protected var enterTime:int;
		
		private var currentFrame:int;
		
		private var sprite:Sprite;
		private var frame:Image;
		private var frames:Vector.<Texture>;
		private var cloud1:Image;
		private var cloud2:Image;
		
		public function IntroState(gameManager:GameManager) 
		{
			this.gameManager = gameManager;
					
			if (gameManager.agent != null)
				stateMachine = gameManager.agent.stateMachine;
		}
		
		public function introComplete():void
		{
			gameManager.removeChild(sprite);
			stateMachine.changeState(IState(gameManager.states[GameStates.LEVEL_CHANGE]));
		}
		
		public function nextFrame():void
		{
			sprite.removeChild(frame);
			++currentFrame;
			
			if (currentFrame >= frames.length)
			{
				introComplete();
				return;
			}
			
			frame = new Image(frames[currentFrame]);
			sprite.addChild(frame);
		}
		
		public function enter():void
		{
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME INTRO STATE] ENTER() ");
			sprite = new Sprite();
			sprite.addChild(new Quad(1024, 768, 0x000000));
			gameManager.addChild(sprite);
			
			var atlases:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
			atlases.push(gameManager.assets.getTextureAtlas("intro_0"));
			atlases.push(gameManager.assets.getTextureAtlas("intro_1"));
			atlases.push(gameManager.assets.getTextureAtlas("intro_2"));
			
			frames = new Vector.<Texture>;
			for each (var atlas:TextureAtlas in atlases)
				atlas.getTextures("intro", frames);
				
			frames.sort(Utils.alphabeticalTexture);
				
			currentFrame = 0;
			
			frame = new Image(frames[currentFrame]);
			sprite.addChild(frame);
			
			var rest:TextureAtlas = gameManager.assets.getTextureAtlas("intro_2");
			cloud1 = new Image(rest.getTexture("cloud"));
			cloud2 = new Image(rest.getTexture("cloud"));
			
			cloud1.x = -200;
			cloud2.x = 1224 - cloud2.width;
			
			var tween:Tween = new Tween(cloud1, 3);
			tween.moveTo(-cloud1.width, cloud1.y);
			Starling.juggler.add(tween);
			
			tween = new Tween(cloud2, 3);
			tween.moveTo(1024, cloud2.y);
			tween.onComplete = onTweenDone;
			
			Starling.juggler.add(tween);
			
			sprite.addChild(cloud1);
			sprite.addChild(cloud2);
			
			if (gameManager.player == null)
				gameManager.player = new Player();
		}
		
		public function onTweenDone():void
		{
			var rest:TextureAtlas = gameManager.assets.getTextureAtlas("intro_2");
			
			var next:Button = new Button(rest.getTexture("nextbutton"), "");
			next.x = gameManager.stage.stageWidth - next.width;
			next.y = 682;
			
			var skip:Button = new Button(rest.getTexture("skip button"), " ");
			skip.y = 682;
			
			next.addEventListener(Event.TRIGGERED, nextFrame);
			skip.addEventListener(Event.TRIGGERED, introComplete);
			
			sprite.addChild(next);
			sprite.addChild(skip);
		}
		
		public function exit():void
		{
			gameManager.removeChild(sprite);
			sprite = null;
			frame = null;
			Debug.log(Debug.DEBUG_VERBOSE_STATES, "[GAME INTRO STATE] EXIT() ");
		}
		
		public function update( diff:Number ):void
		{
			
		}
		
		public function get activeTime():int
		{
			return getTimer() - enterTime;
		}
		
		public function get name():String
		{
			return GameStates.INTRO;
		}
	}
}