package gameObjects{
	import core.Assets;
	import core.Entity;
	
	import starling.display.Image;
	
	public class Flag extends Entity{
        private var img:Image;
		public function Flag(x:Number=0, y:Number = 820){
			super(x, y);
            img = new Image(Assets._ta.getTexture("flag"));
			addChild(img);
			alignPivot();
		}
		
		override public function destroy():void{
			removeFromParent(img);
			img = null;
		}
		
	}
}