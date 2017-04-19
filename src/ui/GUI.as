package ui{
	import core.Assets;
	import core.Game;
	import core.Config;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import ui.SimpleButton;

public class GUI extends Sprite{
		private var _buttons:Vector.<SimpleButton> = new Vector.<SimpleButton>;
		private var _labels:Vector.<Label> = new Vector.<Label>;
		private var _title:Image;
		private var _fsm:Game;
		private var _scaleWorld:Number = 0;
		
		public function GUI(fsm:Game, scaleWorld:Number){
			this._fsm = fsm;
			_scaleWorld = scaleWorld;
		}

		public function useLogo():void{
			_title = new Image(Assets._ta.getTexture("logo"));
			_title.pivotX = _title.width * 0.5;
			_title.x = stage.stageWidth * 0.5;
			_title.y = stage.stageHeight * 0.1;
			_title.scale = _scaleWorld;
			addChild(_title);
		}
		
		public function createSimpleButton(xPos:Number, yPos:Number, type:String, normal:String, click:String, hover:String):void{
			var button:SimpleButton = new SimpleButton(xPos, yPos, type, Assets._ta.getTexture(normal),
			Assets._ta.getTexture(click),Assets._ta.getTexture(hover),
			Assets._ta.getTexture(normal));
			button.addEventListener(Event.TRIGGERED, onButtonClick);
			button.scale = _scaleWorld;
			_buttons.push(button);
			addChild(button);
		}
		
		public function createLabel(xPos:Number, yPos:Number, width:int, height:int, text:String, fontName:String, size:Number, color:uint, type:String):void{
			var label:Label = new Label(width, height, text, fontName, size, color, type);
			label.x = xPos;
			label.y = yPos;
			label.scale = _scaleWorld;
			_labels.push(label);
			addChild(label);
		}
		
		public function updateLabel(text:String, labelType:String):void{
			for(var i:Number = _labels.length-1; i >= 0; i--){
				if (labelType == Config.LIVES){
                    if(_labels[i].getLabelType() == Config.LIVES){
                        _labels[i].text = text;
                    }
				}
                if (labelType == Config.DISTANCE){
                    if(_labels[i].getLabelType() == Config.DISTANCE){
                        _labels[i].text = text;
                    }
                }
			}
		}
		
		private function onButtonClick(e:Event):void{
			for(var i:int = 0; i<_buttons.length; i++){
				if(_buttons[i] == e.target){
					if(_buttons[i].buttonType() == "play"){
						_fsm.changeState(Game.PLAY_STATE);
					}else if(_buttons[i].buttonType() == "instructions"){
						_fsm.changeState(Game.INSTRUCT_STATE);
					}else if(_buttons[i].buttonType() == "menu"){
						_fsm.changeState(Game.MENU_STATE);
					}
				}
			}
		}
		
		public function removeLogo():void{
			_title.dispose();
		}
		
		public function clear():void{
			for(var i:Number = _buttons.length-1; i >= 0; i--){
				_buttons[i].removeFromParent(true);
				_buttons.removeAt(i);
			}
			
			for(var j:Number = _labels.length-1; j >= 0; j--){
				_labels[j].removeFromParent(true);
				_labels.removeAt(j);
			}
			_title.removeFromParent(false);
		}
	}
}