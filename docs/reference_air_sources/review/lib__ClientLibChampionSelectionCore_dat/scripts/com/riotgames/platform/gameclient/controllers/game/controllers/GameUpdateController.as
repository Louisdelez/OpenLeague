package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.MessageRouterService;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.TeamSkinRentalDTO;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.messaging.MessageQueue;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.messaging.events.MessageEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class GameUpdateController
   {
      
      public static const TICKLE_TIMEOUT_TIME:Number = 10000;
      
      private var _busyWaitAction:AlertWaitAction;
      
      private var _messageRouterService:MessageRouterService;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _alerter:IAlerterProvider;
      
      private var _realTimeStart:Number = 0;
      
      private var _totalTimerSeconds:Number = 0;
      
      private var _isBusy:Boolean = false;
      
      private var _gameService:GameService;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      private var _tickleTimeoutId:int = 0;
      
      private var _timeRemainingSeconds:int = 0;
      
      private var _timerSpriteStub:Sprite = new Sprite();
      
      private var _gameMessageQueue:MessageQueue;
      
      public function GameUpdateController(param1:ChampionSelectionModel, param2:GameService, param3:MessageRouterService, param4:IAlerterProvider)
      {
         super();
         this._gameService = param2;
         this._messageRouterService = param3;
         this._championSelectionModel = param1;
         this._alerter = param4;
      }
      
      private function onGameStateError(param1:ServerError) : void
      {
         this.logger.error("0005 failed to retrieve game state from server with " + param1.errorCode);
      }
      
      public function clearTickleTimer() : void
      {
         if(this._tickleTimeoutId != 0)
         {
            clearTimeout(this._tickleTimeoutId);
            this._tickleTimeoutId = 0;
         }
      }
      
      public function setIsBusy(param1:Boolean) : void
      {
         if(this._isBusy != param1)
         {
            this._isBusy = param1;
            this.updateBusy();
         }
      }
      
      private function onChampionSelectionStateChanged(param1:Event) : void
      {
         if(this._championSelectionModel.championSelectionState == GameState.POST_CHAMPION_SELECTION && Boolean(this._championSelectionModel.gameTypeConfig))
         {
            this.resetTimer(this._championSelectionModel.gameTypeConfig.postPickTimerDuration);
         }
      }
      
      public function stop() : void
      {
         this.removeListeners();
         this.stopGameCountdownTimer();
         this.clearTickleTimer();
         if(Boolean(this._gameMessageQueue))
         {
            this._messageRouterService.removeGameMessageListener(this._gameMessageQueue.onMessageReceived);
         }
         this._gameMessageQueue = null;
      }
      
      private function onTickleTimeout() : void
      {
         if(this._tickleTimeoutId != 0)
         {
            this._tickleTimeoutId = 0;
            this.requestGameState();
         }
      }
      
      protected function get timeRemainingSeconds() : int
      {
         return this._timeRemainingSeconds;
      }
      
      private function stopGameCountdownTimer() : void
      {
         this._timerSpriteStub.removeEventListener(Event.ENTER_FRAME,this.onTimer);
      }
      
      private function onPickTurnChanged(param1:Event) : void
      {
         if(this._championSelectionModel.championSelectionState == GameState.PRE_CHAMPION_SELECTION)
         {
            if(Boolean(this._championSelectionModel.gameTypeConfig))
            {
               this.resetTimer(this._championSelectionModel.gameTypeConfig.banTimerDuration);
            }
         }
         if(this._championSelectionModel.pickTurn <= 0)
         {
            return;
         }
         if(this._championSelectionModel.championSelectionState != GameState.PRE_CHAMPION_SELECTION)
         {
            if(this._championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION)
            {
               if(Boolean(this._championSelectionModel.gameTypeConfig))
               {
                  this.resetTimer(this._championSelectionModel.gameTypeConfig.mainPickTimerDuration);
               }
            }
         }
      }
      
      private function updateGame(param1:GameDTO) : void
      {
         this._championSelectionModel.currentGame = param1;
      }
      
      private function onCurrentGameRetrieved(param1:ResultEvent) : void
      {
         var _loc2_:GameDTO = param1.result as GameDTO;
         if(Boolean(_loc2_))
         {
            this.updateGame(_loc2_);
         }
      }
      
      private function addListeners() : void
      {
         this._championSelectionModel.addEventListener(ChampionSelectionModel.PICK_TURN_CHANGED,this.onPickTurnChanged,false,0,true);
         this._championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onChampionSelectionStateChanged,false,0,true);
         this._championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_GAME_CHANGED,this.onCurrentGameChanged,false,0,true);
      }
      
      public function onServerGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is GameDTO)
         {
            this.updateGame(GameDTO(_loc2_));
         }
         else if(_loc2_ is TeamSkinRentalDTO)
         {
            this._championSelectionModel.teamSkinRental = _loc2_ as TeamSkinRentalDTO;
         }
      }
      
      private function onTimer(param1:Event) : void
      {
         var _loc2_:Number = getTimer();
         var _loc3_:Number = Math.floor((_loc2_ - this._realTimeStart) / 1000);
         this.timeRemainingSeconds = Math.max(0,this._totalTimerSeconds - _loc3_);
         if(this.timeRemainingSeconds <= 0)
         {
            this.onTimerComplete();
         }
      }
      
      private function onCurrentGameChanged(param1:Event) : void
      {
         this.clearTickleTimer();
      }
      
      private function updateBusy() : void
      {
         var _loc1_:IResourceManager = null;
         if(this._isBusy)
         {
            CursorManager.getInstance().setBusyCursor();
            if(this._busyWaitAction == null)
            {
               _loc1_ = ResourceManager.getInstance();
               this._busyWaitAction = new AlertWaitAction(_loc1_.getString("resources","serverWait_retrievingDataMessage"),_loc1_.getString("resources","serverWait_loadingMessage"));
            }
            this._busyWaitAction.add();
         }
         else
         {
            if(Boolean(this._busyWaitAction))
            {
               this._busyWaitAction.complete();
            }
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.setIsBusy(false);
      }
      
      protected function set timeRemainingSeconds(param1:int) : void
      {
         if(this._timeRemainingSeconds != param1)
         {
            this._timeRemainingSeconds = param1;
            if(Boolean(this._championSelectionModel))
            {
               this._championSelectionModel.timeRemainingSeconds = param1;
            }
         }
      }
      
      public function start() : void
      {
         this._gameMessageQueue = new MessageQueue("gameQueue",this.onServerGameMessageReceived);
         this._messageRouterService.addGameMessageListener(this._gameMessageQueue.onMessageReceived);
         this.addListeners();
         if(Boolean(this._championSelectionModel.gameTypeConfig))
         {
            if(this._championSelectionModel.currentGame.gameState == GameState.CHAMPION_SELECTION)
            {
               this.resetTimer(this._championSelectionModel.gameTypeConfig.mainPickTimerDuration);
            }
            else if(this._championSelectionModel.currentGame.gameState == GameState.PRE_CHAMPION_SELECTION)
            {
               this.resetTimer(this._championSelectionModel.gameTypeConfig.banTimerDuration);
            }
         }
      }
      
      private function removeListeners() : void
      {
         this._championSelectionModel.removeEventListener(ChampionSelectionModel.PICK_TURN_CHANGED,this.onPickTurnChanged);
         this._championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onChampionSelectionStateChanged);
         this._championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_GAME_CHANGED,this.onCurrentGameChanged);
      }
      
      public function requestGameState() : void
      {
         if(this._championSelectionModel.currentGame != null)
         {
            this._gameService.getGameState(this._championSelectionModel.currentGame,this.onCurrentGameRetrieved,this.onServiceRequestComplete,this.onGameStateError);
         }
      }
      
      public function resetTimer(param1:int) : void
      {
         if(param1 > GameTypeConfig.SERVER_TIMER_BUFFER)
         {
            param1 -= GameTypeConfig.SERVER_TIMER_BUFFER;
         }
         this.stopGameCountdownTimer();
         this._totalTimerSeconds = param1;
         this._realTimeStart = getTimer();
         this.timeRemainingSeconds = Math.max(0,param1);
         this._timerSpriteStub.addEventListener(Event.ENTER_FRAME,this.onTimer);
      }
      
      private function onTimerComplete() : void
      {
         this.stopGameCountdownTimer();
         if(this._championSelectionModel.championSelectionState == GameState.POST_CHAMPION_SELECTION)
         {
            this._championSelectionModel.isGameQueuedToStart = true;
         }
         this._tickleTimeoutId = setTimeout(this.onTickleTimeout,TICKLE_TIMEOUT_TIME);
      }
   }
}

