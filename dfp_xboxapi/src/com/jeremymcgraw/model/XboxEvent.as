package com.jeremymcgraw.model
{
	import flash.events.Event;
	
	public class XboxEvent extends Event
	{	
		public static const PHOTOS_LOADED:String = "photoLoaded";
		public var photoArray:Array;
		public var fArray:Array;
		
		public function XboxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}