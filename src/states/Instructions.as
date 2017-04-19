package states{
	import core.Game;
	import core.State;
	import core.Config;
	
	import starling.events.Event;
	
	import ui.GUI;

	public class Instructions extends State{
		private var instructions:String = "WELCOME TO THE SKI GAME. \n THIS IS HOW YOU PLAY THE GAME... \n TILT THE SCREEN TO MOVE THE SKIIER \n TRY TO SKI AS FAR AS POSSIBLE";
		private var _labelWidth:Number = 500;
		private var _labelHeight:Number = 200;
		private var _textSize:Number = 20;
		public function Instructions(fsm:Game, gui:GUI, width:Number, height:Number){
			super(fsm, gui, width, height);
			addEventListener(Event.ADDED_TO_STAGE, init );
		}
		
		private function init(event:Event):void {
			_gui.useLogo();
			_gui.createSimpleButton(_stageCenterX, _stageCenterY,
				"play", "play_normal", "play_click", "play_hover");
			_gui.createSimpleButton(_stageCenterX, (_stageHeight * 0.7),
				"menu", "menu_normal", "menu_click", "menu_hover");
			_gui.createLabel((_stageWidth * 0.2), (_stageHeight * 0.2),
				_labelWidth, _labelHeight, instructions, "Komika", _textSize, Config.ORANGE, Config.INSTRUCTIONS);
		}
		
		override public function destroy():void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_gui.clear();
			_gui = null;
		}
	}
}