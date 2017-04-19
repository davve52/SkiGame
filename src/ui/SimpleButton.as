package ui{
	import starling.display.Button;
	import starling.textures.Texture;
	
	public class SimpleButton extends Button{
		private var _buttonType:String = "";
		
		public function SimpleButton(xPoss:int, yPoss:int, type:String, upState:Texture, downState:Texture=null,
									 overState:Texture=null, disabledState:Texture=null, width:int=200, height:int=50){
			super(upState,"", downState, overState, disabledState);
			_buttonType = type;
			pivotX = width * 0.5;
			x = xPoss;
			y = yPoss;
		}
		
		public function buttonType():String{
			return _buttonType;
		}
	}
}