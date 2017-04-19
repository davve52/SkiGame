/**
 * Created by davve on 2017-01-12.
 */
package events {
	import starling.events.Event;
	
	public class SpawnMonsterEvent extends Event{
		public static const SPAWNMONSTER:String = "spawnMonster";
		
		public function SpawnMonsterEvent(type:String, bubbles:Boolean=false, data:Object=null) {
			super (type, bubbles, data);
		}
	}
}
