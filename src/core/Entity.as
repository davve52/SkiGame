package core{
	import starling.display.Sprite;

	public class Entity extends Sprite{
		public function get centerY():Number { return y + (height * 0.5); }
		public function get centerX():Number { return x + (width * 0.5); }
		public function get halfWidth():Number{return width * 0.5;}
		public function get halfHeight():Number{return height * 0.5;}
		public function get bottom():Number{return y + height;}
		public function get right():Number{return x + width;}
		public function get left():Number{return x;}
		public function get top():Number{return y;}
		public function get _radius():Number{return (width+height)*0.15;}
		
		public function set bottom(y:Number):void{this.y = y - height;}
		public function set right(x:Number):void{this.x = x - width;}
		public function set left(x:Number):void{this.x = x;}
		public function set top(y:Number):void{this.y = y;}
		public function set centerY(y:Number):void {  this.y = y - (height * 0.5); }	
		public function set centerX(x:Number):void {  this.x = x - (width * 0.5); }

        public function set speedVY(speed:Number):void{ this._speedVY = speed;}
        public function get speedVY():Number{return _speedVY;}
		
		protected var _vx:Number = 0;
		protected var _vy:Number = 0;
		public var _isAlive:Boolean = true;
		protected var _speedVY:Number = -4;
		
		public function Entity(x:Number, y:Number){
			super();
			this.x = x;
			this.y = y;
		}
		
		public function isColliding(that:Entity):Boolean{
			return (Utils.distanceSq(this, that) < ((this._radius + that._radius) * (this._radius + that._radius)));
		}
		
		public function onCollision(that:Entity):void{
			
		}
		
		public function update():void{
			x += _vx;
			y += _speedVY;

			worldWrap();
		}
		
		public function worldWrap():void{
            if(y < 0){
                _isAlive = false;
                this.visible = false;
            }
		}
		
		public function reset():void{
		
		}
		
		public function destroy():void{
			
		}
	}
}