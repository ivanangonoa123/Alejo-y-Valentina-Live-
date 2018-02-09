package com.net 
{
	import com.avlivef.Main;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.net.AVNetConnection;
	import flash.events.NetStatusEvent;
	/**
	 * ...
	 * @author klanco
	 */
	public class NetworkManager extends Sprite
	{
		public static const CONNECTION_TYPE_SERVER:uint = 0;
		public static const CONNECTION_TYPE_CLIENT:uint = 1;
		
		public var connectionType:uint;
		public var nc:AVNetConnection;
	
		public var offlineMode:Boolean;
		
		private static var _instance:NetworkManager=null;
	
		public var url:String;
		public var users:uint;
				
		public function NetworkManager(e:SingletonEnforcer) 
		{
			connectionType = CONNECTION_TYPE_CLIENT;
			nc = new AVNetConnection();	
			offlineMode = false;
		}
		
		public static function getInstance():NetworkManager {
			if (_instance == null) {
				_instance = new NetworkManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function connect(url:String):void
		{
			this.url = url;
			nc.client = this;
			nc.connect(url);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);		
		}
	
		public function onConnectionNetStatus(event:NetStatusEvent):void
		{
			trace ("NetStatusHandler: " + event.info.code );
			// did we successfully connect
			if (event.info.code == "NetConnection.Connect.Success")
			{
				trace("Successful Connection", "Information");
				this.dispatchEvent(new Event("connected"));
			}
			else
			{
				trace("Unsuccessful Connection", "Information");				
				this.dispatchEvent(new Event("connectionFail"));
			}
		}
		
				
		public function onBWDone(... rest):void
		{
			var p_bw:Number;
			if (rest.length > 0)
			{
				p_bw = rest[0];
			}
			trace("bandwidth = " + p_bw + " Kbps.");
		}
		
		public function onBWCheck(... rest):Number
		{
			return 0;
		}
		
		public function newUser(o:int):void {
			users = o;
			this.dispatchEvent(new Event("userAdded"));
		}
	}

}
class SingletonEnforcer{
//nothing else required here
}
