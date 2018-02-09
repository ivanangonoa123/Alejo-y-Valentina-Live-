package com.avlivef
{
	
	/**
	 * ...
	 * @author klanco
	 */
	public class Skill
	{
		
		public var name:String;
		public var keyCode:uint;
		public var stopInFrame:Boolean;
		public var isSet:Boolean;
		public var duration:Number;
		public var isMouthSkill:Boolean;
		
		public function Skill(name:String, keyCode:uint, stopInFrame:Boolean, duration:uint, isMouthSkill:Boolean):void
		{
			this.name = name;
			this.keyCode = keyCode;
			this.stopInFrame = stopInFrame;
			this.isMouthSkill = isMouthSkill;
			isSet = false;
			
			this.duration = duration;
		}
		
		public function setSkill(isSet:Boolean):void
		{
			this.isSet = isSet;
		}
	
	}

}