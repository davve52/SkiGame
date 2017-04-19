package states{
	import core.Game;
	import core.State;
	
	import starling.events.Event;
	
	import ui.GUI;

	public class Menu extends State{

		public function Menu(fsm:Game, gui:GUI, width:Number, height:Number){
			super(fsm, gui, width, height);
			addEventListener(Event.ADDED_TO_STAGE, init );
		}
		
		private function init(event:Event):void {
			_gui.useLogo();
			_gui.createSimpleButton(_stageCenterX, _stageCenterY,
				"play", "play_normal", "play_click", "play_hover");
			_gui.createSimpleButton(_stageCenterX, (_stageHeight * 0.7),
				"instructions", "instructions_normal", "instructions_click", "instructions_hover");
		}
		
		override public function destroy():void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_gui.clear();
			_gui = null;
		}
	}
}