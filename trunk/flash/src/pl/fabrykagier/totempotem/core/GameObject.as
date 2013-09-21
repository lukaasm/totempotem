package pl.fabrykagier.totempotem.core 
{
	import flash.geom.*;
	import flash.utils.*;
	import pl.fabrykagier.totempotem.data.*;
	import pl.fabrykagier.totempotem.physics.*;
	import pl.fabrykagier.totempotem.statemachine.*;
	import starling.core.*;
	import starling.display.*;
	import starling.events.*;
	import starling.textures.*;
	
	public class GameObject extends Sprite
	{
		protected var _agent:Agent;
		protected var _atlases:Vector.<TextureAtlas>;
		protected var objectImage:Image;
		protected var _position:Point;
		protected var _currentAnimation:String;
		protected var animations:Dictionary;
		
		public function GameObject(atlases:Vector.<TextureAtlas> = null, textureName:String = "")
		{
			super();
			
			this.name = textureName;
			
			_position = new Point(this.x, this.y);
	
			_currentAnimation = "";
			animations = new Dictionary();
			
			_atlases = atlases;
			if (atlases == null || textureName == "")
				return;
			
			var texture:Texture = null;
			for each (var atlas:TextureAtlas in atlases)
			{
				texture = atlas.getTexture(textureName);
				if (texture != null)
					break;
			}
			
			if (texture == null)
				return;
				
			objectImage = new Image(texture);
			objectImage.x = -int(objectImage.width / 2);
			objectImage.y = -int(objectImage.height / 2);
			addChild(objectImage);
		}
		
		public function addAnimation(name:String, fps:int = 24):void
		{
			Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, "[GameObject] animation added: " + name);
			
			var textures:Vector.<Texture> = new Vector.<Texture>;
			for each (var atlas:TextureAtlas in atlases)
				atlas.getTextures(name, textures);
			
			textures.sort(Utils.alphabeticalTexture);
			
			var lower:int = (this is Player) ? 5 : 0;
			var clip:MovieClip = new MovieClip(textures, fps);
			
			clip.name = name;// + "_right";
			
			clip.x = - int(clip.width / 2);
			clip.y = - int (clip.height / 2)+lower;

			animations[clip.name] = clip;
			
			switch (name)
			{
				case Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2:
				case Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1:
				{
					textures.splice(0, textures.length);
					
					var t:String = "";
					if (name == Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2)
						t = Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1;
					else
						t = Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2;
						
					for each (var atlas2:TextureAtlas in atlases)
						atlas2.getTextures(t, textures);
						
					textures.sort(Utils.alphabeticalTexture);
					break;
				}
			}
			
			clip = new MovieClip(textures, fps);
			clip.name = name + "_left";
			
			clip.scaleX = -1;
			
			clip.x = int(clip.width / 2);
			clip.y = - int (clip.height / 2)+lower;

			animations[clip.name] = clip;
		}
		
		public function addAnimationBackwords(name:String, fps:int = 24):void
		{
			Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, "[GameObject] animation added: " + name);
			
			var textures:Vector.<Texture> = new Vector.<Texture>;
			for each (var atlas:TextureAtlas in atlases)
				atlas.getTextures(name, textures);
			
			textures.sort(Utils.unalphabeticalTexture);
			
			var lower:int = (this is Player) ? 5 : 0;
			var clip:MovieClip = new MovieClip(textures, fps);
			
			clip.name = name;// + "_right";
			
			clip.x = - int(clip.width / 2);
			clip.y = - int (clip.height / 2)+lower;

			animations[clip.name] = clip;
			
			switch (name)
			{
				case Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2:
				case Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1:
				{
					textures.splice(0, textures.length);
					
					var t:String = "";
					if (name == Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2)
						t = Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_1;
					else
						t = Animations.ANIMATION_PLAYER_SLIDE_TRIANGLE_2;
						
					for each (var atlas2:TextureAtlas in atlases)
						atlas2.getTextures(t, textures);
						
					textures.sort(Utils.alphabeticalTexture);
					break;
				}
			}
			
			clip = new MovieClip(textures, fps);
			clip.name = name + "_left";
			
			clip.scaleX = -1;
			
			clip.x = int(clip.width / 2);
			clip.y = - int (clip.height / 2)+lower;

			animations[clip.name] = clip;
		}
		
		public function animationClip(name:String):MovieClip
		{
			return animations[name];
		}
		
		public function playAnimation(name:String, callback:Function = null, loop:Boolean = true):void
		{
			var clip:MovieClip;
			
			if (name == currentAnimation)
			{
				Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, 
						"[GameObject] animation in progress, name: " + name);
				clip = animations[currentAnimation];
				if (!clip.isPlaying)
					clip.play();
					
				return;
			}
			
			stopAnimation();
			
			clip = animations[name];
			if (clip == null)
			{
				Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, 
						"[GameObject] there is no animation with name: " + name);
				return;
			}
			
			clip.loop = loop;
			
			if (callback != null)
				clip.addEventListener(Event.COMPLETE, callback);
			
			//clip.addEventListener(Event.COMPLETE, onAnimationEnd);
				
			Starling.juggler.add(animations[name]);
			addChild(animations[name]);
			
			clip.play();

			_currentAnimation = name;
			
			//if (objectImage)
				//objectImage.alpha = 0;
			
			Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, "[GameObject] animation played: " + name);
		}
	
		public function switchAnimation(clip1:MovieClip, clip2:MovieClip):void
		{
			clip2.loop = clip1.loop;
			clip2.currentFrame = clip1.currentFrame;
			
			removeChild(clip1);
			addChild(clip2);
			
			Starling.juggler.remove(clip1);
			Starling.juggler.add(clip2);
			
			_currentAnimation = clip2.name;
			
			clip1.stop();
			clip2.play();
			
			Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, "[GameObject] switched animation " + clip1.name + " with " + clip2.name);
		}
		
		public function isAnimationInProgress(name:String = ""):Boolean
		{
			name = name == "" ? currentAnimation : name;
			return currentAnimation == name;
		}
		
		public function pauseAnimation():void
		{
			if (currentAnimation != "" && animations[currentAnimation] != null)
			{
				var clip:MovieClip = animations[currentAnimation];
				clip.pause();
			}
		}
		
		public function stopAnimation():void
		{
			if (currentAnimation != "" && animations[currentAnimation] != null)
			{
				var clip:MovieClip = animations[currentAnimation];
				
				clip.removeEventListeners();
				
				Starling.juggler.remove(clip);
				removeChild(clip);
				
				clip.stop();
				
				//if (objectImage)
				//	objectImage.alpha = 1;
				
				Debug.log(Debug.DEBUG_VERBOSE_GAMEOBJECT, 
						"[GameObject] animation stopped: " + _currentAnimation);
				
				_currentAnimation = "";
			}			
		}
		
		public function onAnimationEnd():void
		{
			stopAnimation();
		}
		
		public function update(diff:Number):void
		{
		}
		
		public function cleanup():void
		{
			stopAnimation();
			removeChildren();
			
			_position = null;
			animations = null;
			_atlases = null;
			
			objectImage = null;
			
			dispose();
		}
		
		public function getAnimationClip(name:String):MovieClip
		{
			return MovieClip(animations[name]);
		}
		
		public function get rigidBody():RigidBody
		{
			return null;
		}
		
		public function get position():Point
		{
			if (this.parent != null)
			{
				_position.x = this.parent.x + this.x;
				_position.y = this.parent.y + this.y;
			}
			else
			{
				_position.x = this.x;
				_position.y = this.y;
			}
				
			return _position;
		}
		
		public function get agent():Agent 
		{
			return _agent;
		}
		
		public function get currentAnimation():String 
		{
			return _currentAnimation;
		}
		
		public function get atlases():Vector.<TextureAtlas> 
		{
			return _atlases;
		}
	}
}