package com.jeremymcgraw.reusable.ui
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SmootherSliderManager extends SliderManager
	{
		public function SmootherSliderManager()
		{
			super();
		}
		
		override protected function onMouseDown(event:MouseEvent):void
		{
			_handle.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_handle.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		override protected function onMouseUp(event:MouseEvent):void
		{
			_handle.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_handle.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{	
			// left boundry = 0
			// right boundry = _track.width - _handle.width
			_handle.x = Math.min(Math.max(_track.mouseX, 0), _track.width - _handle.width);
			
			event.updateAfterEvent();
		}
	}
}