package gameObjects{
	import core.Assets;
	import core.Entity;

	import starling.display.Image;
	
	public class SpeedBoost extends Entity{
		private var img:Image;
		public function SpeedBoost(x:Number=0, y:Number=820){
			super(x, y);
			img = new Image(Assets._ta.getTexture("jump"));
			addChild(img);
			alignPivot();
		}

		override public function destroy():void{
			img.removeFromParent(true);
			img = null;
		}
	}
}