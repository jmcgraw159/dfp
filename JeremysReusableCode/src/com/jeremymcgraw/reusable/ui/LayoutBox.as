package com.jeremymcgraw.reusable.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class LayoutBox extends Sprite
	{	
		private var _children:Array;
		private var _padding:Number;
		private var _isHorizontal:Boolean;
		
		public function LayoutBox(padding:Number = 5, isHorizontal:Boolean = false)
		{
			super();
			
			_padding = padding;
			_isHorizontal = isHorizontal;
			_children = [];
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{	
			_children.push(child);
			updatePosition();
			return super.addChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			_children = [];
			return super.removeChildAt(index);
		}
		
		private function updatePosition():void
		{
			var pos:Number = 0;
			
			for each(var child:DisplayObject in _children) {
				
				if(_isHorizontal) {
					child.x = pos;
					child.y = 0;
					pos += child.width + _padding;
				}else {
					child.x = 0;
					child.y = pos;
					pos += child.height + _padding;
				}
			}
		}

		public function get padding():Number
		{
			return _padding;
		}

		public function set padding(value:Number):void
		{
			_padding = value;
			updatePosition();
		}

		public function get isHorizontal():Boolean
		{
			return _isHorizontal;
		}

		public function set isHorizontal(value:Boolean):void
		{
			_isHorizontal = value;
			updatePosition();
		}
	}
}