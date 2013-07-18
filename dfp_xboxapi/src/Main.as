package
{
	import com.jeremymcgraw.model.XboxEvent;
	import com.jeremymcgraw.model.XboxService;
	import com.jeremymcgraw.ui.Display;
	
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	// Github Link: http://jmcgraw159.github.io/dfp/dfp_xboxapi/Main.html
	
	[SWF(width="810", height="430", frameRate="30", backgroundColor="0x000000")]
	public class Main extends Sprite
	{	
		private var _gamertag:String;
		private var _searchField:Display;
		
		public function Main()
		{	
			_searchField = new Display();
			addChild(_searchField);
			_searchField.mcButtonBase.buttonMode = true;
			_searchField.mcButtonBase.mouseChildren = false;
			
			setupCopyright();
			
			_searchField.tfInput.maxChars = 15;
			
			_searchField.gotoAndStop(1);
			
			_searchField.mcButtonBase.addEventListener(MouseEvent.CLICK, onClick);
			_searchField.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
		
		private function onKey(event:KeyboardEvent):void
		{
			if(event.keyCode == 13) {
				trace("Started Loading...");
				
				_gamertag = _searchField.tfInput.text;
				
				var svc:XboxService = new XboxService(_searchField);
				svc.addEventListener(XboxEvent.PHOTOS_LOADED, onLoad);
				svc.addEventListener(IOErrorEvent.IO_ERROR, onError);
				svc.doSearch(_gamertag);
			}
		}
		
		private function setupCopyright():void
		{
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			
			var mItem:ContextMenuItem = new ContextMenuItem("Copyright ©2013 Jeremy McGraw", true);
			mItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyrightClick);
			
			var mItemTwo:ContextMenuItem = new ContextMenuItem("API provided by xboxapi.com", true);
			
			cm.customItems.push(mItem);
			cm.customItems.push(mItemTwo);
			this.contextMenu = cm;
		}
		
		private function copyrightClick(event:ContextMenuEvent):void
		{
			var urlRequest:URLRequest = new URLRequest("http://jeremymcgraw.com");
			navigateToURL(urlRequest, "_blank");
		}
		
		private function onClick(event:MouseEvent):void
		{	
			trace("Started Loading...");
			
			_gamertag = _searchField.tfInput.text;
		
			var svc:XboxService = new XboxService(_searchField);
			svc.addEventListener(XboxEvent.PHOTOS_LOADED, onLoad);
			svc.addEventListener(IOErrorEvent.IO_ERROR, onError);
			svc.doSearch(_gamertag);
		}
		
		private function onError(event:IOErrorEvent):void
		{
			_searchField.gotoAndStop(3);
			_searchField.nextFrame();
			_searchField.removeActivity();
			_searchField.removeFriends();
		}
		
		private function onLoad(event:Event):void
		{
			trace("...Finished Loading");
			_searchField.gotoAndStop(2);
		}
	}
}