package pl.fabrykagier.totempotem.data 
{
	import flash.geom.Vector3D;
	
	public class GameData 
	{
		public static const FIRST_STATE:String = GameStates.LEVEL_CHANGE;
		
		public static const UPDATE_STEP:int = 30;
		
		public static const SCREEN_PROCENT:Number = 0.45;
		public static const SCREEN_SHIFT:Number = 0.02;
		public static const SCREEN_TEMPO:Number = 6;
		
		public static const INPUT_KEYBOARD:int = 1;
		public static const INPUT_TOUCHSCREEN:int = 2;
		
		public static const INPUT_TYPE:int = INPUT_KEYBOARD;
		
		public static const	PLAYER_MASS:int = 50;
		public static const PLAYER_MAX_JUMP_COUNT:int = 2;
		
		public static const SPLASH_SCREEN_MIN_TIME:int = 3000;
		
		public static const VELOCITY_LIMIT:Number = 0.90;
		public static const VELOCITY_LIMIT_STRAFE:Number = 0.36;
		public static const VELOCITY_LIMIT_STRAFE_MIDAIR:Number = VELOCITY_LIMIT_STRAFE;
		public static const VELOCITY_STRAFE_TO_SLIDE:int = 0.30;
		
		public static const FORCE_REACTION_LEFT:Vector3D = new Vector3D(-0.02, 0, 0);
		public static const FORCE_REACTION_RIGHT:Vector3D = new Vector3D(0.02, 0, 0);
		
		public static const FORCE_REACTION_SLIDE_LEFT:Vector3D = new Vector3D(0.22, 0.10, 0);
		public static const FORCE_REACTION_SLIDE_RIGHT:Vector3D = new Vector3D(-0.22, 0.10, 0);
		
		public static const FORCE_JUMP:Vector3D = new Vector3D(0, -1.3, 0);
		public static const FORCE_GRAVITY:Vector3D = new Vector3D(0, 0.075, 0);

		public static const FORCE_FRICTION_RIGHT:Vector3D = new Vector3D(-0.055, 0, 0);
		public static const FORCE_FRICTION_LEFT:Vector3D = new Vector3D(0.055, 0, 0);

		public static const FORCE_MOVE_LEFT:Vector3D = new Vector3D(-0.1, 0, 0);
		public static const FORCE_MOVE_RIGHT:Vector3D = new Vector3D(0.1, 0, 0);
		
		public static const FORCE_MOVE_UP:Vector3D = new Vector3D(0, -1, 0);
		public static const FORCE_MOVE_DOWN:Vector3D = new Vector3D(0, 0.5, 0);

		public static const PLATFORM_HEIGHT:int = 84;
		public static const PLATFORM_SPACE:int = 126;
		
		public static const PLAYER_RADIUS:int = PLATFORM_HEIGHT / 2;
		
		public static const DIRECTION_RIGHT:int = 1;
		public static const DIRECTION_LEFT:int = -1;
		
		public static const CANON_SHOOT_TIMER:int = 5000;
		public static const ITEM_DISAPPEAR_TIME:Number = 0.7;
		
		public static const AMMO_SPAWN_TIMER:int = 6000;
	}
}