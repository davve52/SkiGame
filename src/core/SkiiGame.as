package core {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import starling.core.Starling;

	[SWF (frameRate="60", backgroundColor="0x000000")]
	public class SkiiGame extends Sprite{
		private var _starling:Starling;
		public function SkiiGame(){
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		protected function onLoadComplete(event:Event):void{
			_starling = new Starling(Game, stage);
			_starling.showStats = true;
			_starling.start();
		}
	}
}