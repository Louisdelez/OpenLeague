package com.riotgames.platform.gameclient.controllers.store
{
   import blix.signals.ISignal;
   import blix.signals.ToggleSignal;
   import com.riotgames.platform.common.module.championdetail.ChampionDetailContext;
   import com.riotgames.platform.common.provider.ChampionDetailProviderProxy;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IStoreProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.controllers.IViewController;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.url.UrlVo;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class StoreController extends EventDispatcher implements IViewController, IStoreProvider
   {
      
      public static const STORE_UNAVAILABLE_URL:String = "app:/assets/htmlTemplates/store/storeClosedTemplate.html";
      
      public static const RELATIVE_URL_PURCHASE_SKIN:String = "/store/items/view_item/Skin/championsskin_";
      
      public static const RELATIVE_URL_PURCHASE_CHAMPION:String = "/store/items/view_item/Champion/champions_";
      
      public static const RELATIVE_URL_VIEW_SKINS:String = "/store/tabs/view/skins";
      
      public static const RELATIVE_URL_VIEW_CHAMPIONS:String = "/store/tabs/view/champions";
      
      private var isBusy:Boolean;
      
      private var _storeIsUnavailable:Boolean;
      
      private var startTime:Number;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session = Session.instance;
      
      private var inventoryController:IInventoryController;
      
      private var isReady:Boolean;
      
      private var _storeCanonicalUrl:UrlVo = new UrlVo();
      
      private var _storeUrlReadyChanged:ToggleSignal = new ToggleSignal();
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public function StoreController()
      {
         super();
         this.initialize();
         this.clientConfig.getStoreEnabledChanged().add(this.storeEnabledChangedHandler);
      }
      
      private static function parseItemId(param1:String) : int
      {
         if(param1 == null || param1 == "")
         {
            return -1;
         }
         var _loc2_:String = "_";
         var _loc3_:int = param1.indexOf(_loc2_);
         if(_loc3_ < 0)
         {
            return -1;
         }
         return int(parseInt(param1.substring(_loc3_ + 1)));
      }
      
      private function onGetStoreUrlSuccess(param1:ResultEvent) : void
      {
         this.isReady = true;
         var _loc2_:String = param1.result as String;
         if(!_loc2_)
         {
            this._storeIsUnavailable = true;
         }
         else
         {
            this._storeIsUnavailable = false;
            this._storeCanonicalUrl.parseUrl(_loc2_);
            if(!("lang" in this._storeCanonicalUrl.urlVariables))
            {
               this._storeCanonicalUrl.urlVariables["lang"] = this.clientConfig.currentLocale;
            }
         }
         this._storeUrlReadyChanged.toggleOn();
      }
      
      public function activate() : void
      {
      }
      
      private function onGetStoreUrlComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      public function refreshStoreUrl(param1:Boolean = false) : void
      {
         if(param1 || !this.isReady && !this.isBusy)
         {
            this.doRefreshStoreUrl();
         }
      }
      
      public function discardToken() : void
      {
         delete this._storeCanonicalUrl.urlVariables["token"];
         delete this._storeCanonicalUrl.urlVariables["original_account_id"];
         delete this._storeCanonicalUrl.urlVariables["original_platform_id"];
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventoryController = param1.getInventoryController();
      }
      
      public function initialize() : void
      {
         if(!this.inventoryController)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
         this.logger.debug("Store controller initialized.");
         ProviderLookup.publishProvider(IStoreProvider,this);
      }
      
      public function cleanup() : void
      {
      }
      
      public function getIsStoreAvailable() : Boolean
      {
         return !this._storeIsUnavailable && Boolean(this.clientConfig.storeEnabled);
      }
      
      public function openInventoryBrowser(param1:String, param2:String = "", param3:String = "", param4:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc8_:IChampionDetailProvider = null;
         var _loc5_:int = parseItemId(param1);
         var _loc6_:Champion = this.inventoryController.findChampionById(_loc5_);
         if(_loc6_ != null)
         {
            _loc7_ = parseItemId(param2);
            if(!param3 || param3.length == 0)
            {
               param3 = ChampionDetailContext.STORE;
            }
            _loc8_ = ChampionDetailProviderProxy.instance;
            _loc8_.displayChampionDetailView(param3,_loc6_,_loc7_,param4);
         }
      }
      
      public function getCurrentStoreUrl(param1:String = "", param2:String = "") : String
      {
         var _loc4_:URLVariables = null;
         var _loc5_:String = null;
         if(this.clientConfig.storeUrlOverride != null)
         {
            return this.clientConfig.storeUrlOverride;
         }
         if(!this.getIsStoreAvailable())
         {
            return STORE_UNAVAILABLE_URL;
         }
         if(!this.isReady)
         {
            return "";
         }
         var _loc3_:UrlVo = this._storeCanonicalUrl.clone();
         if(param2)
         {
            _loc4_ = new URLVariables(param2);
            delete _loc4_["token"];
            delete _loc4_["original_account_id"];
            delete _loc4_["original_platform_id"];
            _loc3_.appendQuery(_loc4_);
         }
         if(param1)
         {
            _loc5_ = _loc3_.baseUrl;
            if(_loc5_)
            {
               if(_loc5_.charAt(_loc5_.length - 1) != "/" && param1.charAt(0) != "/")
               {
                  _loc5_ += "/";
               }
               _loc3_.baseUrl = _loc5_ + param1;
            }
         }
         return _loc3_.toUrl();
      }
      
      public function deactivate() : void
      {
      }
      
      public function getStoreUrlReadyChanged() : ISignal
      {
         return this._storeUrlReadyChanged;
      }
      
      private function storeEnabledChangedHandler() : void
      {
         if(this.isReady && !this.isBusy)
         {
            this._storeUrlReadyChanged.toggleOff();
            this._storeUrlReadyChanged.toggleOn();
         }
      }
      
      private function doRefreshStoreUrl() : void
      {
         this._storeUrlReadyChanged.toggleOff();
         if(!this.clientConfig.storeEnabled)
         {
            this._storeUrlReadyChanged.toggleOn();
         }
         else
         {
            this.isBusy = true;
            this.startTime = getTimer();
            this.serviceProxy.loginService.getStoreUrl(this.onGetStoreUrlSuccess,this.onGetStoreUrlComplete);
         }
      }
      
      public function getStoreUrlReady() : Boolean
      {
         if(this.clientConfig.storeUrlOverride != null)
         {
            return true;
         }
         if(!this.clientConfig.storeEnabled)
         {
            return true;
         }
         return this.isReady;
      }
   }
}

