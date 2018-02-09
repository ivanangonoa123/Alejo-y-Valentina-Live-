package com.avlivef 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author klanco
	 */
	public class CameraContainer extends MovieClip
	{
		private var scene:ActingScene;
		private var containerOffset:Point;
		public function CameraContainer(scene:ActingScene) 
		{
			this.scene = scene;
			containerOffset = new Point();
		}
		
		public function getContainerOffset():Point 
		{
		 return containerOffset;
		}
		
	}

}