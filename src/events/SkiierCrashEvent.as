package events{
	import starling.events.Event;
	public class SkiierCrashEvent extends Event{
		public static const CRASH:String = "crash";
		public static const MONSTER:String = "monster";
		
		public function SkiierCrashEvent(type:String, bubbles:Boolean=false, data:Object=null){
			super(type, bubbles, data);
		}
	}
}