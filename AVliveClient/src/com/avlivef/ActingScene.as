package com.avlivef
{
	import com.net.NetworkManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.events.SyncEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import com.avlivef.Background
	
	/**
	 * ...
	 * @author klanco
	 */
	public class ActingScene extends MovieClip
	{
		
		public var greenSceneCrosshair:Sprite = new Sprite();
		public var redContainerCrosshair:Sprite = new Sprite();
		
		public var selectionSprite:Sprite;
		
		public var background:Background;
		private var alejo:Alejo;
		private var valentina:Valentina;
		private var carlitox:Carlitox;
		private var viejo:Viejo;
		private var charlesWilkinson:CharlesWilkinson;
		private var actingContainer:MovieClip;
		
		public var container:CameraContainer;
		public var currentSelection:Actor;
		public var camera:Camera;
		
		private var gui:Gui;
		
		private var actorListSO:SharedObject;
		private var propertiesSO:SharedObject;
		
		public var networkManager:NetworkManager;
		
		private var actors:Object;
		private var isFirstSpawn:Boolean;
		private var cameraInit:Boolean;
		
		private var autorActor:Actor;
		private var broadcastTimer:Timer;
		public var shiftKeyPressed:Boolean;
		
		public function ActingScene()
		{
			isFirstSpawn = true;
			cameraInit = true;
			
			background = new Background(this);
			networkManager = NetworkManager.getInstance();
			actingContainer = new MovieClip();
			
			this.camera = new Camera(this);
			
			container = new CameraContainer(this);
			container.addChild(background.backgroundImg);
			
			container.addChild(actingContainer);
			container.addChild(camera);
			container.addChild(background.foregroundImg);
			/*greenSceneCrosshair.graphics.lineStyle(1, 0x00FF00);
			   greenSceneCrosshair.graphics.moveTo(-10, 0);
			   greenSceneCrosshair.graphics.lineTo(10, 0);
			   greenSceneCrosshair.graphics.moveTo(0, -10);
			   greenSceneCrosshair.graphics.lineTo(0, 10);
			   greenSceneCrosshair.x = this.x;
			   greenSceneCrosshair.y = this.y;
			
			   redContainerCrosshair.graphics.lineStyle(1, 0xFF0000);
			   redContainerCrosshair.graphics.moveTo(-10, 0);
			   redContainerCrosshair.graphics.lineTo(10, 0);
			   redContainerCrosshair.graphics.moveTo(0, -10);
			   redContainerCrosshair.graphics.lineTo(0, 10);
			   redContainerCrosshair.x = container.x;
			 redContainerCrosshair.y = container.y;*/
			
			this.addChild(container);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			actors = new Object();
			
			currentSelection = null;
			
			actorListSO = SharedObject.getRemote("actorList", networkManager.nc.uri);
			actorListSO.addEventListener(SyncEvent.SYNC, actorListSync);
			actorListSO.connect(networkManager.nc);
			
			propertiesSO = SharedObject.getRemote("properties", networkManager.nc.uri);
			propertiesSO.addEventListener(SyncEvent.SYNC, propertiesSync);
			propertiesSO.connect(networkManager.nc);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		/*broadcastTimer = new Timer(50, 0);
		   broadcastTimer.addEventListener(TimerEvent.TIMER, broadcastData);
		 broadcastTimer.start;*/
		}
		
		public function init(e:Event):void
		{
			if (networkManager.connectionType == NetworkManager.CONNECTION_TYPE_SERVER)
			{
				this.stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightMouseClick);
			 
				this.addChild(redContainerCrosshair);
				this.stage.addChild(greenSceneCrosshair);
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEventHandler);
				this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
				
				selectionSprite = new Sprite();
				selectionSprite.graphics.lineStyle(2, 0x00DD00);
				selectionSprite.graphics.moveTo(60, 0);
				selectionSprite.graphics.lineTo(-60, 0);
				selectionSprite.graphics.lineTo(-10, 40);
				selectionSprite.graphics.lineTo(100, 40);
				selectionSprite.graphics.lineTo(60, 0);
				selectionSprite.x -= 20;
				selectionSprite.y += 20;
			}
		}
		
		public function propertiesSync(e:SyncEvent):void
		{
			for (var i:Object in e.changeList)
			{
				var changeObj:Object = e.changeList[i];
				
				switch (changeObj.code)
				{
					case "sucess": 
						break;
					case "change": 
						switch (changeObj.name)
					{
						case "current": 
							changeCurrentSelection(actors[propertiesSO.data.current.id], propertiesSO.data.current.center, false);
							if (propertiesSO.data.current.center)
							{
								propertiesSO.data.currentzoom.iszoom = true;
							}
							break;
						case "currentzoom": 
							if (!cameraInit)
							{
								if (propertiesSO.data.currentzoom.iszoom)
								{
									camera.zoom(currentSelection.x, currentSelection.y);
								}
								else
								{
									camera.unzoom(currentSelection.x, currentSelection.y);
								}
							}
							else
							{
								if (propertiesSO.data.currentzoom.iszoom)
								{
									try
									{
										camera.initZoom(currentSelection.x, currentSelection.y);
									}
									catch (e:Error)
									{
										trace("No se pudo hacer zoom a la camarangangan");
									}
								}
								cameraInit = false;
							}
							break;
						case "zdef": 
							if (!cameraInit)
								camera.zoomToDefault();
							break;
						case "skill": 
							var actor:Actor = actors[propertiesSO.data.skill.id];
							if (actor != null)
							{
								actor.shutSkills();
								
								if (actor.skills[propertiesSO.data.skill.skillname].isMouthSkill)
								{
									actor.shut();
									actor.mouthState = Actor.STATE_TALKING;
								}
								
								actor.skills[propertiesSO.data.skill.skillname].isSet = propertiesSO.data.skill.isSet;
							}
							
							break
						case "orientation": 
							actors[propertiesSO.data.orientation.id].setOrientation(propertiesSO.data.orientation.orientation);
							break
						case "deleteActor": 
							if (actors[propertiesSO.data.deleteActor.id] != null)
								actors[propertiesSO.data.deleteActor.id].exitScene("left");
							break
						case "speed": 
							if (actors[propertiesSO.data.speed.id] != null)
								actors[propertiesSO.data.speed.id].mouseSpeed = propertiesSO.data.speed.s;
							break
						case "tween": 
							if (actors[propertiesSO.data.tween.id] != null)
								actors[propertiesSO.data.tween.id].tweenToPoint(new Point(propertiesSO.data.tween.x, propertiesSO.data.tween.y), "Back.inOut", 0.5);		
							break
					}
				
				}
				
			}
		
		}
		
		public function actorListSync(e:SyncEvent):void
		{
			
			for (var i:Object in e.changeList)
			{
				var changeObj:Object = e.changeList[i];
				
				switch (changeObj.code)
				{
					case "sucess": 
						break;
					case "change": 
						var actorId:String = changeObj.name;
						var data:Object = actorListSO.data[actorId];
						var mousePoint:Point = new Point(data.x, data.y);
						if (actors[actorId] == null)
						{
							var type:Class = getDefinitionByName("com.avlivef." + data.type) as Class;
							var newActor:MovieClip = new type(this, actorId);
							newActor.setOrientation(data.o, false);
							
							actingContainer.addChild(newActor);
							actors[newActor.id] = newActor;
							if (isFirstSpawn)
							{
								newActor.setMousePosition(mousePoint);
								newActor.x = data.x;
								newActor.y = data.y;
							}
						}
						else
						{
							actors[actorId].setMousePosition(mousePoint);
							if (actors[actorId].currentOrientation != data.o)
							{
								actors[actorId].setOrientation(data.o, true);
							}
							camera.offsetZoomRegistrationPoint(mousePoint.x, mousePoint.y);
						}
						break;
				}
			}
			isFirstSpawn = false;
		}
		
		public function setGui(gui:Gui):void
		{
			this.gui = gui;
		}
		
		public function createActor(className:String):void
		{
			var type:Class = getDefinitionByName("com.avlivef." + className) as Class;
			
			var newActor:MovieClip = new type(this, null);
			/*newActor.x = background.width;
			 newActor.y = background.height * 0.5;*/
			actingContainer.addChild(newActor);
			actors[newActor.id] = newActor;
			
			actorListSO.setProperty(newActor.id, {x: newActor.mousePosition.x, y: newActor.mousePosition.y, type: className, o: newActor.currentOrientation, ms: null});
		}
		
		public function changeCurrentSelection(actor:Actor, center:Boolean, server:Boolean):void
		{
			if (currentSelection != null)
			{
				currentSelection.detach();
			}
			currentSelection = actor;
			
			camera.offsetZoomRegistrationPoint(currentSelection.x, currentSelection.y);
			
			if (center)
			{
				camera.center(currentSelection.x, currentSelection.y);
				propertiesSO.setProperty("currentzoom", {iszoom: camera.isZoomed});
			}
			
			if (server)
			{
				gui.changeCurrentSelection(currentSelection);
				propertiesSO.setProperty("current", {id: currentSelection.id, center: center});
				currentSelection.addChildAt(selectionSprite, 0);
			}
		}
		
		public var r:uint;
		
		public function broadcastSkill(id:String, skillname:String, isSet:Boolean):void
		{
			propertiesSO.setProperty("skill", {id: id, skillname: skillname, isSet: isSet, r: r++});
			if (r > 100)
				r = 0;
		}
		
		public function onRightMouseClick(e:MouseEvent):void
		{
			if (currentSelection != null)
			{
				var mousePoint:Point = new Point(((e.stageX - this.x) / scaleX) - this.container.x, ((e.stageY - this.y) / scaleY) - this.container.y);
				
				if (!shiftKeyPressed) {
						currentSelection.setMousePosition(mousePoint);						
				}
			
				else if(currentSelection.state != Actor.STATE_WALKING_TWEEN)
				{
						currentSelection.tweenToPoint(mousePoint, "Back.inOut", 0.5);		
						propertiesSO.setProperty("tween", { id:currentSelection.id, x:mousePoint.x, y:mousePoint.y } );
				}
				actorListSO.setProperty(currentSelection.id, { x: mousePoint.x, y: mousePoint.y, type: currentSelection.actorName, o: currentSelection.currentOrientation } );
	
				camera.offsetZoomRegistrationPoint(mousePoint.x, mousePoint.y);		
				
				if (camera.isFollow)
				{
					camera.moveTo(mousePoint.x, mousePoint.y);
				}
			}
		}
 
		public function talk(micVolume:Number):void
		{
			
			if (currentSelection != null)
			{
				
				if (micVolume > 20)
				{
					currentSelection.talk();
				}
				else
				{
					
					currentSelection.shut();
				}
			}
		}
		
		public function zSorting():void
		{
			var actorsArray:Array = new Array();
			
			var j:uint = 0;
			for (var id:String in actors)
			{
				actorsArray[j] = actors[id];
				j++;
			}
			actorsArray.sortOn("y", Array.NUMERIC);
			
			for (var i:uint = 0; i < actorsArray.length; i++)
			{
				if (actingContainer.getChildIndex(actorsArray[i]) != i)
				{
					actingContainer.setChildIndex(actorsArray[i], i);
				}
			}
		}
		
		public function onEnterFrame(e:Event):void
		{
			/*	redContainerCrosshair.x = this.container.x;
			   redContainerCrosshair.y = this.container.y;
			
			   greenSceneCrosshair.x = this.x;
			 greenSceneCrosshair.y = this.y;*/
			
			zSorting();
		}
		
		private function onKeyEventHandler(e:KeyboardEvent):void
		{
			if (currentSelection != null)
			{
				currentSelection.onKeyDownHandler(e);
				
				switch (e.keyCode)
				{
					case Keyboard.W: 
						currentSelection.setOrientation(Actor.ORIENTATION_BACK, true);
						//propertiesSO.setProperty("orientation", {id: currentSelection.id, orientation: currentSelection.currentOrientation});
						actorListSO.setProperty(currentSelection.id, {x: currentSelection.mousePosition.x, y: currentSelection.mousePosition.y, type: currentSelection.actorName, o: currentSelection.currentOrientation, ms: currentSelection.mouseSpeed});
						break;
					case Keyboard.A: 
						currentSelection.setOrientation(Actor.ORIENTATION_LEFT, true);
						actorListSO.setProperty(currentSelection.id, {x: currentSelection.mousePosition.x, y: currentSelection.mousePosition.y, type: currentSelection.actorName, o: currentSelection.currentOrientation, ms: currentSelection.mouseSpeed});
						break;
					case Keyboard.S: 
						currentSelection.setOrientation(Actor.ORIENTATION_FRONT, true);
						actorListSO.setProperty(currentSelection.id, {x: currentSelection.mousePosition.x, y: currentSelection.mousePosition.y, type: currentSelection.actorName, o: currentSelection.currentOrientation, ms: currentSelection.mouseSpeed});
						break;
					case Keyboard.D: 
						currentSelection.setOrientation(Actor.ORIENTATION_RIGHT, true);
						actorListSO.setProperty(currentSelection.id, {x: currentSelection.mousePosition.x, y: currentSelection.mousePosition.y, type: currentSelection.actorName, o: currentSelection.currentOrientation, ms: currentSelection.mouseSpeed});
						break;
					case Keyboard.Z: 
						//camera.offsetZoomRegistrationPoint(currentSelection.x,currentSelection.y);
						camera.zoom(currentSelection.x, currentSelection.y);
						propertiesSO.setProperty("currentzoom", {iszoom: camera.isZoomed});
						break;
					case Keyboard.C: 
						//camera.offsetZoomRegistrationPoint(currentSelection.x,currentSelection.y);
						camera.center(currentSelection.x, currentSelection.y);
						camera.isZoomed = true;
						propertiesSO.setProperty("currentzoom", {iszoom: camera.isZoomed});
						break;
					case Keyboard.SHIFT: 
						shiftKeyPressed = true;
						break;
				}
			}
		}
		
		private function onKeyUpHandler(e:KeyboardEvent):void
		{
			if (currentSelection != null)
				currentSelection.onKeyUpHandler(e);
			switch (e.keyCode)
			{
				case Keyboard.DELETE: 
					try
					{
						deleteActor(currentSelection)
					}
					catch (e:Error)
					{
						return;
						trace(e.errorID);
					}
					break;
				case Keyboard.SHIFT: 
					shiftKeyPressed = false;
					break
			}
		
		}
		
		public function deleteActor(a:Actor):void
		{
			a.exitScene("left");
			currentSelection = null;
			
			if (networkManager.connectionType == NetworkManager.CONNECTION_TYPE_SERVER)
			{
				propertiesSO.setProperty("deleteActor", {id: a.id});
				networkManager.nc.call("removeActorFromListSO", null, a.id);
			}
		
		}
		
		public function removeChildFromContainer(a:Actor):void
		{
			actingContainer.removeChild(a);
			delete actors[a.id];
		}
		
		public var i:uint = 0;
		
		public function zoomToDefault():void
		{
			camera.zoomToDefault();
			propertiesSO.setProperty("zdef", {i: i++});
		}
		
		public function changeMouseSpeed(speed:Number):void
		{
			try
			{
				currentSelection.mouseSpeed = speed;
				propertiesSO.setProperty("speed", {id: currentSelection.id, s: speed});
			}
			catch (e:Error)
			{
				return;
			}
		}
	
	}

}