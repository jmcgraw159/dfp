package com.jeremymcgraw.reusable.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class SliderManager extends EventDispatcher
	{	
		protected var _track:Sprite;
		protected var _handle:Sprite;
		private var _lastX:Number;
		
		public function SliderManager()
		{
			
		}
		
		public function setUpAssets(track:Sprite, handle:Sprite):void
		{
			_track = track;
			_handle = handle;
			
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{	
			var rectangle:Rectangle = new Rectangle(0, 0, _track.width - _handle.width, 0);
			_handle.startDrag(false, rectangle);
			
			_handle.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_handle.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(_handle.x != _lastX) {
				
				// Announce that the pct value has changed
				
				// Dispatching an event
				// The class dispatching the evetns need to have extended the EventDispatcher class
				
				// Create the event object
				var e:Event = new Event(Event.CHANGE);
				
				// Dispatch the event
				dispatchEvent(e);
				
				// _oldPct = newPct;
				_lastX = _handle.x;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			_handle.stopDrag();
			
			_handle.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function get pct():Number
		{
			var pct:Number = _handle.x / (_track.width - _handle.width);
			return pct;
		}
		
		public function set pct(value:Number):void
		{
			_handle.x = (_track.width - _handle.width) * value;
			_lastX = _handle.x;
		}
	}
}