package com.riotgames.platform.gameclient.views.store
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IStoreProvider;
   import com.riotgames.platform.common.provider.StoreProviderProxy;
   import com.riotgames.platform.gameclient.views.store.event.SessionExpiredEvent;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class StoreView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _StoreView_Image1:Image;
      
      private var _location:String;
      
      mx_internal var _watchers:Array;
      
      private var logger:ILogger;
      
      private var _1744491761storeHtmlView:StoreHtmlView;
      
      private var repeatClick:Boolean = false;
      
      private var _1407051306loadingStoreUrl:Boolean = true;
      
      private var pageIsDirty:Boolean = true;
      
      private var isUnavailableMessageLoaded:Boolean = false;
      
      mx_internal var _bindingsByDestination:Object;
      
      public var _StoreView_Text1:Text;
      
      private var storeQueryString:String;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var inventory:IInventory;
      
      private var storeRelativeUrl:String;
      
      private var clientConfig:ClientConfig;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public var _StoreView_HBox1:HBox;
      
      public function StoreView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":StoreHtmlView,
                  "id":"storeHtmlView",
                  "events":{"sessionExpired":"__storeHtmlView_sessionExpired"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "percentHeight":100
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":HBox,
                  "id":"_StoreView_HBox1",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"_StoreView_Image1"
                     }),new UIComponentDescriptor({
                        "type":Text,
                        "id":"_StoreView_Text1",
                        "propertiesFactory":function():Object
                        {
                           return {"styleName":"optionsText"};
                        }
                     })]};
                  }
               })]};
            }
         });
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
         this.clientConfig = ClientConfig.instance;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.addEventListener("initialize",this.___StoreView_Canvas1_initialize);
         this.addEventListener("show",this.___StoreView_Canvas1_show);
         this.addEventListener("hide",this.___StoreView_Canvas1_hide);
         this.addEventListener("addedToStage",this.___StoreView_Canvas1_addedToStage);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         StoreView._watcherSetupUtil = param1;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:StoreView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._StoreView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_store_StoreViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      public function resetView() : void
      {
         this.repeatClick = false;
         var _loc1_:IStoreProvider = StoreProviderProxy.instance;
         _loc1_.getStoreUrlReadyChanged().remove(this.onStoreUrlReadyChangedHandler);
      }
      
      public function __storeHtmlView_sessionExpired(param1:SessionExpiredEvent) : void
      {
         this.storehtmlview1_sessionExpiredHandler(param1);
      }
      
      public function ___StoreView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      [Bindable(event="propertyChange")]
      public function get loadingStoreUrl() : Boolean
      {
         return this._1407051306loadingStoreUrl;
      }
      
      public function ___StoreView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable("locationChange")]
      private function get location() : String
      {
         return this._location;
      }
      
      protected function storehtmlview1_sessionExpiredHandler(param1:SessionExpiredEvent) : void
      {
         var _loc2_:String = param1.path;
         var _loc3_:int = _loc2_.indexOf("/",9);
         if(_loc3_ != -1)
         {
            this.storeRelativeUrl = _loc2_.substring(_loc3_ + 1);
         }
         else
         {
            this.storeRelativeUrl = _loc2_;
         }
         this.storeQueryString = param1.queryString;
         var _loc4_:IStoreProvider = StoreProviderProxy.instance;
         _loc4_.refreshStoreUrl(true);
      }
      
      private function onHide() : void
      {
         this.resetView();
      }
      
      public function setPageDirty(param1:Boolean) : void
      {
         this.pageIsDirty = param1;
      }
      
      public function refreshStore(param1:String, param2:Boolean = false) : void
      {
         if(this.pageIsDirty || param2)
         {
            this.pageIsDirty = false;
            this.storeRelativeUrl = param1;
            this.storeQueryString = null;
            this.onStoreUrlReadyChangedHandler();
         }
      }
      
      private function onInitialize() : void
      {
         this.loadingStoreUrl = true;
      }
      
      public function ___StoreView_Canvas1_addedToStage(param1:Event) : void
      {
         this.onShow();
      }
      
      private function _StoreView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.location;
         _loc1_ = this.loadingStoreUrl;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_SpinLoader");
         _loc1_ = resourceManager.getString("resources","store_loading_message");
      }
      
      public function set loadingStoreUrl(param1:Boolean) : void
      {
         var _loc2_:Object = this._1407051306loadingStoreUrl;
         if(_loc2_ !== param1)
         {
            this._1407051306loadingStoreUrl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loadingStoreUrl",_loc2_,param1));
         }
      }
      
      private function initializeView() : void
      {
         if(!this.clientConfig.storeEnabled)
         {
            this.isUnavailableMessageLoaded = false;
         }
         else if(this.isUnavailableMessageLoaded)
         {
            return;
         }
         var _loc1_:IStoreProvider = StoreProviderProxy.instance;
         _loc1_.getStoreUrlReadyChanged().add(this.onStoreUrlReadyChangedHandler);
         if(!this.location)
         {
            this.onStoreUrlReadyChangedHandler();
            _loc1_.refreshStoreUrl();
         }
      }
      
      private function _StoreView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = location;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            storeHtmlView.location = param1;
         },"storeHtmlView.location");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return loadingStoreUrl;
         },function(param1:Boolean):void
         {
            _StoreView_HBox1.visible = param1;
         },"_StoreView_HBox1.visible");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_SpinLoader");
         },function(param1:Object):void
         {
            _StoreView_Image1.source = param1;
         },"_StoreView_Image1.source");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","store_loading_message");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _StoreView_Text1.htmlText = param1;
         },"_StoreView_Text1.htmlText");
         result[3] = binding;
         return result;
      }
      
      public function ___StoreView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function set location(param1:String) : void
      {
         this._location = param1;
         dispatchEvent(new Event("locationChange"));
      }
      
      private function onStoreUrlReadyChangedHandler() : void
      {
         var _loc1_:IStoreProvider = StoreProviderProxy.instance;
         if(!_loc1_.getStoreUrlReady())
         {
            return;
         }
         this.location = _loc1_.getCurrentStoreUrl(this.storeRelativeUrl,this.storeQueryString);
         if(this.location)
         {
            this.loadingStoreUrl = false;
            _loc1_.discardToken();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get storeHtmlView() : StoreHtmlView
      {
         return this._1744491761storeHtmlView;
      }
      
      public function set storeHtmlView(param1:StoreHtmlView) : void
      {
         var _loc2_:Object = this._1744491761storeHtmlView;
         if(_loc2_ !== param1)
         {
            this._1744491761storeHtmlView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storeHtmlView",_loc2_,param1));
         }
      }
      
      private function onShow() : void
      {
         this.initializeView();
      }
      
      public function showStoreRelativeUrl(param1:String, param2:String) : void
      {
         if(!this.pageIsDirty && !this.repeatClick && (param1 == this.storeRelativeUrl && param2 == this.storeQueryString))
         {
            this.repeatClick = true;
            return;
         }
         if(this.pageIsDirty)
         {
            this.pageIsDirty = false;
         }
         this.storeRelativeUrl = param1;
         this.storeQueryString = param2;
         this.onStoreUrlReadyChangedHandler();
      }
   }
}

