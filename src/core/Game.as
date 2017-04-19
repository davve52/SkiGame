package core{	
	import flash.events.Event;
	import flash.desktop.*;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.GameOver;
	import states.Instructions;
	import states.Menu;
	import states.Play;
	
	import ui.GUI;
	
	public class Game extends Sprite{
		public static const MENU_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const INSTRUCT_STATE:int = 3;
		public static const GAME_OVER_STATE:int = 4;
		public static const GAME_SAVE_STATE:int = 5;
		private var _width:Number = Starling.current.stage.stageWidth;
		private var _height:Number = Starling.current.stage.stageHeight;
		private var _gameState:State;
		private var _gui:GUI;
        private var _bg:ScrollingBackground;
		private var _scaleWorld:Number = 1;
		
		public function get worldWidth():Number{return _width;}
		public function get worldHeight():Number{return _height;}
		
		private var _currentState:State;
		
		public function Game(){
			super();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:starling.events.Event):void {
			if(_width > Config.BIG_SCREEN){
				_scaleWorld = 2.0;
				trace("a bit smallerr");
			}else if(_scaleWorld > Config.MEDIUM_SCREEN){
				_scaleWorld = 1.5;
				trace("medium small");
			}else{
				trace("smallest");
				_scaleWorld = 1;
			}
			Assets.init();
            _bg = new ScrollingBackground();
            addChild(_bg);
			_gui = new GUI(this, _scaleWorld);
			addChild(_gui);
			changeState(MENU_STATE);
			addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivate, false, 0, true);
			
		}
		
		public function changeState(nextState:int):void{
			if(_currentState != null && _currentState != _gameState){
				_currentState.destroy();
				_currentState.removeFromParent(true);
				_currentState = null;
			}else if(_currentState != null && nextState == GAME_OVER_STATE){
				_currentState.destroy();
				_currentState.removeFromParent(true);
				_currentState = null;
			}
			
			switch(nextState){
				case MENU_STATE :
					_currentState = new Menu(this, _gui, _width, _height);
					break;
				case PLAY_STATE :
					_currentState = new Play(this, _gui, _bg, _width, _height, _scaleWorld);
					break;
				case INSTRUCT_STATE :
					_currentState = new Instructions(this, _gui, _width, _height);
					break;
				case GAME_OVER_STATE :
					_currentState = new GameOver(this, _gui, _width, _height);	
					break;
				case GAME_SAVE_STATE : 
					_currentState = _gameState;
					break;
				default:
					_currentState = new Menu(this, _gui, _width, _height);
					break;
			}
			
			if(nextState == PLAY_STATE){
				_gameState = _currentState;
				
			}
			addChild(_currentState);
			_currentState.onEnter();
			
		}
		
		private function onEnterFrame(event:starling.events.Event):void{
			if(_currentState != null){
				_currentState.update();
			}
		}
		
		private function onDeactivate(e:flash.events.Event):void{
			NativeApplication.nativeApplication.removeEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
			Starling.current.stop();
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActivate, false, 0, true);
		}
		
		private function onActivate(e:flash.events.Event):void{
			NativeApplication.nativeApplication.removeEventListener(flash.events.Event.ACTIVATE, onEnterFrame);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			Starling.current.start();
		}
	}
}