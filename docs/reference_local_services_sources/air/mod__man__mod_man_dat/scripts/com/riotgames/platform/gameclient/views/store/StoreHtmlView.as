package com.riotgames.platform.gameclient.views.store
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.domain.inventory.InventoryType;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.controllers.store.StoreController;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.store.StoreAccountBalanceNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import com.riotgames.platform.gameclient.views.store.event.SessionExpiredEvent;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.MessageQueue;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
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
   import mx.controls.HTML;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.events.MessageEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class StoreHtmlView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _3213227html:HTML;
      
      private var _location:String;
      
      mx_internal var _watchers:Array = [];
      
      [Inject]
      public var rosterProvider:IChatRosterProvider;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      public var wordFilter:WordFilter;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      [Inject]
      public var masterGameController:MasterGameController;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var inventory:IInventory;
      
      [Inject]
      public var storeController:StoreController;
      
      private var clientConfig:ClientConfig;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":HTML,
               "id":"html",
               "events":{"htmlDOMInitialize":"__html_htmlDOMInitialize"},
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0;
                  this.horizontalCenter = "0";
                  this.verticalScrollBarStyleName = "chatScroll";
                  this.horizontalScrollBarStyleName = "chatScroll";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "location":"app:/assets/htmlTemplates/parentFrame.html",
                     "percentWidth":100,
                     "percentHeight":100,
                     "paintsDefaultBackground":false
                  };
               }
            })]};
         }
      });
      
      private var onInternalBrowserClosedUrl:String = null;
      
      mx_internal var _bindings:Array = [];
      
      public function StoreHtmlView()
      {
         super();
         mx_internal::_document = this;
         this.addEventListener("initialize",this.___StoreHtmlView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         StoreHtmlView._watcherSetupUtil = param1;
      }
      
      private function marshallBuddyRoster() : Array
      {
         var _loc3_:Buddy = null;
         var _loc4_:StoreBuddy = null;
         var _loc1_:Array = this.rosterProvider.getAllRosterBuddies();
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new StoreBuddy();
            _loc4_.busyStatus = _loc3_.getBusyStatus();
            _loc4_.isMutualFriend = _loc3_.getIsMutualFriend();
            _loc4_.name = _loc3_.getName();
            _loc4_.presence = _loc3_.getPresence();
            _loc4_.realName = _loc3_.getRealName();
            _loc4_.status = _loc3_.getStatus();
            _loc4_.summonerId = _loc3_.getSummonerId();
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function updateRiotPoints(param1:Number) : void
      {
         this.inventory.riotPoints = param1;
      }
      
      public function hideInternalBrowser() : void
      {
         if(AppConfig.instance.internalBrowserAction != null)
         {
            AppConfig.instance.internalBrowserAction.remove();
         }
      }
      
      public function ___StoreHtmlView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:StoreHtmlView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._StoreHtmlView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_store_StoreHtmlViewWatcherSetupUtil");
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
      
      private function onBrowserClosed(param1:ISignal) : void
      {
         param1.remove(this.onBrowserClosed);
         if(this.onInternalBrowserClosedUrl)
         {
            this.location = this.onInternalBrowserClosedUrl;
            this.onInternalBrowserClosedUrl = null;
         }
      }
      
      private function handleStoreFulfillmentNotification(param1:StoreFulfillmentNotification) : void
      {
         var _loc5_:Champion = null;
         var _loc6_:ChampionSkin = null;
         var _loc2_:Object = new Object();
         var _loc3_:Object = new Object();
         var _loc4_:Date = new Date();
         if(param1.inventoryType == InventoryType.CHAMPION)
         {
            _loc5_ = param1.data as Champion;
            _loc3_.item_id = "champions_" + _loc5_.championId;
            _loc3_.is_rented = _loc5_.isRented();
            _loc3_.is_owned = _loc5_.isOwned();
            _loc3_.winCountRemaining = _loc5_.winCountRemaining;
            _loc3_.end_date = _loc5_.endDate;
            _loc3_.ItemIsExpiring = _loc5_.isAlmostExpired();
            _loc3_.ItemIsExpired = _loc5_.isExpired();
            _loc3_.IsPerWinRental = _loc5_.isRented() && _loc5_.winCountRemaining > 0;
            _loc3_.IsTimedRental = _loc5_.isRented() && _loc5_.endDate > _loc4_.getTime();
            _loc3_.ExpirationWindow = 0;
            _loc3_.ExpirationMessage = "";
         }
         else if(param1.inventoryType == InventoryType.CHAMPION_SKIN)
         {
            _loc6_ = param1.data as ChampionSkin;
            _loc3_.item_id = "championsskin_" + _loc6_.skinId;
            _loc3_.is_rented = _loc6_.isRented();
            _loc3_.is_owned = _loc6_.isOwned();
            _loc3_.winCountRemaining = _loc6_.winCountRemaining;
            _loc3_.end_date = _loc6_.endDate;
            _loc3_.ItemIsExpiring = _loc6_.isAlmostExpired();
            _loc3_.ItemIsExpired = _loc6_.isExpired();
            _loc3_.IsPerWinRental = _loc6_.isRented() && _loc6_.winCountRemaining > 0;
            _loc3_.IsTimedRental = _loc6_.isRented() && _loc6_.endDate > _loc4_.getTime();
            _loc3_.ExpirationWindow = 0;
            _loc3_.ExpirationMessage = "";
         }
         _loc2_.item = _loc3_;
         this.html.domWindow.handleCdpEntitlement(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get html() : HTML
      {
         return this._3213227html;
      }
      
      private function updateInfluencePoints(param1:Number) : void
      {
         this.inventory.influencePoints = param1;
      }
      
      private function testIsNameValid(param1:String) : Boolean
      {
         var _loc2_:Boolean = Boolean(this.wordFilter.containsOffensiveWords(param1,true));
         var _loc3_:Boolean = Boolean(this.wordFilter.containsRestrictedWords(param1,true));
         var _loc4_:Array = this.wordFilter.getInvalidCharacters(param1);
         return !_loc2_ && !_loc3_ && _loc4_ == null;
      }
      
      protected function sessionExpired(param1:String = "", param2:String = "") : void
      {
         dispatchEvent(new SessionExpiredEvent(SessionExpiredEvent.SESSION_EXPIRED,param1,param2));
      }
      
      public function setAJAXHttpStatus(param1:int) : void
      {
      }
      
      private function testIfUserIsInQueue() : Boolean
      {
         if(this.masterGameController.currentState == GameViewState.NO_GAME || this.masterGameController.currentState == GameViewState.JOIN_GAME || this.masterGameController.currentState == GameViewState.CREATE_GAME)
         {
            return false;
         }
         return true;
      }
      
      public function get location() : String
      {
         return this._location;
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
      }
      
      protected function onInitialize() : void
      {
         if(!this.inventory)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
         this.clientConfig = ClientConfig.instance;
         this.wordFilter = WordFilter.instance;
      }
      
      public function __html_htmlDOMInitialize(param1:Event) : void
      {
         this.html_htmlDOMInitializeHandler(param1);
      }
      
      public function set html(param1:HTML) : void
      {
         var _loc2_:Object = this._3213227html;
         if(_loc2_ !== param1)
         {
            this._3213227html = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"html",_loc2_,param1));
         }
      }
      
      protected function html_htmlDOMInitializeHandler(param1:Event) : void
      {
         var event:Event = param1;
         this.html.domWindow.onload = function():void
         {
            var _loc1_:Object = html.domWindow.parentInterface;
            _loc1_.playChooseMe = playChooseMe;
            _loc1_.setAJAXHttpStatus = setAJAXHttpStatus;
            _loc1_.openInventoryBrowser = storeController.openInventoryBrowser;
            _loc1_.testIsNameValid = testIsNameValid;
            _loc1_.testIfUserIsInQueue = testIfUserIsInQueue;
            _loc1_.updateRiotPoints = updateRiotPoints;
            _loc1_.updateInfluencePoints = updateInfluencePoints;
            _loc1_.openExternalURL = openExternalURL;
            _loc1_.showInternalBrowser = showInternalBrowser;
            _loc1_.hideInternalBrowser = hideInternalBrowser;
            _loc1_.sessionExpired = sessionExpired;
            _loc1_.runeInventoryCount = runeInventoryCount;
            _loc1_.getBuddyList = marshallBuddyRoster;
            _loc1_.storeUnavailableMessage = resourceManager.getString("resources","store_unavailable_message");
            html.domWindow.navigate(location);
            var _loc2_:ServiceProxy = ServiceProxy.instance;
            var _loc3_:MessageQueue = new MessageQueue("nonGame",onNonGameMessageReceived);
            _loc2_.messageRouterService.addClientNotificationMessageListener(_loc3_.onMessageReceived);
         };
      }
      
      private function _StoreHtmlView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return 1 / parentApplication.scaleX;
         },function(param1:Number):void
         {
            html.scaleX = param1;
         },"html.scaleX");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / parentApplication.scaleY;
         },function(param1:Number):void
         {
            html.scaleY = param1;
         },"html.scaleY");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = parentApplication.scaleX == 1 ? "off" : "auto";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            html.horizontalScrollPolicy = param1;
         },"html.horizontalScrollPolicy");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = parentApplication.scaleY == 1 ? "off" : "auto";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            html.verticalScrollPolicy = param1;
         },"html.verticalScrollPolicy");
         result[3] = binding;
         return result;
      }
      
      public function playChooseMe(param1:String) : void
      {
         this.soundManager.playSummonChampionBySkinname(param1);
      }
      
      private function _StoreHtmlView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = 1 / parentApplication.scaleX;
         _loc1_ = 1 / parentApplication.scaleY;
         _loc1_ = parentApplication.scaleX == 1 ? "off" : "auto";
         _loc1_ = parentApplication.scaleY == 1 ? "off" : "auto";
      }
      
      private function onNonGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc2_:IClientNotification = param1.message.body as IClientNotification;
         if(!_loc2_)
         {
            return;
         }
         switch(_loc2_.notificationType)
         {
            case ClientNotificationType.ACCOUNT_BALANCE:
               this.handleStoreAccountBalanceNotification(_loc2_ as StoreAccountBalanceNotification);
               break;
            case ClientNotificationType.FULFILLMENT:
               this.handleStoreFulfillmentNotification(_loc2_ as StoreFulfillmentNotification);
         }
      }
      
      public function set location(param1:String) : void
      {
         this._location = param1;
         if(Boolean(this.html.domWindow) && Boolean(this.html.domWindow.navigate) && Boolean(this._location))
         {
            this.html.domWindow.navigate(this._location);
         }
      }
      
      private function handleStoreAccountBalanceNotification(param1:StoreAccountBalanceNotification) : void
      {
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         if(param1.rp >= 0)
         {
            _loc2_ = int(param1.rp);
         }
         if(param1.ip >= 0)
         {
            _loc3_ = int(param1.ip);
         }
         var _loc4_:Object = new Object();
         _loc4_.ip_balance = _loc3_;
         _loc4_.rp_balance = _loc2_;
         this.html.domWindow.handleCdpBalance(_loc4_);
      }
      
      protected function runeInventoryCount(param1:int) : int
      {
         var _loc2_:SummonerRune = null;
         if(this.inventory != null && this.clientConfig != null && !this.clientConfig.runeUniquePerSpellBook)
         {
            for each(_loc2_ in this.inventory.summonerRuneInventory.summonerRunes)
            {
               if(_loc2_.runeId == param1)
               {
                  return _loc2_.quantity;
               }
            }
            return 0;
         }
         return -1;
      }
      
      public function showInternalBrowser(param1:String, param2:String = null) : void
      {
         this.onInternalBrowserClosedUrl = param2;
         if(AppConfig.instance.internalBrowserAction != null)
         {
            AppConfig.instance.internalBrowserAction.getBrowserClosed().add(this.onBrowserClosed);
            AppConfig.instance.internalBrowserAction.add(param1,false,["paypal.com"],this,this.stage.stageWidth,this.stage.stageHeight);
         }
      }
      
      private function openExternalURL(param1:String) : void
      {
         navigateToURL(new URLRequest(param1));
      }
   }
}

