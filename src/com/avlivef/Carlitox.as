package com.avlivef
{
	import Carlitox_mc;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class Carlitox extends Actor
	{
		private var isJojojing:Boolean;
		private var jojojoSkill:Skill;
		private var flotarSkill:Skill;
		
		public function Carlitox(scene:ActingScene, id:String)
		{
			var carlitoxSkeleton:MovieClip = new Carlitox_mc;
			super(carlitoxSkeleton, scene, "Carlitox", id);
			carlitoxSkeleton.y -= 20;
			isJojojing = false;
			
			jojojoSkill = new Skill("jojojo", Keyboard.J, false, 0, false);
			flotarSkill = new Skill("flotar", Keyboard.F, true, 0, false);
			
			skills[jojojoSkill.name] = jojojoSkill;
			skills[flotarSkill.name] = flotarSkill;

		}
		
		override public function talk():void
		{
			if (mouthState != STATE_TALKING && mouthState != STATE_CGHE)
			{
				if (jojojoSkill.isSet)
					boca.gotoAndStop("oh");
				else
					boca.gotoAndStop("talk");
				
				mouthState = STATE_TALKING;
			}
		}
		
		override public function onKeyDownHandler(e:KeyboardEvent):void
		{
			super.onKeyDownHandler(e);
			
			switch (e.keyCode)
			{
				case Keyboard.J: 
					shutSkills();
					jojojoSkill.isSet = true;
					actingScene.broadcastSkill(this.id, jojojoSkill.name, jojojoSkill.isSet);
					break;
				case Keyboard.F: 
					shutSkills();
					flotarSkill.isSet = true;
					actingScene.broadcastSkill(this.id, flotarSkill.name, flotarSkill.isSet);
					break;
			}
		}
		
		override public function onKeyUpHandler(e:KeyboardEvent):void
		{
			super.onKeyUpHandler(e);
			
			switch (e.keyCode)
			{
				case Keyboard.J: 
					if (jojojoSkill.isSet)
					{
						jojojoSkill.isSet = false;
						actingScene.broadcastSkill(this.id, jojojoSkill.name, jojojoSkill.isSet);
					}
					break;
				case Keyboard.F: 
					if (flotarSkill.isSet)
					{
						flotarSkill.isSet = false;
						actingScene.broadcastSkill(this.id, flotarSkill.name, flotarSkill.isSet);
					}
					break;
			}
		}
	
	}

}