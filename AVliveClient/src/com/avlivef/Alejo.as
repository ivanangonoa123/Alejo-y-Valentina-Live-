package com.avlivef 
{
	import Alejo_mc;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author klanco
	 */
	public class Alejo extends Actor
	{
		
		public function Alejo(scene:ActingScene, id:String) 
		{
			var alejoSkeleton:MovieClip = new Alejo_mc;
			super(alejoSkeleton, scene, "Alejo", id);			
		}
		
	}

}