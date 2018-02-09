package com.avlivef
{
	import com.net.NetworkManager;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author klanco
	 * Guido Kafka: SSSSSSSSSSSSSSSSSSSSSHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!!!!!!!!
	 */
	
	[SWF(width="1280",height="800",backgroundColor="#DDDDDD")]
	[Frame(factoryClass="com.avlivef.Preloader")]
	public class Main extends Sprite
	{
		private var actingScreen:ActingScreen;
		private var clientActingScreen:ClientActingScreen;
		private var connectionSreen:ConnectionScreen;
		private var networkManager:NetworkManager;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point 
			
			networkManager = NetworkManager.getInstance();
			connectionSreen = new ConnectionScreen();
			this.addChild(connectionSreen);
			connectionSreen.addEventListener("ready", connectedHandler);
			connectionSreen.addEventListener("offlineMode", offlineModeHandler);
		}
		
		private function offlineModeHandler(e:Event):void
		{
			networkManager.connectionType = NetworkManager.CONNECTION_TYPE_SERVER;
			networkManager.offlineMode = true;
			initGame();
		}
		
		private function connectedHandler(e:Event):void
		{
			connectionSreen.removeEventListener("ready", connectedHandler);
			this.removeChild(connectionSreen);
			initGame();
		}
		
		private function initGame():void
		{
			if (networkManager.connectionType == NetworkManager.CONNECTION_TYPE_CLIENT)
			{
				clientActingScreen = new ClientActingScreen();
				this.addChild(clientActingScreen);
			}
			else
			{
				actingScreen = new ActingScreen();
				this.addChild(actingScreen);
			}
		}
	}

}