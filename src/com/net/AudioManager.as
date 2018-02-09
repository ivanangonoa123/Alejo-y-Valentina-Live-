package com.net
{
	import com.avlivef.ActingScene;
	import flash.display.Sprite;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.SoundCodec;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class AudioManager extends Sprite
	{
		public var mic:Microphone;
		public var ns:NetStream;
		private var networkManager:NetworkManager;
		
		private var micVolumeSO:SharedObject;
		private var actingScene:ActingScene;
		
		public function AudioManager(actingScene:ActingScene)
		
		{
			this.actingScene = actingScene;
			networkManager = NetworkManager.getInstance();
			var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			options.echoPath = 128;
			options.nonLinearProcessing = true;
			
			mic = Microphone.getEnhancedMicrophone();
			mic.enhancedOptions = options;
			mic.codec = SoundCodec.SPEEX;
			mic.encodeQuality = 10;
			
			mic.setLoopBack(false);
			
			ns = new NetStream(networkManager.nc);
			ns.attachAudio(mic);
			ns.publish("audioz", "live");
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			micVolumeSO = SharedObject.getRemote("micVol", networkManager.nc.uri);
			micVolumeSO.connect(networkManager.nc);
		}
		
		private function onEnterFrame(e:Event):void
		{
			actingScene.talk(mic.activityLevel);
			micVolumeSO.setProperty("volume", {v: mic.activityLevel});
		}
	
	}

}