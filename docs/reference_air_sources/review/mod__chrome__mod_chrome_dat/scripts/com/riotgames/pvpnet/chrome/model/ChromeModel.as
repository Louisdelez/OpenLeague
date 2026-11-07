package com.riotgames.pvpnet.chrome.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   
   public class ChromeModel
   {
      
      public var closeRequestedHandler:Function;
      
      private var _gameState:ChromeGameState;
      
      private var _gameStateChanged:Signal = new Signal();
      
      private var _queueBoxHomeButtonIsHidden:Boolean;
      
      private var _queueBoxHomeButtonIsHiddenChanged:Signal = new Signal();
      
      private var _playButtonEnabled:Boolean;
      
      private var _playButtonEnabledChanged:Signal = new Signal();
      
      private var _contextAlert:AlertParameters;
      
      private var _contextAlertChanged:Signal = new Signal();
      
      private var _navigatorVisible:Boolean = false;
      
      private var _navigatorVisibleChanged:Signal = new Signal();
      
      public function ChromeModel()
      {
         super();
      }
      
      public function get gameStateChanged() : ISignal
      {
         return this._gameStateChanged;
      }
      
      public function get gameState() : ChromeGameState
      {
         return this._gameState;
      }
      
      public function set gameState(param1:ChromeGameState) : void
      {
         this._gameState = param1;
         this._gameStateChanged.dispatch(param1);
      }
      
      public function get queueBoxHomeButtonIsHiddenChanged() : ISignal
      {
         return this._queueBoxHomeButtonIsHiddenChanged;
      }
      
      public function get queueBoxHomeButtonIsHidden() : Boolean
      {
         return this._queueBoxHomeButtonIsHidden;
      }
      
      public function set queueBoxHomeButtonIsHidden(param1:Boolean) : void
      {
         this._queueBoxHomeButtonIsHidden = param1;
         this._queueBoxHomeButtonIsHiddenChanged.dispatch(param1);
      }
      
      public function get playButtonEnabledChanged() : ISignal
      {
         return this._playButtonEnabledChanged;
      }
      
      public function get playButtonEnabled() : Boolean
      {
         return this._playButtonEnabled;
      }
      
      public function set playButtonEnabled(param1:Boolean) : void
      {
         if(param1 != this._playButtonEnabled)
         {
            this._playButtonEnabled = param1;
            this._playButtonEnabledChanged.dispatch();
         }
      }
      
      public function get contextAlert() : AlertParameters
      {
         return this._contextAlert;
      }
      
      public function get contextAlertChanged() : ISignal
      {
         return this._contextAlertChanged;
      }
      
      public function set contextAlert(param1:AlertParameters) : void
      {
         this._contextAlert = param1;
         this._contextAlertChanged.dispatch();
      }
      
      public function get navigatorVisible() : Boolean
      {
         return this._navigatorVisible;
      }
      
      public function set navigatorVisible(param1:Boolean) : void
      {
         if(param1 != this._navigatorVisible)
         {
            this._navigatorVisible = param1;
            this._navigatorVisibleChanged.dispatch();
         }
      }
      
      public function get navigatorVisibleChanged() : ISignal
      {
         return this._navigatorVisibleChanged;
      }
   }
}

