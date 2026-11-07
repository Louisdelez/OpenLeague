package mx.managers
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import mx.core.FlexGlobals;
   import mx.core.mx_internal;
   import mx.events.BrowserChangeEvent;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   [Event(name="applicationURLChange",type="mx.events.BrowserChangeEvent")]
   [Event(name="browserURLChange",type="mx.events.BrowserChangeEvent")]
   [Event(name="urlChange",type="flash.events.Event")]
   public class BrowserManagerImpl extends EventDispatcher implements IBrowserManager
   {
      
      private static var instance:IBrowserManager;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _defaultFragment:String = "";
      
      private var _browserUserAgent:String;
      
      private var _browserPlatform:String;
      
      private var _isFirefoxMac:Boolean;
      
      private var browserMode:Boolean = true;
      
      private var _base:String;
      
      private var _fragment:String;
      
      private var _title:String;
      
      private var _url:String;
      
      public function BrowserManagerImpl()
      {
         var systemManager:Object;
         var sandboxRoot:Object = null;
         var parent:Object = null;
         super();
         systemManager = SystemManagerGlobals.topLevelSystemManagers;
         if(Boolean(systemManager))
         {
            systemManager = systemManager[0];
         }
         if(Boolean(systemManager))
         {
            sandboxRoot = systemManager.getSandboxRoot();
            if(!sandboxRoot.dispatchEvent(new Event("mx.managers::BrowserManager",false,true)))
            {
               this.browserMode = false;
               return;
            }
            try
            {
               parent = sandboxRoot.parent;
               while(Boolean(parent))
               {
                  if(sandboxRoot.parent is Stage)
                  {
                     break;
                  }
                  parent = parent.parent;
               }
            }
            catch(e:Error)
            {
               browserMode = false;
               return;
            }
            sandboxRoot.addEventListener("mx.managers::BrowserManager",this.sandboxBrowserManagerHandler,false,0,true);
         }
         try
         {
            ExternalInterface.addCallback("browserURLChange",this.browserURLChangeBrowser);
            ExternalInterface.addCallback("debugTrace",this.debugTrace);
         }
         catch(e:Error)
         {
            browserMode = false;
         }
      }
      
      public static function getInstance() : IBrowserManager
      {
         if(!instance)
         {
            instance = new BrowserManagerImpl();
         }
         return instance;
      }
      
      [Bindable("urlChange")]
      public function get base() : String
      {
         return this._base;
      }
      
      [Bindable("urlChange")]
      public function get fragment() : String
      {
         if(Boolean(this._fragment) && Boolean(this._fragment.length))
         {
            return this._fragment;
         }
         return this._defaultFragment;
      }
      
      [Bindable("urlChange")]
      public function get title() : String
      {
         return this._title;
      }
      
      [Bindable("urlChange")]
      public function get url() : String
      {
         return this._url;
      }
      
      public function init(defaultFragment:String = "", defaultTitle:String = "") : void
      {
         if("historyManagementEnabled" in FlexGlobals.topLevelApplication)
         {
            FlexGlobals.topLevelApplication.historyManagementEnabled = false;
         }
         this.setup(defaultFragment,defaultTitle);
      }
      
      public function initForHistoryManager() : void
      {
         this.setup("","");
      }
      
      private function setup(defaultFragment:String, defaultTitle:String) : void
      {
         if(!this.browserMode)
         {
            return;
         }
         this._defaultFragment = defaultFragment;
         this._url = ExternalInterface.call("BrowserHistory.getURL");
         if(!this._url)
         {
            this.browserMode = false;
            return;
         }
         this._browserUserAgent = ExternalInterface.call("BrowserHistory.getUserAgent");
         this._browserPlatform = ExternalInterface.call("BrowserHistory.getPlatform");
         this._isFirefoxMac = this._browserUserAgent && this._browserPlatform && this._browserUserAgent.indexOf("Firefox") > -1 && this._browserPlatform.indexOf("Mac") > -1;
         var pos:int = this._url.indexOf("#");
         if(pos == -1 || pos == this._url.length - 1)
         {
            this._base = this._url;
            this._fragment = "";
            this._title = defaultTitle;
            ExternalInterface.call("BrowserHistory.setDefaultURL",defaultFragment);
            this.setTitle(defaultTitle);
         }
         else
         {
            this._base = this._url.substring(0,pos);
            this._fragment = this._url.substring(pos + 1);
            this._title = ExternalInterface.call("BrowserHistory.getTitle");
            ExternalInterface.call("BrowserHistory.setDefaultURL",this._fragment);
            if(this._fragment != this._defaultFragment)
            {
               this.browserURLChange(this._fragment,true);
            }
         }
      }
      
      public function setFragment(value:String) : void
      {
         var urlReq:URLRequest = null;
         if(!this.browserMode)
         {
            return;
         }
         var lastURL:String = this._url;
         var lastFragment:String = this._fragment;
         this._url = this.base + "#" + value;
         this._fragment = value;
         if(dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.APPLICATION_URL_CHANGE,false,true,this._url,lastURL)))
         {
            if(!this._isFirefoxMac)
            {
               ExternalInterface.call("BrowserHistory.setBrowserURL",value,ExternalInterface.objectID);
            }
            else
            {
               urlReq = new URLRequest("javascript:BrowserHistory.setBrowserURL(\'" + value + "\',\'" + ExternalInterface.objectID + "\');");
               navigateToURL(urlReq,"_self");
            }
            dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.URL_CHANGE,false,false,this._url,lastURL));
         }
         else
         {
            this._fragment = lastFragment;
            this._url = lastURL;
         }
      }
      
      public function setTitle(value:String) : void
      {
         if(!this.browserMode)
         {
            return;
         }
         ExternalInterface.call("BrowserHistory.setTitle",value);
         this._title = ExternalInterface.call("BrowserHistory.getTitle");
      }
      
      private function browserURLChangeBrowser(fragment:String) : void
      {
         this.browserURLChange(fragment,false);
      }
      
      private function browserURLChange(fragment:String, force:Boolean = false) : void
      {
         var lastURL:String = null;
         if(fragment != null && decodeURI(this._fragment) != decodeURI(fragment) || force)
         {
            this._fragment = fragment;
            lastURL = this.url;
            this._url = this._base + "#" + fragment;
            dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.BROWSER_URL_CHANGE,false,false,this.url,lastURL));
            dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.URL_CHANGE,false,false,this.url,lastURL));
         }
      }
      
      private function sandboxBrowserManagerHandler(event:Event) : void
      {
         event.preventDefault();
      }
      
      private function debugTrace(s:String) : void
      {
         trace(s);
      }
   }
}

