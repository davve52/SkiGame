/**
 * Created by davve on 2017-01-16.
 */
package events {
	import starling.events.Event;
	
	public class DistanceEvent extends Event{
		public static const DISTANCE:String = "distance";
		public function DistanceEvent(type:String, bubbles:Boolean=false, data:Object=null){
			super(type, bubbles, data);
		}
	}
}
