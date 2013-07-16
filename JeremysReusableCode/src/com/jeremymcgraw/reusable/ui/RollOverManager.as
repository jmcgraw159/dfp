package com.jeremymcgraw.reusable.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class RollOverManager
	{		
		private var _mc:MovieClip;
		private var _direction:int = 1;
		
		public function RollOverManager(objectToApplyRollOverCodeTo:MovieClip)
		{
			_mc = objectToApplyRollOverCodeTo;
			
			_mc.stop();
			
			_mc.addEventListener(MouseEvent.ROLL_OVER, onHover)
			_mc.addEventListener(MouseEvent.ROLL_OUT, onLeave);
		}
		
		private function onLeave(event:MouseEvent):void
		{
			_direction = -1;
		}
		
		private function onHover(event:MouseEvent):void
		{	
			_direction = 1;
			
			_mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			_mc.gotoAndStop(_mc.currentFrame + _direction);
			
			if(_mc.currentFrame == 1) {
				_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
	}
}