package com.riotgames.pvpnet.game.controllers
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.event.GameCrashedEvent;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.domain.game.GameReconnectionInfo;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.tracking.Dradis;
   import com.riotgames.util.json.jsonDecode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.Capabilities;
   import flash.utils.getQualifiedClassName;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class InGameController implements ICycleViewController, IEventDispatcher
   {
      
      public static const PLAYING_CONNECTED:String = "connected";
      
      public static const PLAYING_DISCONNECTED:String = "disconnected";
      
      public static const PLAYING_CRASHED:String = "crash";
      
      public static const PLAYING_SPECTATOR_DISCONNECT:String = "spectatorDisconnected";
      
      [Inject]
      public var spectatorController:SpectatorController;
      
      public var applicationController:IAppController;
      
      public var masterGameController:MasterGameController;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var _1457822360currentState:String = "connected";
      
      private var _1180619197isBusy:Boolean = false;
      
      private var isInitialized:Boolean;
      
      private var proxiedOnError:Function;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var reconnectInfo:GameReconnectionInfo = null;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function InGameController()
      {
         super();
      }
      
      public function initialize() : void
      {
         if(this.isInitialized)
         {
            return;
         }
         this.isInitialized = true;
      }
      
      public function initializeCycle() : void
      {
      }
      
      public function abortCycle() : void
      {
      }
      
      public function cleanup() : void
      {
      }
      
      public function cleanupCycle() : void
      {
      }
      
      public function activate() : void
      {
         AppConfig.instance.isNavigatorVisible = false;
         this.shellDispatcher.addEventListener(MaestroController.GAME_STARTED,this.onGameStarted);
         this.shellDispatcher.addEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.onGameCrashed);
         this.shellDispatcher.addEventListener(MaestroController.GAME_ABANDONED,this.onGameAbandoned);
      }
      
      public function deactivate() : void
      {
         this.currentState == InGameController.PLAYING_CONNECTED;
         this.isBusy = false;
         this.proxiedOnError = null;
         this.shellDispatcher.removeEventListener(MaestroController.GAME_STARTED,this.onGameStarted);
         this.shellDispatcher.removeEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.onGameCrashed);
         this.shellDispatcher.removeEventListener(MaestroController.GAME_ABANDONED,this.onGameAbandoned);
      }
      
      public function setDisconnected() : void
      {
         this.currentState = this.masterGameController.isSpectating ? PLAYING_SPECTATOR_DISCONNECT : PLAYING_DISCONNECTED;
      }
      
      public function reconnectToGame(param1:Function) : void
      {
         this.proxiedOnError = param1;
         if(this.masterGameController.isSpectating)
         {
            this.reconnectInfo = this.spectatorController.getReconnectInfo();
         }
         if(this.reconnectInfo == null)
         {
            this.getReconnectionInfo();
         }
         else
         {
            this.masterGameController.reconnectToGame(this.reconnectInfo.game,this.reconnectInfo.playerCredentials,0);
         }
      }
      
      private function getReconnectionInfo() : void
      {
         this.isBusy = true;
         this.serviceProxy.gameService.getGameReconnectionInfo(this.onGetGameReconnectionInfoSuccess,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function cancelGameFlow() : void
      {
         this.reconnectInfo = null;
         this.masterGameController.cancelGameFlow();
      }
      
      public function stopSpectating() : void
      {
         this.serviceProxy.gameService.declineObserverReconnect(null,this.onServiceRequestComplete,this.onServiceRequestError);
         this.cancelGameFlow();
      }
      
      private function onGetGameReconnectionInfoSuccess(param1:ResultEvent) : void
      {
         var _loc2_:ServerError = null;
         this.reconnectInfo = param1.result as GameReconnectionInfo;
         if(this.reconnectInfo == null)
         {
            if(this.proxiedOnError != null)
            {
               _loc2_ = new ServerError(null);
               _loc2_.errorCode = MessageDictionary.GAME_NO_LONGER_IN_PROGRESS;
               _loc2_.messageArguments = [];
               this.onServiceRequestError(_loc2_);
               return;
            }
         }
         this.masterGameController.reconnectToGame(this.reconnectInfo.game,this.reconnectInfo.playerCredentials,0);
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.isBusy = false;
         this.proxiedOnError = null;
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
         }
         this.proxiedOnError = null;
      }
      
      private function onGameStarted(param1:Event) : void
      {
         this.reconnectInfo = null;
         this.currentState = InGameController.PLAYING_CONNECTED;
      }
      
      private function onGameCrashed(param1:GameCrashedEvent) : void
      {
         var reportObj:Object;
         var filePath:String = null;
         var file:File = null;
         var fileStream:FileStream = null;
         var event:GameCrashedEvent = param1;
         var gameId:String = this.masterGameController.currentGame.id.toString();
         while(gameId.length < 16)
         {
            gameId = "0" + gameId;
         }
         reportObj = null;
         filePath = event.gamePath + gameId + "_crash.json";
         this.logger.debug("onGameCrashed: Trying to read crash data from: " + filePath);
         try
         {
            file = new File(filePath);
         }
         catch(e:Error)
         {
            logger.error("onGameCrashed: Error when reading file: " + filePath + " - " + e.message);
         }
         if(Boolean(file) && Boolean(file.exists))
         {
            try
            {
               fileStream = new FileStream();
               fileStream.open(file,FileMode.READ);
               reportObj = jsonDecode(fileStream.readUTFBytes(file.size));
               fileStream.close();
            }
            catch(e:Error)
            {
               logger.error("Failed to read detailed crash information.");
            }
            file.deleteFileAsync();
         }
         if(!reportObj)
         {
            reportObj = new Object();
         }
         reportObj["locale_country"] = ClientConfig.instance.currentLocale.country;
         reportObj["locale_language"] = ClientConfig.instance.currentLocale.language;
         reportObj["region_tag"] = ClientConfig.instance.regionTag;
         reportObj["client_os"] = Capabilities.os;
         Dradis.track("event_gameCrashed",reportObj);
         this.handleGameEarlyTermination(event);
      }
      
      private function onGameAbandoned(param1:Event) : void
      {
         this.handleGameEarlyTermination(param1);
      }
      
      private function handleGameEarlyTermination(param1:Event) : void
      {
         if(this.masterGameController.isLastPlayedGameTypeTutorial)
         {
            this.cancelGameFlow();
         }
         else if(this.masterGameController.isSpectating)
         {
            this.currentState = PLAYING_SPECTATOR_DISCONNECT;
         }
         else if(param1.type == GameCrashedEvent.CRASHED_EVENT_FROM_GAME)
         {
            this.currentState = PLAYING_CRASHED;
         }
         else
         {
            this.currentState = PLAYING_DISCONNECTED;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentState() : String
      {
         return this._1457822360currentState;
      }
      
      public function set currentState(param1:String) : void
      {
         var _loc2_:Object = this._1457822360currentState;
         if(_loc2_ !== param1)
         {
            this._1457822360currentState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentState",_loc2_,param1));
            }
         }
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

