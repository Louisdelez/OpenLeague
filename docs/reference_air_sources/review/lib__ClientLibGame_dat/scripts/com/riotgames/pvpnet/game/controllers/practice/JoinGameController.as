package com.riotgames.pvpnet.game.controllers.practice
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
   import com.riotgames.pvpnet.game.controllers.ICycleViewController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class JoinGameController implements ICycleViewController, IEventDispatcher
   {
      
      [Inject]
      public var applicationController:IAppController;
      
      public var masterGameController:MasterGameController;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var _1180619197isBusy:Boolean;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var proxiedOnError:Function;
      
      private var _practiceGames:ArrayCollection = new ArrayCollection();
      
      private var _practiceGamesChanged:Signal = new Signal();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function JoinGameController()
      {
         super();
      }
      
      public function initialize() : void
      {
      }
      
      public function initializeCycle() : void
      {
      }
      
      public function abortCycle() : void
      {
      }
      
      public function cleanup() : void
      {
         this.practiceGames.source = [];
         this.isBusy = false;
         this.proxiedOnError = null;
      }
      
      public function cleanupCycle() : void
      {
      }
      
      public function activate() : void
      {
         this.refreshAvailablePracticeGames();
      }
      
      public function deactivate() : void
      {
         this.practiceGames.source = [];
      }
      
      [Bindable(event="propertyChange")]
      public function get practiceGames() : ArrayCollection
      {
         return this._practiceGames;
      }
      
      private function set _1722593722practiceGames(param1:ArrayCollection) : void
      {
         this._practiceGames = param1;
         this._practiceGamesChanged.dispatch(param1);
      }
      
      public function get practiceGamesChanged() : ISignal
      {
         return this._practiceGamesChanged;
      }
      
      public function refreshAvailablePracticeGames() : void
      {
         this.isBusy = true;
         this.serviceProxy.gameService.getAvailablePracticeGames(this.onAvailablePracticeGamesRetrieved,this.onServiceRequestComplete);
      }
      
      public function joinGame(param1:PracticeGameSearchResult, param2:String, param3:Function) : void
      {
         this.isBusy = true;
         this.proxiedOnError = param3;
         this.masterGameController.gameMap = this.masterGameController.applicationController.getGameMap(param1.gameMap.mapId);
         if(param1.glmGameId != null && param1.glmHost != null && param1.glmPort != 0)
         {
            this.serviceProxy.gameZoneGameService.setGameServiceZone(param1.glmHost,param1.glmPort,param1.glmSecurePort);
         }
         this.serviceProxy.gameService.joinGame(param1.id,param2,this.onJoinGameSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function observeGame(param1:PracticeGameSearchResult, param2:String, param3:Function) : void
      {
         this.isBusy = true;
         this.proxiedOnError = param3;
         this.masterGameController.gameMap = this.masterGameController.applicationController.getGameMap(param1.gameMap.mapId);
         this.serviceProxy.gameService.observeGame(param1.id,param2,this.onJoinGameSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function startPracticeGameFlowAtCreateGame() : void
      {
         this.masterGameController.startPracticeGameFlowAtCreateGame();
      }
      
      public function quit() : void
      {
         this.masterGameController.cancelGameFlow();
      }
      
      private function onAvailablePracticeGamesRetrieved(param1:ResultEvent) : void
      {
         var _loc4_:PracticeGameSearchResult = null;
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            _loc4_.initParams();
            if(!_loc4_.gameMap && _loc4_.gameMapId > 0)
            {
               _loc4_.gameMap = this.masterGameController.applicationController.getGameMap(_loc4_.gameMapId);
            }
            if(Boolean(_loc4_.gameMap))
            {
               _loc4_.gameMap.displayName = RiotResourceLoader.getMapResourceString("displayname",_loc4_.gameMap.mapId,"**" + _loc4_.gameMap.displayName);
               _loc4_.gameMap.description = RiotResourceLoader.getMapResourceString("description",_loc4_.gameMap.mapId,"**" + _loc4_.gameMap.description);
               _loc3_.push(_loc4_);
            }
         }
         this.isBusy = false;
         this.practiceGames.source = _loc3_;
         this._practiceGamesChanged.dispatch(this._practiceGames);
      }
      
      private function onJoinGameSuccess(param1:ResultEvent) : void
      {
         var _loc2_:GameDTO = param1.result as GameDTO;
         if(Boolean(_loc2_))
         {
            this.masterGameController.currentGame = _loc2_;
         }
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
         }
         this.proxiedOnError = null;
         this.masterGameController.gameMap = null;
      }
      
      public function get practiceGameParameters() : PracticeGameParameters
      {
         var _loc1_:GameModel = this.masterGameController.gameModel;
         var _loc2_:String = _loc1_ != null ? _loc1_.gameMode : PracticeGameParametersFactory.CUSTOM_MODE_ID;
         return PracticeGameParametersFactory.instance.getPracticeGameParameters(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
            }
         }
      }
      
      public function set practiceGames(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.practiceGames;
         if(_loc2_ !== param1)
         {
            this._1722593722practiceGames = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceGames",_loc2_,param1));
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

