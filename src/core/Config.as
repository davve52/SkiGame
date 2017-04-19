package core{
	
	public class Config{
		
		//World settings
		public static const WORLD_Y_TOP:Number = 20;
		public static const BUTTON_WIDTH:Number = 200;
		public static const BUTTON_HEIGHT:Number = 50;
		
		//Usefull stuff
		public static const TO_RAD:Number =  (Math.PI/180);
		public static const TO_DEG:Number =  (180 / Math.PI);
		
		public static const LIVES:String = "score";
		public static const GAME_OVER:String = "gameOver";
		public static const INSTRUCTIONS:String = "instructions";
		public static const DISTANCE:String = "distance";
		
		//Game values
		public static const NORMAL_GAME_SPEED:Number = -4;
		public static const STOP_GAME_SPEED:Number = 0;
		public static const FAST_GAME_SPEED:Number = -8;
		
		//Screen widths
		public static const BIG_SCREEN:Number = 1500;
		public static const MEDIUM_SCREEN:Number = 1000;
		public static const SMALL_SCREEN:Number = 800;
		
		//Color
		public static const ORANGE:uint = 0xFFA500;
		
		public function Config(){
		}
		
	}
}