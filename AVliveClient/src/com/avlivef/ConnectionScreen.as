package com.avlivef
{
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import com.net.NetworkManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.RadioButton;
	import com.bit101.components.VSlider;
	import com.bit101.components.Window;
	import com.bit101.components.PushButton;
	import com.greensock.TweenLite;
	import Intro_mc;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class ConnectionScreen extends Sprite
	{
		private var introBackground:MovieClip;
		private var connectButton:PushButton;
		private var networkManager:NetworkManager;
		
		private var urlLbl:Label;
		private var connectionURL:InputText;
		private var displayLbl:Label;
		private var serverChkBox:CheckBox;
		private var offlineModeChkBox:CheckBox;
		private var connectBtn:PushButton;
		private var infoBtn:PushButton;
		private var centerPanel:Panel;
		private var infoWindow:Window;
		
		public function ConnectionScreen()
		{
			introBackground = new Intro_mc();
			TweenLite.to(introBackground.getChildByName("nube"), 200, {x: -200});
			this.addChild(introBackground);
			networkManager = NetworkManager.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			centerPanel = new Panel(this, 0, 0);
			centerPanel.setSize(stage.stageWidth / 2, stage.stageHeight / 2);
			centerPanel.x = stage.stageWidth / 2 - centerPanel.width / 2;
			centerPanel.y = stage.stageHeight / 2 - centerPanel.height / 2;
			centerPanel.alpha = 0.8;
			
			infoWindow = new Window(this, 0, 0, "Info")
			infoWindow.setSize(stage.stageWidth / 2, stage.stageHeight / 2);
			infoWindow.x = stage.stageWidth / 2 - centerPanel.width / 2;
			infoWindow.y = stage.stageHeight / 2 - centerPanel.height / 2;
			infoWindow.alpha = 1;
			infoWindow.visible = false;
			
			var closeBtn:PushButton = new PushButton(infoWindow, infoWindow.width / 2 - 50, infoWindow.height - 20, "Volver", onCloseBtnClick);
			closeBtn.x = infoWindow.width  -120 - closeBtn.width / 2;
			closeBtn.y = infoWindow.height / 3;
			
			var infoText:TextArea = new TextArea(infoWindow, 0, 0, "Esto es un experimento no oficial hecho con los personajes del show Alejo y Valentina realizado por El Loco (LocoArts).\n No se obtuvo un mango con esta producción. \n Aplicación realizada por Boris Angonoa (angonoa_boris@live.com.ar). 2014");
			infoText.scaleX = infoText.scaleY = 2;
			infoText.width = 200;
 			infoText.x = 20;
			infoText.y = infoWindow.height / 4 - infoText.height / 2;
			
			urlLbl = new Label(centerPanel, 170, 100, "URL");
			
			connectionURL = new InputText(centerPanel, 210, 100, "rtmp://192.168.0.104/Red5servTest");
			connectionURL.width = 200;
			
			displayLbl = new Label(centerPanel, 240, 240, "");
			
			serverChkBox = new CheckBox(centerPanel, 260, 140, "Server");
			offlineModeChkBox = new CheckBox(centerPanel, 260, 160, "Offline");
			
			connectBtn = new PushButton(centerPanel, 240, 190, "Conectar", connectBtnClick);
			
			networkManager.addEventListener("connected", readyHandler);
			networkManager.addEventListener("connectionFail", connectionFailHandler);
			
			infoBtn = new PushButton(centerPanel, 240, 220, "Info", onInfoBtnClick);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}
		
		private function onInfoBtnClick(e:Event):void
		{
			centerPanel.visible = false;
			infoWindow.visible = true;
		}
		
		private function onCloseBtnClick(e:Event):void
		{
			centerPanel.visible = true;
			infoWindow.visible = false;
		}
		
		private function onKeyboardDown(e:KeyboardEvent):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			switch (e.keyCode)
			{
				case Keyboard.S: 
					networkManager.connectionType = NetworkManager.CONNECTION_TYPE_SERVER
					networkManager.connect(connectionURL.text);
					break;
				case Keyboard.C: 
					networkManager.connectionType = NetworkManager.CONNECTION_TYPE_CLIENT
					networkManager.connect(connectionURL.text);
					break;
			}
		}
		
		private function connectBtnClick(e:Event):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			if (serverChkBox.selected)
			{
				networkManager.connectionType = NetworkManager.CONNECTION_TYPE_SERVER
			}
			if (!offlineModeChkBox.selected)
			{
				networkManager.connect(connectionURL.text);
				displayLbl.text = "Conectando";
			}
			else
			{
				this.dispatchEvent(new Event("offlineMode"));
			}
		
		}
		
		private function readyHandler(e:Event):void
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			networkManager.removeEventListener("connected", readyHandler);
			this.dispatchEvent(new Event("ready"));
		}
		
		private function connectionFailHandler(e:Event):void
		{
			displayLbl.text = "Fallo la conexión";
		}
	
	}

}