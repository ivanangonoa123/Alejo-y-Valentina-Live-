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
	public class AudioStreamManager extends Sprite
	{
		public var mic:Microphone;
		public var ns:NetStream;
		private var networkManager:NetworkManager;
		
		private var micVolumeSO:SharedObject;
		private var actingScene:ActingScene;
		
		public function AudioStreamManager(actingScene:ActingScene)
		
		{
			this.actingScene = actingScene;
			networkManager = NetworkManager.getInstance();
						
			if (Microphone.getEnhancedMicrophone()) setEnhancedMic();
			else setStandardMic();
 
			//mic.setLoopBack(false);
			
			if(mic!=null){
			
			ns = new NetStream(networkManager.nc);
			ns.attachAudio(mic);
			ns.publish("audio", "live");
	 
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			micVolumeSO = SharedObject.getRemote("micVol", networkManager.nc.uri);
			micVolumeSO.connect(networkManager.nc);
			 
			}
		}
		
				
		private function setEnhancedMic():void {
			mic = Microphone.getEnhancedMicrophone();
			
			var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			options.echoPath = 128;
			
			mic.enhancedOptions = options;
			mic.codec = SoundCodec.SPEEX;
			mic.encodeQuality = 10;
		}
		
		private function setStandardMic():void {
			mic = Microphone.getMicrophone();
			
		}
		
		private function onEnterFrame(e:Event):void
		{
			actingScene.talk(mic.activityLevel);
			micVolumeSO.setProperty("volume", {v: mic.activityLevel});
		}
	
	}

}