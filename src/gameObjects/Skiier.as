package gameObjects {
	import flash.display.Stage;
	import flash.events.AccelerometerEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	
	import core.Assets;
	import core.Entity;
	import core.Utils;
	
	import de.flintfabrik.starling.extensions.FFParticleSystem;
	import de.flintfabrik.starling.extensions.FFParticleSystem.SystemOptions;
	
	import events.SkiierCrashEvent;
	import events.SpeedBoostEvent;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	public class Skiier extends Entity {
		private var _fps:Number = 12;
		private var _easing:Number = 0.75;
		private var _animationNormal:MovieClip;
		private var _animationSmallTurn:MovieClip;
		private var _animationBigTurn:MovieClip;
		private var _ns:Stage = Starling.current.nativeStage;
		private var _crash:FFParticleSystem;
		private var _accelerometer:Accelerometer = new Accelerometer();
		
		public function Skiier(x:Number, y:Number) {
			super(x, y);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void {
			_animationNormal = new MovieClip(Assets._ta.getTextures("skiierDown"), _fps);
			_animationNormal.alignPivot();
			addChild(_animationNormal);
			
			_animationSmallTurn = new MovieClip(Assets._ta.getTextures("small"), _fps);
			_animationSmallTurn.alignPivot();
			addChild(_animationSmallTurn);
			_animationSmallTurn.visible = false;
			
			_animationBigTurn = new MovieClip(Assets._ta.getTextures("big"), _fps);
			_animationBigTurn.alignPivot();
			addChild(_animationBigTurn);
			_animationBigTurn.visible = false;
			
			Starling.juggler.add(_animationNormal);
			Starling.juggler.add(_animationSmallTurn);
			Starling.juggler.add(_animationBigTurn);
			
			alignPivot();
			
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, accelerometerHandler);
			
			var conf:SystemOptions = SystemOptions.fromXML(XML(new Assets.CrashXML()), Assets._texture);
			_crash = new FFParticleSystem(conf);
			parent.addChild(_crash);
		}
		
		public function crashParticle():void{
			_crash.start(0.5);
		}
		
		private function stop(mc:MovieClip):void {
			mc.pause();
			mc.visible = false;
		}
		
		private function start(mc:MovieClip):void {
			mc.visible = true;
			mc.play();
		}
		
		override public function update():void {
			if(_accelerometer.muted){
				checkInput();
			}
			if(!_crash.playing && this._speedVY == 0){
				dispatchEvent(new SpeedBoostEvent(SpeedBoostEvent.NORMALSPEED));
			}
			worldWrapping();
		}
		
		private function worldWrapping():void{
			if(x < 0){
				x = _ns.stageWidth;
			}
			
			if(x > _ns.stageWidth){
				x = 0;
			}
		}
		
		private function changeAnimation(dx:Number):void {
			if (Math.abs(dx) < 7) {
				start(_animationNormal);
				stop(_animationSmallTurn);
				stop(_animationBigTurn);
			} else if (Math.abs(dx) < 30) {
				start(_animationSmallTurn);
				stop(_animationNormal);
				stop(_animationBigTurn);
				_animationSmallTurn.scaleX = (dx < 0) ? -1 : 1;
			} else {
				start(_animationBigTurn);
				stop(_animationNormal);
				stop(_animationSmallTurn);
				_animationBigTurn.scaleX = (dx < 0) ? 1 : -1;
			}
		}
		
		private function accelerometerHandler(event:AccelerometerEvent):void{
			if(!_crash.playing) {
				var sensorX:Number = event.accelerationX;
				var velX:Number = sensorX * 100;
				changeAnimation(velX);
				x -= velX * _easing;
			}
		}
		
		private function checkInput():void {
			if(!_crash.playing) {
				var dx:Number = (_ns.mouseX - x);
				x += dx * _easing;
				changeAnimation(dx);
				
			}
		}
		
		override public function isColliding(that:Entity):Boolean{
			if(that is SpeedBoost){
				return Utils.getOverlap(this, that, new Point(0,0));
			}else{
				return super.isColliding(that);
			}
			
		}
		
		override public function onCollision(that:Entity):void {
			if (that is SpeedBoost) {
				that._isAlive = false;
				dispatchEvent(new SpeedBoostEvent(SpeedBoostEvent.INCREASESPEED));
			} else if (that is Monster) {
				_crash.emitterX = that.centerX;
				_crash.emitterY = that.centerY;
				dispatchEvent(new SkiierCrashEvent(SkiierCrashEvent.MONSTER));
			} else {
				that._isAlive = false;
				_crash.emitterX = that.centerX;
				_crash.emitterY = that.centerY;
				dispatchEvent(new SkiierCrashEvent(SkiierCrashEvent.CRASH));
			}
		}
		
		override public function destroy():void {
			Starling.juggler.remove(_animationNormal);
			Starling.juggler.remove(_animationSmallTurn);
			Starling.juggler.remove(_animationBigTurn);
			_animationNormal.removeFromParent(true);
			_animationSmallTurn.removeFromParent(true);
			_animationBigTurn.removeFromParent(true);
			_animationNormal = null;
			_animationSmallTurn = null;
			_animationBigTurn = null;
			_ns = null;
			_accelerometer.removeEventListener(AccelerometerEvent.UPDATE, accelerometerHandler);
			_accelerometer = null;
			_crash.removeFromParent(true);
			_crash = null;
		}
	}
}