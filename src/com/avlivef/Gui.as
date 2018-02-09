package com.avlivef
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Slider;
	import com.bit101.components.VSlider;
	import com.bit101.components.Window;
	import com.bit101.components.HUISlider;
	import com.net.AudioStreamManager;
	import com.net.NetworkManager;
	import flash.geom.Point;
	
	import flash.display.Sprite;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class Gui extends Sprite
	{
		private var actingScene:ActingScene
		private var audioStreamManager:AudioStreamManager;
		private var networkManager:NetworkManager;
		
		private var actorNameLbl:Label
		public var actorSelectionWindow:Window;
		public var skillSelectionWindow:Window;
		public var micWindow:Window;
		public var netWindow:Window;
		public var lowerPanel:Panel;
		public var micVolumeSlider:HUISlider;
		public var micLoopBackChk:CheckBox;
		public var ipLbl:InputText;
		public var usersLbl:Label;
		public var mouseSpeedSlider:HUISlider;
		
		public function Gui(actingScene:ActingScene, audioStreamManager:AudioStreamManager)
		{
			networkManager = NetworkManager.getInstance();
			this.actingScene = actingScene;
			this.audioStreamManager = audioStreamManager;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			
			lowerPanel = new Panel(this, 0, stage.stageHeight - stage.stageHeight / 8);
			lowerPanel.setSize(stage.stageWidth, stage.stageHeight / 8);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			actorSelectionWindow = new Window(this, 20, 20, "Personajes");
			actorSelectionWindow.setSize(120, 150);
			actorSelectionWindow.hasMinimizeButton = true;
			setCharWindowBtns();
			
			skillSelectionWindow = new Window(this, stage.stageWidth - 200 - 20, 20, "Skills");
			skillSelectionWindow.setSize(180, 200);
			
			micWindow = new Window(this, 20, 300, "Mic");
			micWindow.hasMinimizeButton = true;
			micWindow.setSize(200, 60);
			micLoopBackChk = new CheckBox(micWindow, 10, 10, "Escuchar Mic: ", onMicLoopBackChecked);
			micVolumeSlider = new HUISlider(micWindow, 10, 20, "Volume", onMicVolumeScroll);
			
			mouseSpeedSlider = new HUISlider(lowerPanel, lowerPanel.width * 0.5, 20, "Speed", onMouseSpeedScroll);
			mouseSpeedSlider.scaleX = mouseSpeedSlider.scaleY = 1.2;
			mouseSpeedSlider.maximum = 100;
			
			netWindow = new Window(this, 20, 400, "Net Info");
			netWindow.hasMinimizeButton = true;
			netWindow.setSize(200, 100);
			ipLbl = new InputText(netWindow, 10, 10, networkManager.url);
			ipLbl.setSize(150, 20);
			usersLbl = new Label(netWindow, 10, 40, "Usuarios: 0");
			networkManager.addEventListener("userAdded", updateUserGui);
			
			for (var i:uint = 0; i < 5; i++)
			{
				var btnSize:Point = new Point(100, 20);
				var pushButton:PushButton = new PushButton(skillSelectionWindow, 0 + 5, i * btnSize.y + i * 5 + 5, "" + i, null);
				pushButton.setSize(btnSize.x, btnSize.y);
				pushButton.visible = false;
			}
			
			/*var checkBox:CheckBox = new CheckBox(panel, 20, 20);
			 checkBox.label = "Check it out!";*/
			
			actorNameLbl = new Label(lowerPanel, 20, 40);
			actorNameLbl.scaleX = actorNameLbl.scaleY = 2;
			actorNameLbl.text = "Personaje: ";
		
		/*var hSlider:HSlider = new HSlider(panel, 20, 90);
		   var vSlider:VSlider = new VSlider(panel, 130, 20);
		
		   var inputText:InputText = new InputText(panel, 20, 110);
		   inputText.text = "Input Text";
		
		   var _progressBar:ProgressBar = new ProgressBar(panel, 20, 140);
		
		   var radio1:RadioButton = new RadioButton(panel, 20, 160);
		   radio1.label = "Choice 1";
		   var radio2:RadioButton = new RadioButton(panel, 20, 180);
		   radio2.label = "Choice 2";
		   var radio3:RadioButton = new RadioButton(panel, 20, 200);
		   radio3.label = "Choice 3";
		
		   var colorchooser:ColorChooser = new ColorChooser(panel, 20, 230);
		 colorchooser.value = 0xff0000;*/
		
		/*var pButton:PushButton = new PushButton(this, 10, 20, "A button", clicked);
		
		   function clicked(e:Event):void
		   {
		   trace("button clicked");
		   }
		
		 var tArea:Text = new Text(this, 10, 70, 'Some text');*/
		
		}
		
		private function setCharWindowBtns():void
		{
			//TODO automatizar! ueueue
			var i:uint = 0;
			var alejoBtn:PushButton = new PushButton(actorSelectionWindow.content, 10, 20 * i++ + 10, "Alejo", alejoBtnClicked);
			var valentinaBtn:PushButton = new PushButton(actorSelectionWindow.content, 10, 20 * i++ + 10, "Valentina", valentinaBtnClicked);
			var carlitoxBtn:PushButton = new PushButton(actorSelectionWindow.content, 10, 20 * i++ + 10, "Carlitox", carlitoxBtnClicked);
			var viejoBtn:PushButton = new PushButton(actorSelectionWindow.content, 10, 20 * i++ + 10, "Viejo", viejoBtnClicked);
			var CharlesWilkinsonBtn:PushButton = new PushButton(actorSelectionWindow.content, 10, 20 * i++ + 10, "C.Wilkinson", CharlesWilkinsonBtnClicked);
		}
		
		private function viejoBtnClicked(e:Event):void
		{
			actingScene.createActor("Viejo");
		}
		
		private function CharlesWilkinsonBtnClicked(e:Event):void
		{
			trace("ehhhuuuh");
			actingScene.createActor("CharlesWilkinson");
		}
		
		private function alejoBtnClicked(e:Event):void
		{
			actingScene.createActor("Alejo");
		}
		
		private function valentinaBtnClicked(e:Event):void
		{
			actingScene.createActor("Valentina");
		}
		
		private function carlitoxBtnClicked(e:Event):void
		{
			actingScene.createActor("Carlitox");
		}
		
		public function charBtnClicked(string:String):void
		{
		
		}
		
		private function clearWindowBtns():void
		{
			for (var i:uint = 0; i < skillSelectionWindow.content.numChildren; i++)
			{
				skillSelectionWindow.content.getChildAt(i).visible = false;
			}
		}
		
		public function changeCurrentSelection(actor:Actor):void
		{
			actorNameLbl.text = "Personaje: " + actor.actorName;
			
			clearWindowBtns();
			
			var i:uint = 0;
			for (var name:String in actor.skills)
			{
				var pushButton:PushButton = skillSelectionWindow.content.getChildAt(i++) as PushButton;
				var skill:Skill = actor.skills[name];
				
				pushButton.label = String.fromCharCode(skill.keyCode) + " --> " + skill.name;
				pushButton.visible = true;
			}
			
			mouseSpeedSlider.value = actor.mouseSpeed * 100 / Actor.MAX_SPEED;
		}
		
		public function onMicVolumeScroll(e:Event):void
		{
		
			//audioManager.ns. = micVolumeSlider.value;
		}
		
		public function onMouseSpeedScroll(e:Event):void
		{
			actingScene.changeMouseSpeed(mouseSpeedSlider.value * Actor.MAX_SPEED / 100);
		}
		
		public function onMicLoopBackChecked(e:Event):void
		{
			//audioManager.mic.setLoopBack(micLoopBackChk.selected);
		}
		
		public function updateUserGui(e:Event):void
		{
			usersLbl.text = "Usuarios: " + (networkManager.users - 1);
		}
	
	}

}