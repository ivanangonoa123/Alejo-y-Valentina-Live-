package com.avlivef
{
	import com.net.NetworkManager;
	import flash.display.Sprite;
	import flash.media.SoundTransform;
	import flash.media.SoundCodec;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author klanco
	 */
	public class ClientActingScreen extends Sprite
	{
		private var actingScene:ActingScene;
		private var recvStream:NetStream;
		private var recvSoundTransform:SoundTransform;
		private var networkManager:NetworkManager;
		
		private var micVolumeSO:SharedObject;
		
		public function ClientActingScreen()
		{
			actingScene = new ActingScene();
			this.addChild(actingScene);
			
			networkManager = NetworkManager.getInstance();
			recvStream = new NetStream(networkManager.nc);
			recvStream.addEventListener(NetStatusEvent.NET_STATUS, netStreamHandler);
			recvStream.play("audioz");
			//TODO ORGANIZAR STREAMS CON ALGO QUE SE YO
			//TODO TRANSFORMAR SONIDO CON SOUNDTRANSFORM
			
			micVolumeSO = SharedObject.getRemote("micVol", networkManager.nc.uri);
			micVolumeSO.connect(networkManager.nc);
			micVolumeSO.addEventListener(SyncEvent.SYNC, micVolumeSync);
		
		}
		
		public function micVolumeSync(e:SyncEvent):void
		{
			if(micVolumeSO.data.volume != null){
			micVolumeSO.removeEventListener(SyncEvent.SYNC, micVolumeSync);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void
		{
			actingScene.talk(micVolumeSO.data.volume.v);
		}
		
		private function netStreamHandler(e:NetStatusEvent):void
		{
			return;
		}
	
	}

}