package com.avlivef 
{
	import Viejo_mc;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author klanco
	 */
	public class Viejo extends Actor
	{
		
		public function Viejo(scene:ActingScene, id:String) 
		{
			var viejoSkeleton:MovieClip = new Viejo_mc;
			super(viejoSkeleton, scene, "Viejo", id);
			viejoSkeleton.x -= 15;
			viejoSkeleton.y += 20;
		}
		
	}

}