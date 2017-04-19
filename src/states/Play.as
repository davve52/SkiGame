package states {
	import core.Config;
	import core.Entity;
	import core.Game;
	import core.ScrollingBackground;
	import core.State;
	import core.Utils;
	
	import events.DistanceEvent;
	import events.SkiierCrashEvent;
	import events.SpawnMonsterEvent;
	import events.SpeedBoostEvent;
	
	import gameObjects.Flag;
	import gameObjects.Monster;
	import gameObjects.Rock;
	import gameObjects.Skiier;
	import gameObjects.SpeedBoost;
	import gameObjects.Three;
	
	import starling.events.Event;
	
	import ui.GUI;
	
	public class Play extends State {
		private var _skiier:Skiier;
		private var _monster:Monster;
		private var _threes:Vector.<Entity> = new Vector.<Entity>;
		private var _rocks:Vector.<Entity> = new Vector.<Entity>;
		private var _speedBoost:Vector.<Entity> = new Vector.<Entity>;
		private var _flags:Vector.<Entity> = new Vector.<Entity>;
		private var _gameOver:Boolean = false;
		private var _spawnNbr:Number = 7;
		private var _lives:int = 3;
		private var _scrollingBackground:ScrollingBackground;
		private var _skiierBoost:Boolean = false;
		private var _scaleWorld:Number = 1;
		
		public function Play(fsm:Game, gui:GUI, bg:ScrollingBackground, width:Number, height:Number, scaleWorld:Number) {
			super(fsm, gui, width, height);
			_scrollingBackground = bg;
			_scaleWorld = scaleWorld;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void {
			_monster = new Monster(_stageCenterX, 0);
			addChild(_monster);
			_skiier = new Skiier(_stageCenterX, _stageCenterY * 0.7);
			_skiier.addEventListener(SkiierCrashEvent.CRASH, skiierCrashed);
			_skiier.addEventListener(SkiierCrashEvent.MONSTER, skiierCrashed);
			_skiier.addEventListener(SpeedBoostEvent.INCREASESPEED, speedBoost);
			_skiier.addEventListener(SpeedBoostEvent.NORMALSPEED, speedBoost);
			addChild(_skiier);
			addEntitesToVector();
			setupGUI();
			_scrollingBackground.normalSpeed();
			_scrollingBackground.addEventListener(SpeedBoostEvent.NORMALSPEED, speedBoost);
			_scrollingBackground.addEventListener(SpawnMonsterEvent.SPAWNMONSTER, spawnMonster);
			_scrollingBackground.addEventListener(DistanceEvent.DISTANCE, updateDistance);
			
		}
		
		
		private function updateDistance(event:DistanceEvent):void {
			var skiierDistance:Number = _scrollingBackground.distance();
			_gui.updateLabel("DISTANCE: " + skiierDistance + "M", Config.DISTANCE);
		}
		
		private function setupGUI():void {
			_gui.createLabel((_stageCenterX * 0.2), Config.WORLD_Y_TOP, 100, 100, "HP: " + _lives, "Komika", 25, 0xFFA500, Config.LIVES);
			_gui.createLabel((_stageCenterX * 0.7), Config.WORLD_Y_TOP, 400, 100, "DISTANCE: 0", "Komika", 20, 0xFFA500, Config.DISTANCE);
		}
		
		private function spawnMonster(event:SpawnMonsterEvent):void {
			if (!_monster._isAlive){
				_monster.spawn();
			}
		}
		
		private function skiierCrashed(event:SkiierCrashEvent):void {
			if(event.type == SkiierCrashEvent.CRASH){
				_scrollingBackground.stop();
				manageEntitySpeed(2);
				_skiier.crashParticle();
				_lives--;
			}else if(event.type == SkiierCrashEvent.MONSTER){
				_scrollingBackground.stop();
				manageEntitySpeed(2);
				_skiier.crashParticle();
				_lives = 0;
			}
			updateHPGUI();
			if (_lives == 0) {
				_gameOver = true;
			}
		}
		
		public function manageEntitySpeed(speedType:int):void{
			if(speedType == 0){
				var incSpeed:Vector.<Entity> = getAllEntities(false);
				for (var i:Number = incSpeed.length - 1; i >= 0; i--) {
					_scrollingBackground.increaseSpeed();
					incSpeed[i].speedVY = Config.FAST_GAME_SPEED;
				}
				_skiier.speedVY = -Config.FAST_GAME_SPEED;
			}else if(speedType == 1) {
				var slowSpeed:Vector.<Entity> = getAllEntities(false);
				for (var j:Number = slowSpeed.length - 1; j >= 0; j--) {
					_scrollingBackground.normalSpeed();
					slowSpeed[j].speedVY = Config.NORMAL_GAME_SPEED;
				}
				_skiier.speedVY = -Config.NORMAL_GAME_SPEED;
			}else if(speedType == 2){
				var stop:Vector.<Entity> = getAllEntities(false);
				for (var k:Number = stop.length - 1; k >= 0; k--) {
					stop[k].speedVY = Config.STOP_GAME_SPEED;
				}
				_skiier.speedVY = -Config.STOP_GAME_SPEED;
			}
		}
		
		private function speedBoost(event:SpeedBoostEvent):void {
			if (event.type == SpeedBoostEvent.INCREASESPEED) {
				_skiierBoost = true;
				manageEntitySpeed(0);
			}
			if (event.type == SpeedBoostEvent.NORMALSPEED){
				_skiierBoost = false;
				manageEntitySpeed(1);
			}
		}
		
		private function updateHPGUI():void {
			_gui.updateLabel("HP: " + _lives, Config.LIVES);
		}
		
		override public function update():void {
			if (!_gameOver) {
				_scrollingBackground.update();
				var entities:Vector.<Entity> = getAllEntities(true);
				for (var i:Number = 0; i < entities.length; i++) {
					entities[i].update();
				}
				if (_monster._isAlive) {
					_monster.move(skiierPosition(), _skiierBoost);
				}
				checkCollisions();
				spawnEntities();
			}else{
				_fsm.changeState(Game.GAME_OVER_STATE);
			}
		}
		
		private function skiierPosition():Number {
			var dx:Number = _skiier.centerX - _monster.centerX;
			var dy:Number = _skiier.centerY - _monster.centerY;
			var deg:Number = Config.TO_DEG * (Math.atan2(dy, dx));
			return deg;
		}
		
		private function spawnEntities():void {
			var entities:Vector.<Entity> = getAllEntities(false);
			var temp:Entity;
			var randomEntity:int = Utils.getRandomNumber(0, entities.length - 1);
			temp = entities[randomEntity] as Entity;
			if (!temp.visible) {
				var xpos:Number = (Utils.coinFlip())
					? Utils.getRandomNumber(temp.width, _stageCenterX)
					: Utils.getRandomNumber(_stageCenterX, _stageWidth);
				temp.x = xpos - temp.width * 0.5;
				temp.y = Utils.getRandomNumber(_stageCenterY * 2, _stageHeight * 2) + temp.height;
				temp._isAlive = true;
				temp.visible = true;
			}
		}
		
		private function checkCollisions():void {
			for each(var entity:Entity in getAllEntities(false)) {
				if (entity._isAlive) {
					if (_skiier.isColliding(entity)) {
						_skiier.onCollision(entity);
						break;
					}
				}
			}
			if(_monster.isColliding(_skiier)){
				_skiier.onCollision(_monster);
			}
		}
		
		private function getAllEntities(includeSkiier:Boolean):Vector.<Entity> {
			var entities:Vector.<Entity> = _threes.concat(_speedBoost, _rocks, _flags);
			if (includeSkiier) {
				entities.push(_skiier);
			}
			return entities;
		}
		
		private function addEntitesToVector():void {
			while (_spawnNbr--) {
				if (_spawnNbr > 2) {
					var three:Three = new Three();
					three.scale = _scaleWorld;
					if(Utils.coinFlip()) {
						three.x = Utils.getRandomNumber(three.width, _stageCenterX);
						three.y = Utils.getRandomNumber(_stageCenterY, _stageWidth * 2);
					}else{
						three._isAlive = false;
						three.visible = false;
					}
					addEntity(three);
				}
				if (_spawnNbr > 3) {
					var rock:Rock = new Rock();
					rock.scale = _scaleWorld;
					if(Utils.coinFlip()) {
						rock.x = Utils.getRandomNumber(rock.width, _stageCenterX);
						rock.y = Utils.getRandomNumber(_stageCenterY, _stageWidth * 2);
					}else{
						rock._isAlive = false;
						rock.visible = false;
					}
					addEntity(rock);
				}
				if (_spawnNbr > 4) {
					var jump:SpeedBoost = new SpeedBoost();
					jump.scale = _scaleWorld;
					if(Utils.coinFlip()) {
						jump.x = Utils.getRandomNumber(jump.width, _stageCenterX);
						jump.y = Utils.getRandomNumber(_stageCenterY, _stageWidth * 2);
					}else{
						jump._isAlive = false;
						jump.visible = false;
					}
					addEntity(jump);
				}
				if (_spawnNbr > 3) {
					var flag:Flag = new Flag();
					flag.scale = _scaleWorld;
					if(Utils.coinFlip()) {
						flag.x = Utils.getRandomNumber(flag.width, _stageCenterX);
						flag.y = Utils.getRandomNumber(_stageCenterY, _stageWidth * 2);
					}else{
						flag._isAlive = false;
						flag.visible = false;
					}
					addEntity(flag);
				}
			}
		}
		
		private function removeAllEntities():void {
			removeEntity(_threes);
			removeEntity(_rocks);
			removeEntity(_speedBoost);
			removeEntity(_flags);
			_skiier.destroy();
			_skiier.removeFromParent(true);
			_monster.destroy();
			_monster.removeFromParent(true);
		}
		
		private function removeEntity(entities:Vector.<Entity>):void {
			var temp:Entity;
			for (var i:Number = entities.length - 1; i >= 0; i--) {
				temp = entities[i] as Entity;
				temp.destroy();
				temp.removeFromParent(true);
				entities.removeAt(i);
			}
		}
		
		private function addEntity(entity:Entity):void {
			if (entity is Three) {
				_threes.push(entity);
			} else if (entity is Rock) {
				_rocks.push(entity);
			} else if (entity is SpeedBoost) {
				_speedBoost.push(entity);
			} else if (entity is Flag) {
				_flags.push(entity);
			}
			addChild(entity);
		}
		
		override public function destroy():void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			_skiier.removeEventListener(SkiierCrashEvent.CRASH, skiierCrashed);
			_skiier.removeEventListener(SkiierCrashEvent.MONSTER, skiierCrashed);
			_skiier.removeEventListener(SpeedBoostEvent.INCREASESPEED, speedBoost);
			_skiier.removeEventListener(SpeedBoostEvent.NORMALSPEED, speedBoost);
			removeAllEntities();
			_scrollingBackground.removeEventListener(SpeedBoostEvent.NORMALSPEED, speedBoost);
			_scrollingBackground.removeEventListener(SpawnMonsterEvent.SPAWNMONSTER, spawnMonster);
			_scrollingBackground.removeEventListener(DistanceEvent.DISTANCE, updateDistance);
			_scrollingBackground.stop();
			_scrollingBackground = null;
			_monster = null;
			_gui.clear();
			_gui = null;
			_threes = null;
			_rocks = null;
			_flags = null;
			_skiier = null;
			_speedBoost = null;
		}
		
		override public function onEnter():void {
			
		}
		
		override public function onLostFocus():void {
			
		}
	}
}