package core{
	import events.DistanceEvent;
	import events.SpawnMonsterEvent;
	import events.SpeedBoostEvent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ScrollingBackground extends Sprite{
		private var _bg1:Image;
		private var _bg2:Image;
		private var _velY:Number = -4;
		private var _speed:Boolean = false;
		private var _distance:Number = 0;
		private var _spawnMonsterDistance:Number = 700;
		private var _checkDistance:Number = 500;
		private var _padding:Number = 20;
		
		public function ScrollingBackground() {
			_bg1 = new Image(Assets._bgTexture);
			addChild(_bg1);
			_bg1.scale = 1.5;
			
			_bg2 = new Image(Assets._bgTexture);
			_bg2.y = _bg1.height;
			addChild(_bg2);
			_bg2.scale = 1.5;
		}
		
		public function update():void{
			_bg1.y += _velY;
			if (_bg1.y < -_bg1.height + _padding){
				_bg1.y = _bg1.height;
			}
			_bg2.y += _velY;
			if (_bg2.y < -_bg2.height + _padding){
				_bg2.y = _bg2.height;
			}
			//Checking when to stop the speed, fast speed stops when background is between 400 - 410
			if((_bg1.y >= 400 && _bg1.y <=410) || (_bg1.y >= -400 && _bg1.y <=-410) && _speed){
				normalSpeed();
				dispatchEvent(new SpeedBoostEvent(SpeedBoostEvent.NORMALSPEED));
				_speed = false;
			}
			_distance ++;
			if (_distance > _spawnMonsterDistance) {
				dispatchEvent(new SpawnMonsterEvent(SpawnMonsterEvent.SPAWNMONSTER));
				_spawnMonsterDistance = _spawnMonsterDistance * 2;
			}
			
			if(_distance % _checkDistance == 0){
				dispatchEvent(new DistanceEvent(DistanceEvent.DISTANCE));
			}
			
		}
		
		public function distance():Number{
			var returnDistance:Number = _distance / 4;
			return returnDistance;
		}
		
		public function stop():void{
			_velY = Config.STOP_GAME_SPEED;
		}
		
		public function normalSpeed():void{
			_velY = Config.NORMAL_GAME_SPEED;
		}
		
		public function increaseSpeed():void{
			_speed = true;
			_velY = Config.FAST_GAME_SPEED;
		}
		
		public function destroy():void{
			_bg1.removeFromParent(true);
			_bg1 = null;
			_bg2.removeFromParent(true);
			_bg2 = null;
		}
	}
}