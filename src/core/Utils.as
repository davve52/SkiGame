package core{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import starling.display.DisplayObject;

	public class Utils{
		public function Utils(){
		}
		
		public static function coinFlip():Boolean{
			return Math.random() < 0.5;
		}
		
		public static function lineCircleIntersection(lineStart:Point, lineEnd:Point, entity:Entity):Boolean {
			var angle:Number = Math.atan2((lineEnd.y-lineStart.y), (lineEnd.x-lineStart.x));
			var dx:Number = entity.centerX-((lineStart.x+lineEnd.x) * 0.5);
			var dy:Number = entity.centerY-((lineStart.y+lineEnd.y) * 0.5);
			return (Math.abs(Math.cos(angle)*dy - Math.sin(angle)*dx) < entity._radius);
		}
		
		public static function distanceSq(lhs:Entity, rhs:Entity):Number{
			var dx:Number = lhs.centerX - rhs.centerX;
			var dy:Number = lhs.centerY - rhs.centerY;
			return (dx*dx + dy*dy);
		}
		
		public static function distance (lhs:Entity, rhs:Entity):Number{
			var dx:Number = lhs.centerX - rhs.centerX;
			var dy:Number = lhs.centerY - rhs.centerY;
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public static function getRandomNumber(min:Number, max:Number):Number{
			return Math.random() * ( max-min + 1) + min;
		}
		
		public static function centeredRotation(o:DisplayObject, degrees:Number):void{
			if(degrees == o.rotation){
				return;
			}
			var bounds:Rectangle = o.getBounds(o.parent);
			var center:Point = new Point(bounds.x + bounds.width*0.5, bounds.y + bounds.height*0.5);
			o.rotation = degrees;
			bounds = o.getBounds(o.parent);
			var newCenter:Point = new Point(bounds.x + bounds.width *0.5, bounds.y + bounds.height *0.5);
			o.x += center.x - newCenter.x;
			o.y += center.y - newCenter.y;
		}
		
		public static function getOverlap(e1:Entity, e2:Entity, overlap:Point):Boolean {
			overlap.setTo(0, 0);
			var centerDeltaX:Number = e1.centerX - e2.centerX;
			var halfWidths:Number = (e1.width + e2.width) * 0.5;
			
			if (Math.abs(centerDeltaX) > halfWidths) return false; //no overlap on x == no collision
			
			var centerDeltaY:Number = e1.centerY - e2.centerY;
			var halfHeights:Number = (e1.height + e2.height) * 0.5;
			
			if (Math.abs(centerDeltaY) > halfHeights) return false; //no overlap on y == no collision
			
			var dx:Number = halfWidths - Math.abs(centerDeltaX); //overlap on x
			var dy:Number = halfHeights - Math.abs(centerDeltaY); //overlap on y
			if (dy < dx) {
				overlap.y = (centerDeltaY < 0) ? -dy : dy;
			} else if (dy > dx) {
				overlap.x = (centerDeltaX < 0) ? -dx : dx;
			} else {
				overlap.x = (centerDeltaX < 0) ? -dx : dx;
				overlap.y = (centerDeltaY < 0) ? -dy : dy;
			}
			return true;
		}
	}
}