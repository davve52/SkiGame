/**
 * Created by davve on 2017-01-12.
 */
package events {
	import starling.events.Event;
	
	public class SpeedBoostEvent extends Event{
		public static const INCREASESPEED:String = "increaseSpeed";
		public static const NORMALSPEED:String = "stopSpeed";
		
		public function SpeedBoostEvent(type:String, bubbles:Boolean=false, data:Object=null) {
			super (type, bubbles, data);
		}
	}
}
