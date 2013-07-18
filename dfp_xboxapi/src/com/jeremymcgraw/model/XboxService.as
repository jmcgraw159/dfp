package com.jeremymcgraw.model
{
	import com.jeremymcgraw.ui.Display;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
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
		public static const PROXY:String = "http://proxy.alanjames1987.com/?"
		public static const PICTURE_PROXY:String = "http://proxy.alanjames1987.com/picture.php?"
		
		public function XboxService(searchField:Display)
		{
			super();
			_sf = searchField;
			_evt = new XboxEvent(XboxEvent.PHOTOS_LOADED);
		}
		
		public function doSearch(keyword:String):void
		{	
			var url:String = PROXY + "https://xboxapi.com/xml/profile/" + keyword;
			var urlFriends:String = PROXY + "https://xboxapi.com/xml/friends/" + keyword;
			
			trace(url);
			trace(urlFriends);
			
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
			_sf.gotoAndStop(3);
			if(_preloader) {
				_sf.removeChild(_preloader);
			}
		}
		
		private function onLoadFriends(event:Event):void
		{	
			_sf.removeFriends();
			
			var xmlDataF:XML = XML(_ulFriends.data);
			trace(xmlDataF.API_Limit + " API Limit");
			
			var friendArrray:Array = [];
			
			for each(var imgF:XML in xmlDataF.Friends) {
				if(imgF.IsOnline == 1) {
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
			
			if(xmlData.Error == "Invalid Gamertag" || xmlData.Error == "Login failure, please check your credentials!") {
				trace("Error");
				error();
			}else {	
				try
				{
					trace("_sf.tfInput " + _sf.tfInput);
					trace("_sf.tfGamerscore " + _sf.tfGamerscore);
					trace("_sf.tfName " + _sf.tfName);
					trace("_sf.tfMotto " + _sf.tfMotto);
					trace("_sf.tfLocation " + _sf.tfLocation);
					trace("_sf.tfBiography " + _sf.tfBiography);
					//trace("_sf.tfLastActivity " + _sf.tfActivity);
						
					_sf.tfInput.text = xmlData.Player.Gamertag;
					_sf.tfGamerscore.text = xmlData.Player.Gamerscore;
					_sf.tfName.text = xmlData.Player.Name;
					_sf.tfMotto.text = xmlData.Player.Motto;
					_sf.tfLocation.text = xmlData.Player.Location;
					_sf.tfBiography.text = xmlData.Player.Bio;
					//_sf.tfActivity.text = xmlData.Player.Status.Online_Status;
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
						
					//if(photoArrray.length == 0) {
					//_sf.gotoAndStop(3);
					//}
						
					_sf.gamesArray = photoArrray;
						
					_sf.loadActivity();
						
					_evt.photoArray = photoArrray;
					dispatchEvent(_evt);
						
					if(_preloader) {
						_sf.removeChild(_preloader);
					}
				}
				catch(e:Error)
				{
					error();
				}
			}
		} 
		
		private function error():void
		{	
			_ulFriends.removeEventListener(Event.COMPLETE, onLoadFriends);
			_ulProfile.removeEventListener(Event.COMPLETE, onLoadProfile);
			_sf.removeImg();
			_sf.removeActivity();
			_sf.removeFriends();
			_sf.gotoAndStop(3);
			if(_preloader) {
				_sf.removeChild(_preloader);
			}
		}
	}
}