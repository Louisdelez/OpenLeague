package com.riotgames.platform.common
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.view.IInternalBrowserAction;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class AppConfig implements IEventDispatcher
   {
      
      private static var _instance:AppConfig;
      
      private var _summonerIconSource:BitmapData;
      
      private var _isNavigatorVisible:Boolean = false;
      
      private var _minimized:Boolean = false;
      
      private var _currentAppStateChanged:Signal = new Signal();
      
      private var _loggingOut:Boolean = false;
      
      private var _isNavigatorVisibleChanged:Signal = new Signal();
      
      private var _availableMaps:ArrayCollection;
      
      private var _shutdownDisablePlayButtonChanged:Signal = new Signal();
      
      private var _minimizedChanged:Signal = new Signal();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public var internalBrowserAction:IInternalBrowserAction;
      
      private var _loggingOutChanged:Signal = new Signal();
      
      private var _currentAppState:String;
      
      private var _1221723654otherAccountGameInProgressSummonerName:String = "";
      
      private var _shutdownDisablePlayButton:Boolean = false;
      
      public var sessionStartTime:int;
      
      private var _antiIndulgenceMessage:AntiIndulgenceMessage;
      
      public var legacyPopupSupport:Boolean = false;
      
      private var _antiIndulgenceMessageChanged:Signal = new Signal();
      
      private var _summonerIconSourceChanged:Signal = new Signal();
      
      private var _902647604otherGameInProgress:Boolean = false;
      
      private var _availableMapsChanged:Signal = new Signal();
      
      public function AppConfig()
      {
         super();
      }
      
      public static function get instance() : AppConfig
      {
         if(_instance == null)
         {
            _instance = new AppConfig();
         }
         return _instance;
      }
      
      private function set _209333032shutdownDisablePlayButton(param1:Boolean) : void
      {
         this._shutdownDisablePlayButton = param1;
         this._shutdownDisablePlayButtonChanged.dispatch();
      }
      
      public function get minimized() : Boolean
      {
         return this._minimized;
      }
      
      public function get currentAppState() : String
      {
         return this._currentAppState;
      }
      
      public function get antiIndulgenceMessageChanged() : ISignal
      {
         return this._antiIndulgenceMessageChanged;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function get isNavigatorVisibleChanged() : ISignal
      {
         return this._isNavigatorVisibleChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get otherAccountGameInProgressSummonerName() : String
      {
         return this._1221723654otherAccountGameInProgressSummonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function set minimized(param1:Boolean) : void
      {
         var _loc2_:Object = this.minimized;
         if(_loc2_ !== param1)
         {
            this._818580870minimized = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimized",_loc2_,param1));
         }
      }
      
      public function isMapAvailable(param1:int) : Boolean
      {
         var _loc3_:GameMap = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in AppConfig.instance.availableMaps)
         {
            if(_loc3_ != null && _loc3_.mapId == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public function get availableMaps() : ArrayCollection
      {
         return this._availableMaps;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function set currentAppState(param1:String) : void
      {
         var _loc2_:Object = this.currentAppState;
         if(_loc2_ !== param1)
         {
            this._884727927currentAppState = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentAppState",_loc2_,param1));
         }
      }
      
      public function get availableMapsChanged() : ISignal
      {
         return this._availableMapsChanged;
      }
      
      private function set _1145824663antiIndulgenceMessage(param1:AntiIndulgenceMessage) : void
      {
         var _loc2_:AntiIndulgenceMessage = this._antiIndulgenceMessage;
         this._antiIndulgenceMessage = param1;
         this._antiIndulgenceMessageChanged.dispatch(_loc2_,param1);
      }
      
      private function set _1811595806summonerIconSource(param1:BitmapData) : void
      {
         this._summonerIconSource = param1;
         this._summonerIconSourceChanged.dispatch();
      }
      
      [Bindable(event="propertyChange")]
      public function set shutdownDisablePlayButton(param1:Boolean) : void
      {
         var _loc2_:Object = this.shutdownDisablePlayButton;
         if(_loc2_ !== param1)
         {
            this._209333032shutdownDisablePlayButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shutdownDisablePlayButton",_loc2_,param1));
         }
      }
      
      private function set _642628463loggingOut(param1:Boolean) : void
      {
         this._loggingOut = param1;
         this._loggingOutChanged.dispatch(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get otherGameInProgress() : Boolean
      {
         return this._902647604otherGameInProgress;
      }
      
      public function get shutdownDisablePlayButtonChanged() : ISignal
      {
         return this._shutdownDisablePlayButtonChanged;
      }
      
      private function set _1872853248availableMaps(param1:ArrayCollection) : void
      {
         this._availableMaps = param1;
         this._availableMapsChanged.dispatch(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      private function set _818580870minimized(param1:Boolean) : void
      {
         this._minimized = param1;
         this._minimizedChanged.dispatch(param1);
      }
      
      public function get loggingOutChanged() : ISignal
      {
         return this._loggingOutChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerIconSource(param1:BitmapData) : void
      {
         var _loc2_:Object = this.summonerIconSource;
         if(_loc2_ !== param1)
         {
            this._1811595806summonerIconSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerIconSource",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get minimizedChanged() : ISignal
      {
         return this._minimizedChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function set isNavigatorVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this.isNavigatorVisible;
         if(_loc2_ !== param1)
         {
            this._770237595isNavigatorVisible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isNavigatorVisible",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set antiIndulgenceMessage(param1:AntiIndulgenceMessage) : void
      {
         var _loc2_:Object = this.antiIndulgenceMessage;
         if(_loc2_ !== param1)
         {
            this._1145824663antiIndulgenceMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"antiIndulgenceMessage",_loc2_,param1));
         }
      }
      
      public function get shutdownDisablePlayButton() : Boolean
      {
         return this._shutdownDisablePlayButton;
      }
      
      [Bindable(event="propertyChange")]
      public function set loggingOut(param1:Boolean) : void
      {
         var _loc2_:Object = this.loggingOut;
         if(_loc2_ !== param1)
         {
            this._642628463loggingOut = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loggingOut",_loc2_,param1));
         }
      }
      
      public function get summonerIconSource() : BitmapData
      {
         return this._summonerIconSource;
      }
      
      [Bindable(event="propertyChange")]
      public function set availableMaps(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.availableMaps;
         if(_loc2_ !== param1)
         {
            this._1872853248availableMaps = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableMaps",_loc2_,param1));
         }
      }
      
      private function set _884727927currentAppState(param1:String) : void
      {
         var _loc2_:String = this._currentAppState;
         this._currentAppState = param1;
         this._currentAppStateChanged.dispatch(_loc2_,param1);
      }
      
      public function get isNavigatorVisible() : Boolean
      {
         return this._isNavigatorVisible;
      }
      
      public function set otherGameInProgress(param1:Boolean) : void
      {
         var _loc2_:Object = this._902647604otherGameInProgress;
         if(_loc2_ !== param1)
         {
            this._902647604otherGameInProgress = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"otherGameInProgress",_loc2_,param1));
         }
      }
      
      private function set _770237595isNavigatorVisible(param1:Boolean) : void
      {
         this._isNavigatorVisible = param1;
         this._isNavigatorVisibleChanged.dispatch(param1);
      }
      
      public function get currentAppStateChanged() : ISignal
      {
         return this._currentAppStateChanged;
      }
      
      public function get loggingOut() : Boolean
      {
         return this._loggingOut;
      }
      
      public function get antiIndulgenceMessage() : AntiIndulgenceMessage
      {
         return this._antiIndulgenceMessage;
      }
      
      public function get summonerIconSourceChanged() : ISignal
      {
         return this._summonerIconSourceChanged;
      }
      
      public function set otherAccountGameInProgressSummonerName(param1:String) : void
      {
         var _loc2_:Object = this._1221723654otherAccountGameInProgressSummonerName;
         if(_loc2_ !== param1)
         {
            this._1221723654otherAccountGameInProgressSummonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"otherAccountGameInProgressSummonerName",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

