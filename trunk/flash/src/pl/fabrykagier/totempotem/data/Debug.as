package pl.fabrykagier.totempotem.data 
{
	public class Debug 
	{
		public static const DEBUG_SHOW_STATS:Boolean = false;
		public static const DEBUG_DRAW_COLLISION:Boolean = false;
		public static const DEBUG_TRACE_ASSETS:Boolean = false;
		public static const DEBUG_LEVEL_LITE:Boolean = false;
		
		public static const DEBUG_VERBOSE_STATES:int 	 	= 0x001;
		public static const DEBUG_VERBOSE_GAMEOBJECT:int 	= 0x002;
		public static const DEBUG_VERBOSE_EFFECTS:int 	 	= 0x004;
		public static const DEBUG_VERBOSE_PLATFORM_BEHAVIOURS:int 	= 0x008;
		public static const DEBUG_VERBOSE_ITEM_BEHAVIOURS:int 	= 0x010;
		
		public static const DEBUG_VERBOSE_NOTHING:int = 0x000;
		public static const DEBUG_VERBOSE_EVERYTHING:int = 0xFFF;
		
		public static const DEBUG_VERBOSE_MASK:int = DEBUG_VERBOSE_NOTHING;
		
		public static var DEBUG_FIRE_LEVEL:Boolean = false;
		
		static public function log(type:int, message:String):void
		{
			if (DEBUG_VERBOSE_MASK & type)
				trace(message);
		}
	}
}