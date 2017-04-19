package gameObjects{
	import core.Assets;
	import core.Config;
	import core.Entity;
	
	import starling.core.Starling;
	import starling.display.MovieClip;

	public class Monster extends Entity{
		private var _fps:Number = 12;
		private var _distance:Number = 0;
        private var _maxDistance:Number = 600;
        private var _animationNormal:MovieClip;
		private var _normalMonsterSpeed:Number = 2.7;
		private var _removeMonsterSpeed:Number = -1.7;

		public function Monster(x:Number,y:Number){
			super (x,y);
            _animationNormal = new MovieClip(Assets._ta.getTextures("monster"), _fps);
            _animationNormal.alignPivot();
            addChild(_animationNormal);

			Starling.juggler.add(_animationNormal);
			alignPivot();
			hide();
		}

        public function move(skiierPos:Number, skiiBoost:Boolean):void{
			if(!skiiBoost){
                var radians:Number =  Config.TO_RAD * skiierPos;
                x += Math.cos(radians) * _normalMonsterSpeed;
                y += Math.sin(radians) * _normalMonsterSpeed;
			}else{
                var radians1:Number =  Config.TO_RAD * skiierPos;
                x += Math.cos(radians1) * _removeMonsterSpeed;
                y += Math.sin(radians1) * _removeMonsterSpeed;
            }

            _distance++;
            if(_distance > _maxDistance){
				if(y > 0){
					var moveAway:Number =  Config.TO_RAD * skiierPos;
					y += Math.sin(moveAway) * -8;
				}else{
					hide();
					_distance = 0;	
				}
            }
        }
		
		public function hide():void{
			_animationNormal.pause();
			_animationNormal.visible = false;
			_isAlive = false;
		}
		
		public function spawn():void{
			_isAlive = true;
            _animationNormal.visible = true;
            _animationNormal.play();
            x = (Math.random() * 1000);
            y = -100;
		}

		override public function destroy():void{
            Starling.juggler.remove(_animationNormal);
		}
	}
}