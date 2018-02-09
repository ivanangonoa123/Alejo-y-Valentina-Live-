package com.avlivef
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author klanco
	 */
	
	public class AudioManager
	{
		
		[Embed(source="/../assets/sounds/step.mp3")]
		private const StepSound:Class;
		
		[Embed(source="/../assets/sounds/puerta.mp3")]
		private const DoorSound:Class;
		
		
		private static var _instance:AudioManager = null;
		
		public var stepSound:Sound;
		public var doorSound:Sound;
		public var soundChannel:SoundChannel;
	 
		public function AudioManager(e:SingletonEnforcer)
		{
			soundChannel = new SoundChannel();
	 
			stepSound = (new StepSound) as Sound;
			doorSound = (new DoorSound) as Sound;
		}
		
		public function playSound(sound:Sound , isLoop:Boolean):SoundChannel
		{			 
			if(isLoop)
			return sound.play(0, 9999);
			else
			return sound.play(0, 0);
		}
		
		public  function stopSound(soundChannel:SoundChannel ):void
		{			 
			soundChannel.stop();
		}
		
		public static function getInstance():AudioManager
		{
			if (_instance == null)
			{
				_instance = new AudioManager(new SingletonEnforcer());
			}
			return _instance;
		}
	
	}
}

class SingletonEnforcer
{
}