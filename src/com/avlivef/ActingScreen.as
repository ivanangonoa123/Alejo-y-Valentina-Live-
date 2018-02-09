package com.avlivef
{
	import com.net.AudioStreamManager;
	import com.net.NetworkManager;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class ActingScreen extends Sprite
	{
		private var gui:Gui;
		private var actingScene:ActingScene;
		
		private var audioStreamManager:AudioStreamManager;
		private var audioManager:AudioManager;

		
		public function ActingScreen()
		{
			audioManager = AudioManager.getInstance();
	 
			actingScene = new ActingScene();
			audioStreamManager = new AudioStreamManager(actingScene);
			gui = new Gui(actingScene, audioStreamManager);
			actingScene.setGui(gui);
			
			this.addChild(actingScene);
			this.addChild(gui);
		}
	
	}

}