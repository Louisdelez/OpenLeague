package com.riotgames.pvpnet.game.controllers.lobby
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class LobbyConfig implements IEventDispatcher
   {
      
      private static var _instance:LobbyConfig;
      
      private var _isSummonerSearchEnabled:Boolean = false;
      
      private var _currentLobbyState:String = "loginViewState";
      
      private var _currentLobbyStateChanged:Signal = new Signal();
      
      private var _matchmakingState:String = "matchmakingNotQueued";
      
      private var _matchmakingStateChanged:Signal = new Signal();
      
      private var _levelUpInfo:LevelUpInfo;
      
      private var _levelUpInfoChanged:Signal = new Signal();
      
      private var _1040795267isNavigationEnabled:Boolean = false;
      
      private var _isGameButtonEnabled:Boolean = true;
      
      public var gameButtonEnabledChanged:Signal = new Signal();
      
      private var _874182427isLobbyBusy:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function LobbyConfig()
      {
         super();
      }
      
      public static function get instance() : LobbyConfig
      {
         if(_instance == null)
         {
            _instance = new LobbyConfig();
         }
         return _instance;
      }
      
      [Bindable(event="propertyChange")]
      public function get isSummonerSearchEnabled() : Boolean
      {
         return this._isSummonerSearchEnabled;
      }
      
      private function set _527578817isSummonerSearchEnabled(param1:Boolean) : void
      {
         this._isSummonerSearchEnabled = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentLobbyState() : String
      {
         return this._currentLobbyState;
      }
      
      private function set _1754121396currentLobbyState(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = this._currentLobbyState;
            this._currentLobbyState = param1;
            this._currentLobbyStateChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function get currentLobbyStateChanged() : ISignal
      {
         return this._currentLobbyStateChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get matchmakingState() : String
      {
         return this._matchmakingState;
      }
      
      private function set _986250943matchmakingState(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = this._matchmakingState;
            this._matchmakingState = param1;
            this._matchmakingStateChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function get matchmakingStateChanged() : ISignal
      {
         return this._matchmakingStateChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get levelUpInfo() : LevelUpInfo
      {
         return this._levelUpInfo;
      }
      
      private function set _1834022541levelUpInfo(param1:LevelUpInfo) : void
      {
         this._levelUpInfo = param1;
         this._levelUpInfoChanged.dispatch();
      }
      
      public function get levelUpInfoChanged() : ISignal
      {
         return this._levelUpInfoChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get isGameButtonEnabled() : Boolean
      {
         return this._isGameButtonEnabled;
      }
      
      private function set _112252717isGameButtonEnabled(param1:Boolean) : void
      {
         this._isGameButtonEnabled = param1;
         this.gameButtonEnabledChanged.dispatch();
      }
      
      [Bindable(event="propertyChange")]
      public function get isNavigationEnabled() : Boolean
      {
         return this._1040795267isNavigationEnabled;
      }
      
      public function set isNavigationEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1040795267isNavigationEnabled;
         if(_loc2_ !== param1)
         {
            this._1040795267isNavigationEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isNavigationEnabled",_loc2_,param1));
            }
         }
      }
      
      public function set isSummonerSearchEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.isSummonerSearchEnabled;
         if(_loc2_ !== param1)
         {
            this._527578817isSummonerSearchEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSummonerSearchEnabled",_loc2_,param1));
            }
         }
      }
      
      public function set levelUpInfo(param1:LevelUpInfo) : void
      {
         var _loc2_:Object = this.levelUpInfo;
         if(_loc2_ !== param1)
         {
            this._1834022541levelUpInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"levelUpInfo",_loc2_,param1));
            }
         }
      }
      
      public function set matchmakingState(param1:String) : void
      {
         var _loc2_:Object = this.matchmakingState;
         if(_loc2_ !== param1)
         {
            this._986250943matchmakingState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchmakingState",_loc2_,param1));
            }
         }
      }
      
      public function set isGameButtonEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.isGameButtonEnabled;
         if(_loc2_ !== param1)
         {
            this._112252717isGameButtonEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isGameButtonEnabled",_loc2_,param1));
            }
         }
      }
      
      public function set currentLobbyState(param1:String) : void
      {
         var _loc2_:Object = this.currentLobbyState;
         if(_loc2_ !== param1)
         {
            this._1754121396currentLobbyState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentLobbyState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isLobbyBusy() : Boolean
      {
         return this._874182427isLobbyBusy;
      }
      
      public function set isLobbyBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._874182427isLobbyBusy;
         if(_loc2_ !== param1)
         {
            this._874182427isLobbyBusy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isLobbyBusy",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

