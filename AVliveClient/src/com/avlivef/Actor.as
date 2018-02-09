package com.avlivef
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class Actor extends MovieClip
	{
		protected var skeleton:MovieClip;
		protected var boca:MovieClip;
		
		public var actorName:String;
		public var id:String;
		
		public static const STATE_WALKING:uint = 0;
		public static const STATE_WALKING_TWEEN:uint = 1;
		public static const STATE_STANDING:uint = 2;
		public static const STATE_SKILL:uint = 3;
		
		public static const ORIENTATION_FRONT:String = "front";
		public static const ORIENTATION_LEFT:String = "left";
		public static const ORIENTATION_RIGHT:String = "right";
		public static const ORIENTATION_BACK:String = "back";
		
		public static const MAX_SPEED:uint = 20;
		
		protected static const CURRENT_ANIM_STANDING:uint = 0;
		protected static const CURRENT_ANIM_WALKING:uint = 1;
		protected static const CURRENT_ANIM_SKILL:uint = 2;
		
		public static const STATE_TALKING:uint = 0;
		public static const STATE_MUTE:uint = 1;
		public static const STATE_CGHE:uint = 2;
		
		public var state:uint;
		public var mouthState:uint;
		protected var currentAnimation:uint;
		public var currentOrientation:String;
		
		public var mouseSpeed:Number;
		public var mousePosition:Point;
		
		protected var actingScene:ActingScene;
		protected var currentSkill:Skill;
		
		public var skills:Object;
		
		public var tl:TimelineLite;
		
		private var cghe:Skill;
		private var isExiting:Boolean;
		public var audioManager:AudioManager;
		public var soundChannelRef:SoundChannel;
		
		public function Actor(movieClip:MovieClip, actingScene:ActingScene, actorName:String, id:String)
		{
			audioManager = AudioManager.getInstance();
			isExiting = false;
			tl = new TimelineLite();
			skills = new Object();
			this.actingScene = actingScene;
			this.actorName = actorName;
			skeleton = movieClip;
			boca = skeleton.getChildByName("boca") as MovieClip;
			
			skeleton.y -= skeleton.height / 1.2;
			
			if (id == null)
				this.id = new String(new Date().time / 10000).split(".")[1] + Math.round(Math.random() * 9);
			else
				this.id = id;
			
			this.x = actingScene.background.backgroundImg.width;
			this.y = actingScene.background.backgroundImg.height * 0.5;
			
			this.addChild(skeleton);
			
			state = STATE_STANDING;
			
			mouseSpeed = MAX_SPEED;
			mousePosition = new Point(0, 0);
			
			if (actingScene.networkManager.connectionType == 0)
			{
				addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
				addEventListener(MouseEvent.CLICK, onMouseClick);
				doubleClickEnabled = true;
				mouseChildren = false;
				
			}
			
			currentOrientation = ORIENTATION_FRONT;
			skeleton.gotoAndStop("stand_front");
			
			enterScene();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			initGeneralSkills();
		}
		
		public function initGeneralSkills():void
		{
			cghe = new Skill("cghe", Keyboard.G, true, 0, true);
			skills[cghe.name] = cghe;
		}
		
		public function onKeyDownHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.G: 
					shutSkills();
					cghe.isSet = true;
					actingScene.broadcastSkill(this.id, cghe.name, cghe.isSet);
			}
		}
		
		public function onKeyUpHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.G: 
					shutSkills();
					mouthState = STATE_TALKING;
					shut();
					actingScene.broadcastSkill(this.id, cghe.name, cghe.isSet);
			}
		}
		
		private function onMouseDoubleClick(e:MouseEvent):void
		{
			actingScene.changeCurrentSelection(this, true, true)
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			actingScene.changeCurrentSelection(this, false, true);
		}
		
		public function setMousePosition(point:Point):void
		{
			mousePosition.setTo(point.x, point.y);
		}
		
		public function tweenToPoint(point:Point, easing:String, duration:Number):void
		{
			TweenLite.fromTo(this, duration, {rotation: 40, y: this.y}, {rotation: 0, y: 0, ease: easing});			 
			TweenLite.fromTo(this, duration,{x:x,y:y} ,{x: point.x, y: point.y, ease: easing});
			mousePosition.setTo(point.x, point.y);
			state = STATE_WALKING_TWEEN;
		}
		
		private function onEnterFrame(e:Event):void
		{
			trace(state);
			
			var xDistance:Number = mousePosition.x - this.x;
			var yDistance:Number = mousePosition.y - this.y;
			
			if (Math.sqrt(yDistance * yDistance + xDistance * xDistance) < mouseSpeed)
			{
				this.x = mousePosition.x;
				this.y = mousePosition.y;
				
				if (state != STATE_SKILL)
					state = STATE_STANDING;
				
				if (isExiting)
				{
					actingScene.removeChildFromContainer(this);
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					audioManager.playSound(audioManager.doorSound, false);
				}
			}
			else if (state != STATE_WALKING_TWEEN)
				
			{
				var radian:Number = Math.atan2(yDistance, xDistance);
				this.x += Math.cos(radian) * mouseSpeed;
				this.y += Math.sin(radian) * mouseSpeed;
				
				state = STATE_WALKING;
			}
			
			updateAnimation();
			
			state = STATE_STANDING;
			for (var name:String in skills)
			{
				if (skills[name].isSet)
				{
					currentSkill = skills[name];
					state = STATE_SKILL;
					
					if (skills[name].isMouthSkill)
						mouthState = STATE_CGHE;
					break;
				}
				
			}
		}
		
		public var labelString:String;
		
		protected function updateAnimation():void
		{
			
			if (state == STATE_STANDING && currentAnimation != CURRENT_ANIM_STANDING)
			{
				labelString = "stand_" + currentOrientation;
				skeleton.gotoAndStop(labelString);
				currentAnimation = CURRENT_ANIM_STANDING;
				
				if(soundChannelRef!=null)
				audioManager.stopSound(soundChannelRef);
			}
			else if (state == STATE_WALKING && currentAnimation != CURRENT_ANIM_WALKING)
			{
				labelString = "walk_" + currentOrientation;
				skeleton.gotoAndPlay(labelString);
				currentAnimation = CURRENT_ANIM_WALKING;
				soundChannelRef = audioManager.playSound(audioManager.stepSound, true);
			}
			else if (state == STATE_SKILL && currentAnimation != CURRENT_ANIM_SKILL)
			{
				
				if (currentSkill.stopInFrame)
				{
					if (currentSkill.isMouthSkill)
						boca.gotoAndStop(currentSkill.name);
					else
						skeleton.gotoAndStop(currentSkill.name);
				}
				else
				{
					if (currentSkill.isMouthSkill)
						boca.gotoAndPlay(currentSkill.name);
					else
						skeleton.gotoAndPlay(currentSkill.name);
				}
				
				currentAnimation = CURRENT_ANIM_SKILL;
			}
		
		}
		
		private function enterScene():void
		{
			setMousePosition(new Point(actingScene.width * 0.5, actingScene.height * 0.5));
		}
		
		public function talk():void
		{
			if (mouthState != STATE_TALKING && mouthState != STATE_CGHE)
			{
				boca.gotoAndStop("talk");
				mouthState = STATE_TALKING;
			}
		}
		
		public function shut():void
		{
			if (mouthState != STATE_MUTE && mouthState != STATE_CGHE)
			{
				boca.gotoAndStop("mute");
				mouthState = STATE_MUTE;
			}
		}
		
		public function getLocalPoint():Point
		{
			return localToGlobal(new Point(this.x, this.y));
		}
		
		public function detach():void
		{
			shut();
			shutSkills();
			
			state = STATE_STANDING;
		}
		
		public function shutSkills():void
		{
			for (var name:String in skills)
			{
				skills[name].isSet = false;
			}
		}
		
		public function setOrientation(orientation:String, tween:Boolean):void
		{
			currentOrientation = orientation;
			
			labelString = "stand_" + orientation;
			
			if (tween)
			{
				tl.to(this.skeleton, 0.1, {scaleX: 0});
				skeleton.gotoAndStop(labelString);
				tl.to(this.skeleton, 0.1, {scaleX: 1});
			}
			else
			{
				skeleton.gotoAndStop(labelString);
			}
		}
		
		public function exitScene(direction:String):void
		{
			switch (direction)
			{
				case "left": 
					mousePosition.x = -50;
					isExiting = true;
					break;
				case "right": 
					break;
			
			}
		}
	
	}

}