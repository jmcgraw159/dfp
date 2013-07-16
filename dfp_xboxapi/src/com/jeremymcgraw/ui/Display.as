package com.jeremymcgraw.ui
{	
	import com.jeremymcgraw.reusable.ui.LayoutBox;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import libs.SearchField;
	
	public class Display extends SearchField
	{
		private var _urlAvatar:String;
		private var _urlActivity:String;
		private var _ld:Loader;
		private var _lbF:LayoutBox;
		private var _gamesArray:Array;
		private var _friendsArray:Array;
		private var _counter:Number = 0;
		private var _canvas:Sprite;

		private var _img:Bitmap;

		public function Display()
		{
			super();
			
			_lbF = new LayoutBox(10);
			addChild(_lbF);
			_lbF.x = 630;
			_lbF.y = 140;
			
			_canvas = new Sprite();
			addChild(_canvas);
		}
		
		public function loadAvatar():void
		{
			_ld = new Loader();
			_ld.load(new URLRequest(_urlAvatar));
			_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadAvatar);
		}
		
		public function loadActivity():void
		{
			for each(var img:String in _gamesArray) {
				_ld = new Loader();
				_ld.load(new URLRequest(img));
				_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadActivity);
			}
			
			_ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function onError(event:IOErrorEvent):void
		{
			trace("IO Error");
			this.removeActivity();
			this.removeFriends();
			this.removeImg();
			_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadActivity);
			_ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onloadFriends);
			this.gotoAndStop(3);
		}
		
		public function loadFriends():void
		{
			for each(var f:String in _friendsArray) {
				
				_ld = new Loader();
				_ld.load(new URLRequest(f));
				_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadFriends);
			}
		}
		
		private function onloadFriends(event:Event):void
		{	
				var img:Bitmap = event.currentTarget.content;
				_lbF.addChild(img);
		}
		
		public function onLoadActivity(event:Event):void
		{	
			_counter++;
			
			var img:Bitmap = event.currentTarget.content;
			_canvas.addChild(img);
			img.x = 410;
			img.y = 140;
			
			if(_counter > 4) {
				removeChild(img);
			}else if(_counter == 2) {
				img.x = 520;
			}else if(_counter == 3) {
				img.y = 270;
			}else if(_counter == 4) {
				img.x = 520;
				img.y = 270;
				_counter = 0;
			}
		}
		
		private function onLoadAvatar(event:Event):void
		{
			_img = event.currentTarget.content;
			
			if(screen.numChildren) {
				screen.removeChildAt(0);
			}
			
			_img.y = -50;
			screen.addChild(_img);
			screen.cacheAsBitmap = true;
			_img.cacheAsBitmap = true;
		}
		
		public function removeImg():void
		{
			if(screen.numChildren) {
				screen.removeChildAt(0);
			}
		}
		
		public function removeActivity():void
		{
			trace("Remove Activity");
				if(_canvas.numChildren > 0) {
					removeChild(_canvas);
				}
				
				_canvas = new Sprite();
				addChild(_canvas);
		}
		
		public function removeFriends():void
		{	
			trace("Remove Friends");
			if(_lbF.numChildren > 0) {
				removeChild(_lbF);
			}
			
			_lbF = new LayoutBox(10);
			addChild(_lbF);
			_lbF.x = 630;
			_lbF.y = 140;
		}

		public function set urlAvatar(value:String):void
		{
			_urlAvatar = value;
		}

		public function set urlActivity(value:String):void
		{
			_urlActivity = value;
		}

		public function set gamesArray(value:Array):void
		{
			_gamesArray = value;
		}

		public function set friendsArray(value:Array):void
		{
			_friendsArray = value;
		}
	}
}