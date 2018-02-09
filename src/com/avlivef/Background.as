package com.avlivef
{
	import Background_living;
	import flash.display.Sprite;
	import Foreground_living;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class Background extends Sprite
	{
		private var scene:ActingScene;
		public var backgroundImg:MovieClip;
		public var foregroundImg:MovieClip; 	
		public function Background(scene:ActingScene)
		{
			backgroundImg = new Background_living() as MovieClip;
			foregroundImg = new Foreground_living() as MovieClip;
			
			width = backgroundImg.width;
			height = backgroundImg.height;
			
			foregroundImg.alpha = 1;
		 	
			this.scene = scene;
			doubleClickEnabled = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick)
		}
		
		private function onMouseDoubleClick(e:MouseEvent):void
		{
			scene.zoomToDefault();
		}
	}

}