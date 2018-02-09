package com.avlivef 
{
	import Charles_wilkinson_mc;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author klanco
	 */
	public class CharlesWilkinson extends Actor
	{
		
		public function CharlesWilkinson(scene:ActingScene, id:String) 
		{
			var charlesSkeleton:MovieClip = new Charles_wilkinson_mc;
			super(charlesSkeleton, scene, "CharlesWilkinson", id);		
			charlesSkeleton.x -= 15;
			charlesSkeleton.y -= 10;
		}
		
	}

}