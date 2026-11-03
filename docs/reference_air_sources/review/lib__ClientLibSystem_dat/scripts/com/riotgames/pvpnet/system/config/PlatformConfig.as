package com.riotgames.pvpnet.system.config
{
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.game.QueueThrottleDTO;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   public class PlatformConfig
   {
      
      private var _kudosEnabled:Boolean;
      
      private var _kudosEnabledChanged:Signal = new Signal();
      
      private var _kudosSet:Signal = new OnceSignal();
      
      private var _displayPromotionalGamesEnabled:Boolean;
      
      private var _displayPromotionalGamesEnabledChanged:Signal = new Signal();
      
      private var _displayPromotionalGamesSet:Signal = new OnceSignal();
      
      private var _queueThrottleDTO:QueueThrottleDTO;
      
      private var _queueThrottleDTOChanged:Signal = new Signal();
      
      private var _enabledQueueIdsList:ArrayCollection;
      
      private var _enabledQueueIdsListChanged:Signal = new Signal();
      
      private var _clientHeartBeatRateSeconds:int;
      
      private var _clientHeartBeatRateSecondsChanged:Signal = new Signal();
      
      private var _clientHeartBeatRateSecondsSet:Signal = new OnceSignal();
      
      private var _allGameQueues:ArrayCollection = new ArrayCollection();
      
      private var _allGameQueuesChanged:Signal = new Signal();
      
      private var _platformConfigChanged:Signal = new Signal();
      
      public function PlatformConfig()
      {
         super();
      }
      
      public function get kudosEnabled() : Boolean
      {
         return this._kudosEnabled;
      }
      
      public function set kudosEnabled(param1:Boolean) : void
      {
         this._kudosEnabled = param1;
         this._kudosEnabledChanged.dispatch(param1);
         this._kudosSet.dispatch(param1);
      }
      
      public function get kudosEnabledChanged() : ISignal
      {
         return this._kudosEnabledChanged;
      }
      
      public function get kudosSet() : ISignal
      {
         return this._kudosSet;
      }
      
      public function get displayPromotionalGamesEnabled() : Boolean
      {
         return this._displayPromotionalGamesEnabled;
      }
      
      public function set displayPromotionalGamesEnabled(param1:Boolean) : void
      {
         this._displayPromotionalGamesEnabled = param1;
         this._displayPromotionalGamesEnabledChanged.dispatch(param1);
         this._displayPromotionalGamesSet.dispatch(param1);
      }
      
      public function get displayPromotionalGamesEnabledChanged() : ISignal
      {
         return this._displayPromotionalGamesEnabledChanged;
      }
      
      public function get displayPromotionalGamesSet() : ISignal
      {
         return this._displayPromotionalGamesSet;
      }
      
      public function get queueThrottleDTO() : QueueThrottleDTO
      {
         return this._queueThrottleDTO;
      }
      
      public function set queueThrottleDTO(param1:QueueThrottleDTO) : void
      {
         this._queueThrottleDTO = param1;
         this._queueThrottleDTOChanged.dispatch(param1);
      }
      
      public function get queueThrottleDTOChanged() : ISignal
      {
         return this._queueThrottleDTOChanged;
      }
      
      public function get enabledQueueIdsList() : ArrayCollection
      {
         return this._enabledQueueIdsList;
      }
      
      public function set enabledQueueIdsList(param1:ArrayCollection) : void
      {
         this._enabledQueueIdsList = param1;
         this._enabledQueueIdsListChanged.dispatch(param1);
      }
      
      public function get enabledQueueIdsListChanged() : ISignal
      {
         return this._enabledQueueIdsListChanged;
      }
      
      public function get clientHeartBeatRateSeconds() : int
      {
         return this._clientHeartBeatRateSeconds;
      }
      
      public function set clientHeartBeatRateSeconds(param1:int) : void
      {
         this._clientHeartBeatRateSeconds = param1;
         this._clientHeartBeatRateSecondsChanged.dispatch(param1);
         this._clientHeartBeatRateSecondsSet.dispatch(param1);
      }
      
      public function get clientHeartBeatRateSecondsChanged() : ISignal
      {
         return this._clientHeartBeatRateSecondsChanged;
      }
      
      public function get clientHeartBeatRateSecondsSet() : ISignal
      {
         return this._clientHeartBeatRateSecondsSet;
      }
      
      public function get allGameQueues() : ArrayCollection
      {
         return this._allGameQueues;
      }
      
      public function set allGameQueues(param1:ArrayCollection) : void
      {
         this._allGameQueues = param1;
         this._allGameQueues.sort = new Sort();
         this._allGameQueues.sort.fields = [new SortField("id")];
         this._allGameQueues.refresh();
         this._allGameQueuesChanged.dispatch();
      }
      
      public function get allGameQueuesChanged() : ISignal
      {
         return this._allGameQueuesChanged;
      }
      
      internal function setPlatformConfigChanged() : void
      {
         this._platformConfigChanged.dispatch(this);
      }
      
      public function get platformConfigChanged() : ISignal
      {
         return this._platformConfigChanged;
      }
   }
}

