package gameObjects{
	import core.Assets;
	import core.Entity;
	
	import starling.display.Image;
	
	public class Three extends Entity{
        private var img:Image;
		public function Three(x:Number=0, y:Number=820){
			super(x, y);
			img = new Image(Assets._ta.getTexture("three"));
			addChild(img);
			alignPivot();
		}

		override public function destroy():void{
			img.removeFromParent(true);
			img = null;
		}
	}
}