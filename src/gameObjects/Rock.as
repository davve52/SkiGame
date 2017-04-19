package gameObjects{
	import core.Assets;
	import core.Entity;
	
	import starling.display.Image;
	
	public class Rock extends Entity{
        private var img:Image;
		public function Rock(x:Number=0, y:Number=820){
			super(x, y);
			img = new Image(Assets._ta.getTexture("rock"));
			addChild(img);
			alignPivot();
		}

		override public function destroy():void{
			img.removeFromParent(true);
			img = null;
		}
	}
}