package ui{
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	public class Label extends TextField{
		private var _labelType:String = "";
		public function Label(width:int, height:int, text:String, fontName:String, size:Number, color:uint, labelType:String){
			this._labelType = labelType;
			var textFormat:TextFormat = new TextFormat(fontName, size, color);
			super(width, height, text, textFormat);
		}
		
		public function getLabelType():String{
			return _labelType;
		}
	}
}