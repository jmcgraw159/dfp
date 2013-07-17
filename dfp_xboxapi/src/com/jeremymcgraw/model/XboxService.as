package com.jeremymcgraw.model
{
	import com.jeremymcgraw.ui.Display;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class XboxService extends EventDispatcher
	{
		private var _ulProfile:URLLoader;
		private var _ulFriends:URLLoader;
		private var _sf:Display;
		private var _preloader:Preloader;
		private var _evt:XboxEvent;
		
		public function XboxService(searchField:Display)
		{
			super();
			_sf = searchField;
			_evt = new XboxEvent(XboxEvent.PHOTOS_LOADED);
		}
		
		public function doSearch(keyword:String):void
		{	
			var url:String ="https://xboxapi.com/xml/profile/" + keyword;
			var urlFriends:String ="https://xboxapi.com/xml/friends/" + keyword;
			
			var urlReqest:URLRequest = new URLRequest(url);
			
			var urlRequestFriends:URLRequest = new URLRequest(urlFriends);
			
			_ulFriends = new URLLoader();
			_ulFriends.addEventListener(Event.COMPLETE, onLoadFriends);
			_ulFriends.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_ulFriends.load(urlRequestFriends);
			
			_ulProfile = new URLLoader();
			_ulProfile.addEventListener(Event.COMPLETE, onLoadProfile);
			_ulProfile.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_ulProfile.load(urlReqest);
			
			_preloader = new Preloader();
			_sf.addChild(_preloader);
			_preloader.x = 405;
			_preloader.y = 180;
		}
		
		private function onError(event:IOErrorEvent):void
		{
			trace("IO Error 2");
			if(_sf.currentFrame == 1) {
				_sf.gotoAndStop(3);
			}else {
				_sf.nextFrame();
			}
		}
		
		private function onLoadFriends(event:Event):void
		{	
			_sf.removeFriends();
			
			var xmlDataF:XML = XML(_ulFriends.data);
			trace(xmlDataF.API_Limit + " API Limit");
			
			var friendArrray:Array = [];
			
			for each(var imgF:XML in xmlDataF.Friends) {
				if(imgF.IsOnline == 1 && friendArrray.length < 5) {
					friendArrray.push(imgF.GamerTileUrl);
				}
			}
			
			trace(friendArrray.length + " friend(s) online");
			
			_sf.friendsArray = friendArrray;
			
			_sf.loadFriends();
			
			_evt.fArray = friendArrray;
			dispatchEvent(_evt);
			
			if(friendArrray.length == 0) {
				_sf.removeFriends();
				_sf.tfFriends.text = "None Online";
			}else {
				_sf.tfFriends.text = "";
			}
		}
		
		private function onLoadProfile(event:Event):void
		{			
			var xmlData:XML = new XML(_ulProfile.data);
			
			trace(xmlData);
			
			if(xmlData.Error == "Invalid Gamertag") {
				trace("Error");
				_sf.removeImg();
				_sf.removeActivity();
				_sf.removeFriends();
				_ulFriends.removeEventListener(Event.COMPLETE, onLoadFriends);
				_ulProfile.removeEventListener(Event.COMPLETE, onLoadProfile);
				_sf.gotoAndStop(3);
				if(_preloader) {
					_sf.removeChild(_preloader);
				}
			}else {
			_sf.tfInput.text = xmlData.Player.Gamertag;
			if(xmlData.Player.Gamerscore == 0) {
				trace("Load Error");
				_sf.removeActivity();
				_sf.removeImg();
				_ulFriends.removeEventListener(Event.COMPLETE, onLoadFriends);
				_ulProfile.removeEventListener(Event.COMPLETE, onLoadProfile);
				_sf.gotoAndStop(3);
				_sf.removeChild(_preloader);
			}
			if(xmlData.Player.Status.Online_Status == "" || xmlData.Player.Status.Online_Status == null || !xmlData.Player.Status.Online_Status
				|| _sf.tfActivity.text == "" || _sf.tfActivity.text == null) {
				trace("Load Error - Empty String");
				_sf.removeImg();
				_ulProfile.removeEventListener(Event.COMPLETE, onLoadProfile);
				_ulFriends.removeEventListener(Event.COMPLETE, onLoadFriends);
				_sf.removeActivity();
				_sf.removeFriends();
				_sf.gotoAndStop(3);
			}	
				_sf.tfActivity.text = xmlData.Player.Status.Online_Status;
				_sf.tfGamerscore.text = xmlData.Player.Gamerscore;
				_sf.tfName.text = xmlData.Player.Name;
				_sf.tfMotto.text = xmlData.Player.Motto;
				_sf.tfLocation.text = xmlData.Player.Location;
				_sf.tfBiography.text = xmlData.Player.Bio;
				_sf.urlAvatar = xmlData.Player.Avatar.Body;
				
				if(xmlData.Player.Status.Online == 1) {
					_sf.tfOnline.text = "Online";
				}else {
					_sf.tfOnline.text = "Offline";
				}
				
				_sf.loadAvatar();
				
				var photoArrray:Array = [];
				
				for each(var img:XML in xmlData.RecentGames) {	
					trace(img.Name);
					photoArrray.push(img.BoxArt.Small);
				}
				
				photoArrray.pop();
				
				if(photoArrray.length == 0) {
					_sf.gotoAndStop(3);
				}
				
				_sf.gamesArray = photoArrray;
				
				_sf.loadActivity();
				
				_evt.photoArray = photoArrray;
				dispatchEvent(_evt);
				
				if(_preloader) {
					_sf.removeChild(_preloader);
				}
			}
		} 
	}
}