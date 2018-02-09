package com.avlivef 
{
	/**
	 * ...
	 * @author klanco
	 */
	import flash.display.MovieClip;
	import Valentina_mc;
	
	public class Valentina extends Actor
	{
		
		public function Valentina(scene:ActingScene, id:String) 
		{
			var valentinaSkeleton:MovieClip = new Valentina_mc();
			super(valentinaSkeleton, scene, "Valentina", id);	
		}
		
	}

}