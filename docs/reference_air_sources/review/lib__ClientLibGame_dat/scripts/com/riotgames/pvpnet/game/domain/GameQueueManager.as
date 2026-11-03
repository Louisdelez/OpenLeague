package com.riotgames.pvpnet.game.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.PlatformConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class GameQueueManager implements IGameQueueManager, IEventDispatcher
   {
      
      public static const QUEUE_INDEX_UNSELECTED:int = -1;
      
      public static const TEAM_NAME_UNSELECTED:String = "!!NoTeamSelected6293!!";
      
      private var _353338795availableQueues:ArrayCollection;
      
      private var _1330843744availableQueueNames:ArrayCollection;
      
      private var _1335712170availableQueueSizes:ArrayCollection;
      
      private var _813865914selectedGameQueueConfig:GameQueueConfig;
      
      private var _1025929326_rankedTeamName:String = "!!NoTeamSelected6293!!";
      
      private var _rankedTeamNameChangedSignal:Signal = new Signal();
      
      public var rankedTeamId:TeamId = null;
      
      private var _2092197505actualWaitTimeStr:String = "";
      
      private var _1739783841queueInfo:QueueInfo;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.gameclient.domain.game.GameQueueManager");
      
      private var myTimer:Timer;
      
      private var actualWaitTime:Date;
      
      private var currentGameType:String = "";
      
      private var _queueInfoChanged:Signal = new Signal();
      
      private var updatingQueues:Boolean = false;
      
      private var setAvailableQueuesPending:Boolean = false;
      
      private var _queuesNeedUpdating:Boolean = false;
      
      private var _queuesUpdated:Signal = new Signal();
      
      private var _queuesNeedUpdatingChanged:Signal = new Signal();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GameQueueManager()
      {
         super();
         this.availableQueueNames = new ArrayCollection();
         this.availableQueueSizes = new ArrayCollection();
         ProviderLookup.publishProvider(IGameQueueManager,this);
      }
      
      public function get queuesNeedUpdating() : Boolean
      {
         return this._queuesNeedUpdating;
      }
      
      public function set queuesNeedUpdating(param1:Boolean) : void
      {
         this._queuesNeedUpdating = param1;
         this._queuesNeedUpdatingChanged.dispatch();
      }
      
      public function get queuesNeedUpdatingChanged() : ISignal
      {
         return this._queuesNeedUpdatingChanged;
      }
      
      public function get queuesUpdated() : ISignal
      {
         return this._queuesUpdated;
      }
      
      [Bindable(event="rankedTeamNameChanged")]
      public function get rankedTeamName() : String
      {
         return this._rankedTeamName;
      }
      
      public function set rankedTeamName(param1:String) : void
      {
         if(this.rankedTeamName == param1)
         {
            return;
         }
         this._rankedTeamName = param1;
         this.dispatchEvent(new Event("rankedTeamNameChanged"));
         this._rankedTeamNameChangedSignal.dispatch(this._rankedTeamName);
      }
      
      public function getRankedTeamNameChangedSignal() : ISignal
      {
         return this._rankedTeamNameChangedSignal;
      }
      
      public function setSelectedQueueId(param1:int) : void
      {
         var _loc2_:GameQueueConfig = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.platformConfig.allGameQueues.length)
         {
            _loc2_ = this.platformConfig.allGameQueues.getItemAt(_loc3_) as GameQueueConfig;
            if(_loc2_.id == param1)
            {
               this.selectedGameQueueConfig = _loc2_;
               this.rankedTeamName = TEAM_NAME_UNSELECTED;
               this.rankedTeamId = null;
               break;
            }
            _loc3_++;
         }
      }
      
      public function joinEquivalentPremadeSoloQueue() : void
      {
         var _loc1_:GameQueueConfig = null;
         for each(_loc1_ in this.platformConfig.allGameQueues)
         {
            if(_loc1_.ranked == true && _loc1_.minimumParticipantListSize == 1)
            {
               if(this.selectedGameQueueConfig.type == QueueType.RANKED_PREMADE_5x5 && _loc1_.type == QueueType.RANKED_SOLO_5x5)
               {
                  this.selectedGameQueueConfig = _loc1_;
                  this.rankedTeamName = TEAM_NAME_UNSELECTED;
                  this.rankedTeamId = null;
               }
            }
         }
      }
      
      public function joinEquivalentFullPremadeQueue() : void
      {
         var _loc1_:GameQueueConfig = null;
         for each(_loc1_ in this.platformConfig.allGameQueues)
         {
            if(_loc1_.ranked == true && _loc1_.minimumParticipantListSize > 1)
            {
               if(this.selectedGameQueueConfig.type == QueueType.RANKED_SOLO_5x5 && _loc1_.type == QueueType.RANKED_PREMADE_5x5)
               {
                  this.selectedGameQueueConfig = _loc1_;
                  this.rankedTeamName = TEAM_NAME_UNSELECTED;
                  this.rankedTeamId = null;
               }
            }
         }
      }
      
      public function checkQueuesHaveChanged(param1:ArrayCollection) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(this.platformConfig.allGameQueues == null)
         {
            _loc2_ = true;
         }
         else if(this.platformConfig.allGameQueues.length != param1.length)
         {
            _loc2_ = true;
         }
         else
         {
            param1.sort = new Sort();
            param1.refresh();
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_] != this.platformConfig.allGameQueues[_loc3_].id)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         if(_loc2_)
         {
            this.queuesNeedUpdating = true;
         }
      }
      
      private function getQueues(param1:String) : ArrayCollection
      {
         var _loc3_:GameQueueConfig = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in this.platformConfig.allGameQueues)
         {
            switch(param1)
            {
               case GameType.NORMAL_GAME:
                  if(_loc3_.type == QueueType.NORMAL)
                  {
                     _loc2_.addItem(_loc3_);
                  }
                  break;
               case GameType.RANKED_GAME_SOLO:
                  if(_loc3_.ranked == true && _loc3_.minimumParticipantListSize == 1)
                  {
                     _loc2_.addItem(_loc3_);
                  }
                  break;
               case GameType.RANKED_GAME_PREMADE:
                  if(_loc3_.ranked == true && _loc3_.minimumParticipantListSize > 1)
                  {
                     _loc2_.addItem(_loc3_);
                  }
                  break;
               case GameType.COOP_VS_AI:
                  if(_loc3_.type == QueueType.BOT)
                  {
                     _loc2_.addItem(_loc3_);
                  }
                  break;
               default:
                  _loc2_.addItem(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function setAvailableQueues(param1:String) : void
      {
         var _loc2_:GameQueueConfig = null;
         if(param1 == this.currentGameType && !this.setAvailableQueuesPending)
         {
            return;
         }
         this.currentGameType = param1;
         if(!this.queuesNeedUpdating)
         {
            this.setAvailableQueuesPending = false;
            this.availableQueues = this.getQueues(param1);
            this.availableQueueNames.removeAll();
            this.availableQueueSizes.removeAll();
            for each(_loc2_ in this.availableQueues)
            {
               this.availableQueueNames.addItem(_loc2_.name);
               this.availableQueueSizes.addItem(_loc2_.numPlayersPerTeam);
            }
         }
      }
      
      public function getMaxNumberPlayersPerArrangedTeam(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:GameQueueConfig = this.getQueueForID(param1);
         if(_loc3_ != null)
         {
            _loc2_ = int(_loc3_.maximumParticipantListSize);
         }
         return _loc2_;
      }
      
      public function setQueueInfo(param1:QueueInfo) : void
      {
         var _loc2_:GameQueueConfig = this.getQueueForID(param1.queueId);
         if(_loc2_ == null)
         {
            throw new Error("Unable to find queue with ID " + param1.queueId);
         }
         this.selectedGameQueueConfig = _loc2_;
         this.queueInfo = param1;
         var _loc3_:Date = new Date();
         _loc3_.hours = 0;
         _loc3_.minutes = 0;
         _loc3_.seconds = 0;
         _loc3_.time += param1.waitTime;
         param1.waitTimeStr = this.formatTime(_loc3_);
         this._queueInfoChanged.dispatch(param1);
      }
      
      public function getQueueInfoChanged() : ISignal
      {
         return this._queueInfoChanged;
      }
      
      public function getQueuesUpdated() : ISignal
      {
         return this._queuesUpdated;
      }
      
      public function beginQueueWait(param1:Boolean) : void
      {
         if(param1 || this.actualWaitTime == null)
         {
            this.actualWaitTime = new Date();
            this.actualWaitTime.time = 0;
         }
         if(this.myTimer == null)
         {
            this.myTimer = new Timer(1000);
            this.myTimer.addEventListener("timer",this.updateTime);
         }
         this.myTimer.start();
      }
      
      public function endQueueWait() : void
      {
         if(this.myTimer == null)
         {
            return;
         }
         if(this.myTimer.running)
         {
            this.myTimer.stop();
         }
         this.myTimer.removeEventListener("timer",this.updateTime);
         this.myTimer = null;
      }
      
      public function reset() : void
      {
         this.selectedGameQueueConfig = null;
         this.rankedTeamName = TEAM_NAME_UNSELECTED;
         this.rankedTeamId = null;
      }
      
      private function updateTime(param1:TimerEvent) : void
      {
         this.actualWaitTime.time += 1000;
         this.actualWaitTimeStr = this.formatTime(this.actualWaitTime);
         this.dispatchEvent(param1);
      }
      
      private function formatTime(param1:Date) : String
      {
         var _loc2_:String = "";
         if(param1.minutesUTC < 10)
         {
            _loc2_ += "0";
         }
         _loc2_ += param1.minutesUTC;
         _loc2_ += ":";
         if(param1.secondsUTC < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + param1.secondsUTC;
      }
      
      public function getQueueForID(param1:int) : GameQueueConfig
      {
         var _loc2_:GameQueueConfig = null;
         for each(_loc2_ in this.platformConfig.allGameQueues)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function updateQueuesIfNeeded() : void
      {
         if(this.queuesNeedUpdating)
         {
            this.updateQueues();
         }
      }
      
      public function getMinSummonerLevelForRanked() : int
      {
         var _loc3_:GameQueueConfig = null;
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.platformConfig.allGameQueues)
         {
            if(Boolean(_loc3_.ranked) && (!_loc2_ || _loc3_.minLevel < _loc1_))
            {
               _loc2_ = true;
               _loc1_ = int(_loc3_.minLevel);
            }
         }
         return _loc1_;
      }
      
      public function getMinSummonerLevelForSoloRanked() : int
      {
         var _loc3_:GameQueueConfig = null;
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.platformConfig.allGameQueues)
         {
            if(Boolean(_loc3_.ranked) && _loc3_.minimumParticipantListSize == 1 && (!_loc2_ || _loc3_.minLevel < _loc1_))
            {
               _loc2_ = true;
               _loc1_ = int(_loc3_.minLevel);
            }
         }
         return _loc1_;
      }
      
      public function getMinSummonerLevelForArrangedRanked() : int
      {
         var _loc3_:GameQueueConfig = null;
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.platformConfig.allGameQueues)
         {
            if(Boolean(_loc3_.ranked) && _loc3_.maximumParticipantListSize > 1 && (!_loc2_ || _loc3_.minLevel < _loc1_))
            {
               _loc2_ = true;
               _loc1_ = int(_loc3_.minLevel);
            }
         }
         return _loc1_;
      }
      
      public function getRankedGamesQueueCount() : int
      {
         var _loc2_:GameQueueConfig = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.platformConfig.allGameQueues)
         {
            if(_loc2_.ranked)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function getNormalGamesQueueCount() : int
      {
         var _loc2_:GameQueueConfig = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.platformConfig.allGameQueues)
         {
            if(!_loc2_.ranked)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function getRankedSoloGamesQueueCount() : int
      {
         var _loc2_:GameQueueConfig = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.platformConfig.allGameQueues)
         {
            if(Boolean(_loc2_.ranked) && _loc2_.minimumParticipantListSize == 1)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function getRankedArrangedGamesQueueCount() : int
      {
         var _loc2_:GameQueueConfig = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.platformConfig.allGameQueues)
         {
            if(Boolean(_loc2_.ranked) && _loc2_.maximumParticipantListSize > 1)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function updateQueues() : void
      {
         if(!this.updatingQueues)
         {
            this.queuesNeedUpdating = false;
            this.updatingQueues = true;
            ServiceProxy.instance.matchMakerService.getAvailableQueues(this.onRetrieveGameQueuesSuccess,null,this.onRetrieveGameQueuesFailed);
         }
      }
      
      private function onRetrieveGameQueuesSuccess(param1:ResultEvent) : void
      {
         this.updatingQueues = false;
         if(param1 != null && param1.result != null && param1.result is ArrayCollection)
         {
            this.currentGameType = null;
            this.platformConfig.allGameQueues = param1.result as ArrayCollection;
            if(this.setAvailableQueuesPending)
            {
               this.setAvailableQueues(this.currentGameType);
            }
            this._queuesUpdated.dispatch(this);
         }
      }
      
      private function onRetrieveGameQueuesFailed(param1:Object) : void
      {
         this.updatingQueues = false;
         this.currentGameType = null;
         this.platformConfig.allGameQueues = new ArrayCollection();
      }
      
      private function get platformConfig() : PlatformConfig
      {
         return PlatformConfigProviderProxy.instance.getPlatformConfig();
      }
      
      public function getSelectedGameQueueConfig() : GameQueueConfig
      {
         return this.selectedGameQueueConfig;
      }
      
      public function getQueueInfo() : QueueInfo
      {
         return this.queueInfo;
      }
      
      public function getActualWaitTimeStr() : String
      {
         return this.actualWaitTimeStr;
      }
      
      [Bindable(event="propertyChange")]
      public function get availableQueues() : ArrayCollection
      {
         return this._353338795availableQueues;
      }
      
      public function set availableQueues(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._353338795availableQueues;
         if(_loc2_ !== param1)
         {
            this._353338795availableQueues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableQueues",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availableQueueNames() : ArrayCollection
      {
         return this._1330843744availableQueueNames;
      }
      
      public function set availableQueueNames(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1330843744availableQueueNames;
         if(_loc2_ !== param1)
         {
            this._1330843744availableQueueNames = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableQueueNames",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availableQueueSizes() : ArrayCollection
      {
         return this._1335712170availableQueueSizes;
      }
      
      public function set availableQueueSizes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1335712170availableQueueSizes;
         if(_loc2_ !== param1)
         {
            this._1335712170availableQueueSizes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableQueueSizes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedGameQueueConfig() : GameQueueConfig
      {
         return this._813865914selectedGameQueueConfig;
      }
      
      public function set selectedGameQueueConfig(param1:GameQueueConfig) : void
      {
         var _loc2_:Object = this._813865914selectedGameQueueConfig;
         if(_loc2_ !== param1)
         {
            this._813865914selectedGameQueueConfig = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedGameQueueConfig",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _rankedTeamName() : String
      {
         return this._1025929326_rankedTeamName;
      }
      
      public function set _rankedTeamName(param1:String) : void
      {
         var _loc2_:Object = this._1025929326_rankedTeamName;
         if(_loc2_ !== param1)
         {
            this._1025929326_rankedTeamName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_rankedTeamName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get actualWaitTimeStr() : String
      {
         return this._2092197505actualWaitTimeStr;
      }
      
      public function set actualWaitTimeStr(param1:String) : void
      {
         var _loc2_:Object = this._2092197505actualWaitTimeStr;
         if(_loc2_ !== param1)
         {
            this._2092197505actualWaitTimeStr = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actualWaitTimeStr",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get queueInfo() : QueueInfo
      {
         return this._1739783841queueInfo;
      }
      
      public function set queueInfo(param1:QueueInfo) : void
      {
         var _loc2_:Object = this._1739783841queueInfo;
         if(_loc2_ !== param1)
         {
            this._1739783841queueInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueInfo",_loc2_,param1));
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

