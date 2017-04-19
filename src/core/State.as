package core{
	import starling.display.Sprite;
	
	import ui.GUI;
	
	public class State extends Sprite{
		protected var _fsm:Game;
		protected var _gui:GUI;
		protected var _stageWidth:Number;
		protected var _stageHeight:Number;
		protected var _stageCenterX:Number;
		protected var _stageCenterY:Number;
		
		public function State(fsm:Game, gui:GUI, width:Number, height:Number){
			super();
			_fsm = fsm;
			_gui = gui;
			_stageHeight = height;
			_stageWidth = width;
			_stageCenterX = width * 0.5;
			_stageCenterY = height * 0.5;
		}
		
		public function destroy():void{
			_fsm = null;
			_gui = null;
		}
		
		public function update():void{
		}
		
		public function onEnter():void{
			
		}
		
		public function onLostFocus():void{
			
		}
	}
	
}