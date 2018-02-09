package com.avlivef
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class Camera extends MovieClip
	{
		private var scene:ActingScene;
		public var cameraOffset:Point;
		public var isZoomed:Boolean;
		public var isFollow:Boolean;
		
		//public var cameraScale:Number;
		
		private var tl:TimelineLite;
		private var lastRegistrationPoint:Point;
		
		public function Camera(scene:ActingScene)
		{
			this.scene = scene;
			isZoomed = false;
			cameraOffset = new Point(0, 0);
			lastRegistrationPoint = new Point(0, 0);
			//	cameraScale = 1;
			tl = new TimelineLite();
			isFollow = false;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);			
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}
		
		public function offsetZoomRegistrationPoint(regPointX:Number, regPointY:Number):void
		{
			var globallll:Point = new Point(regPointX * scene.scaleX, regPointY * scene.scaleY);
			var contOffset:Point = scene.localToGlobal(new Point(scene.container.x, scene.container.y));
			scene.container.localToGlobal(globallll);
			
			scene.x = globallll.x + contOffset.x;
			scene.y = globallll.y + contOffset.y;
			
			scene.container.x = scene.globalToLocal(contOffset).x;
			scene.container.y = scene.globalToLocal(contOffset).y;
		}
		
		public function onMouseWheelHandler(e:MouseEvent):void
		{
			//	offsetZoomRegistrationPoint();
			//	cameraScale += e.delta * 0.03;
			//scene.scaleX = scene.scaleY = cameraScale;
		}
		
		public function moveLeft():void
		{
			cameraOffset.x -= 20;
			scene.x += 20;
		}
		
		public function moveRight():void
		{
			cameraOffset.x += 20;
			scene.x -= 20;
		}
		
		public function moveTo(xPos:Number, yPos:Number):void
		{
		
		}
		
		public function zoomToDefault():void
		{
			TweenLite.to(scene, 0.5, {scaleX: 1, scaleY: 1});
			var ceroInContainer:Point = scene.globalToLocal(new Point(0, 0));
			trace(ceroInContainer);
			TweenLite.to(scene.container, 0.5, {x: ceroInContainer.x * scene.scaleX, y: ceroInContainer.y * scene.scaleY});
		}
		
		public function center(xPos:Number, yPos:Number):void
		{
			var centerInContainer:Point = new Point(((stage.stageWidth * 0.5) - scene.x) - scene.container.x, ((stage.stageHeight * 0.5) - scene.y) - scene.container.y);
			// trace("cc : "  + centerInContainer +"///////// xpos:"+ xPos);
			
			scene.container.x += (centerInContainer.x - xPos) / scene.scaleX;
			scene.container.y += (centerInContainer.y - yPos) / scene.scaleY;
			
			offsetZoomRegistrationPoint(xPos, yPos);
			lastRegistrationPoint.setTo(xPos, yPos);
			scene.scaleX = scene.scaleY = 1.5;
			isZoomed = true;
		}
		
		public function initZoom(x:Number, y:Number):void {
				scene.scaleX = scene.scaleY = 1.5;			 
				isZoomed = true;
		}
		
		public function unzoom(x:Number, y:Number):void
		{
			if (isZoomed)
			{
				zoomToDefault();
				isZoomed = false;
			}
		}
		public function zoom(x:Number, y:Number):void
		{
			if (!isZoomed)
			{
				tl.to(scene, 1, {scaleX: 1.5, scaleY: 1.5});
				lastRegistrationPoint.setTo(x, y);
				isZoomed = true;
			}
			else
			{
				/*offsetZoomRegistrationPoint(lastRegistrationPoint.x, lastRegistrationPoint.y);
				tl.to(scene, 1, {scaleX: 1, scaleY: 1});
				
				var contOffset:Point = scene.globalToLocal(new Point(0, 0));
				//	tl.to(scene.container, 1 , { x:contOffset.x, y:contOffset.y });*/
				zoomToDefault();
				isZoomed = false;
			}
		}
	}

}