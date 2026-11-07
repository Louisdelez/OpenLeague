package com.riotgames.pvpnet.system.maestro
{
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.event.GameChatEvent;
   import com.riotgames.platform.common.event.GameCrashedEvent;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.services.maestro.MaestroConstants;
   import com.riotgames.platform.gameclient.services.maestro.MaestroEnumerateClientVersionEvent;
   import com.riotgames.platform.gameclient.services.maestro.MaestroGetLatestClientVersionsEvent;
   import com.riotgames.platform.gameclient.services.maestro.MaestroProgressUpdateEvent;
   import com.riotgames.platform.gameclient.services.maestro.MaestroUpdatePlayerConnectionEvent;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class MaestroController implements IMaestroProvider
   {
      
      public static const MAESTRO_CONNECTED:String = "MaestroConnected";
      
      public static const MAESTRO_CONNECTION_ERROR:String = "MaestroConnectionError";
      
      public static const GAME_STARTED:String = "GameStarted";
      
      public static const GAME_COMPLETED:String = "GameCompleted";
      
      public static const GAME_ABANDONED:String = "GameAbandoned";
      
      public static const MAESTRO_HEARTBEAT_ERROR:String = "HeartbeatError";
      
      public static const GAME_CLIENT_VERSION_MISMATCH:String = "GameClientVersionMismatch";
      
      public static const GAME_CLIENT_CONNECTED_TO_SERVER:String = "GameClientConnectedToServer";
      
      public static const INSTALL_PROGRESS_UPDATE:String = "InstallProgressUpdate";
      
      public static const UNINSTALL_PROGRESS_UPDATE:String = "UninstallProgressUpdate";
      
      public static const PREVIEW_PROGRESS_UPDATE:String = "PreviewProgressUpdate";
      
      public static const PREVIEW_UNINSTALL_PROGRESS_UPDATE:String = "PreviewUninstallProgressUpdate";
      
      public static const ENUMERATE_GAME_CLIENT_VERSIONS:String = "EnumerateGameClientVersions";
      
      public static const ENUMERATE_UNINSTALLABLE_GAME_CLIENT_VERSIONS:String = "EnumerateUninstallableGameClientVersions";
      
      public static const UPDATE_PLAYER_CONNECTION:String = "UpdatePlayerConnection";
      
      public static const ENUMERATE_LATEST_GAME_CLIENT_VERSIONS:String = "EnumerateLatestGameClientVersions";
      
      public static const GET_INSTALLED_GAME_CLIENT_VERSIONS_SIZES:String = "GetInstalledGameClientVersionsSizes";
      
      public static const INSTALLED_GAME_CLIENT_VERSIONS_SIZES_PROGRESS_UPDATE:String = "InstalledGameClientVersionsSizesProgressUpdate";
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _gameCompleted:Signal = new Signal();
      
      private var _gameAbandoned:Signal = new Signal();
      
      private var _gameCrashed:Signal = new Signal();
      
      private var _maestroHeartbeatErrored:OnceSignal = new OnceSignal();
      
      private var _maestroConnected:Signal = new Signal();
      
      private var _maestroConnectionErrored:OnceSignal = new OnceSignal();
      
      private var _gameStarted:Signal = new Signal();
      
      private var _gameClientVersionMismatched:Signal = new Signal();
      
      private var _gameClientConnectedToServer:Signal = new Signal();
      
      private var _updatePlayerConnection:Signal = new Signal();
      
      private var _gameLoadingComplete:Signal = new Signal();
      
      private var _requestCancelled:Boolean = false;
      
      public function MaestroController()
      {
         super();
      }
      
      public function start(param1:int) : void
      {
         this.addMessage("Listening On Port: " + param1 + "\n");
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GAMECLIENTSTOPPED_EVENT,this.gameClientCompletedGameSuccessfully);
         this.serviceProxy.maestroService.addEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.gameClientCrashed);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.HEARTBEATFAILED_EVENT,this.heartbeatFailed);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.MAESTROCONNECTED_EVENT,this.connectionSuccessful);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.MAESTROCONNECTIONFAILED_EVENT,this.errorConnecting);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GAME_CLIENT_LAUNCHED,this.onGameClientLaunched);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GAME_CLIENT_ABANDONED,this.onGameClientAbandoned);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GAME_CLIENT_VERSION_MISMATCH,this.onGameClientVersionMismatch);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GAME_CLIENT_CONNECTED_TO_SERVER,this.onGameClientConnectedToServer);
         this.serviceProxy.maestroService.addEventListener(GameChatEvent.CHAT_EVENT_FROM_GAME,this.onGameChatEvent);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.INSTALL_PROGRESS_UPDATE,this.onInstallProgressUpdate);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.UNINSTALL_PROGRESS_UPDATE,this.onUninstallProgressUpdate);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.PREVIEW_PROGRESS_UPDATE,this.onPreviewProgressUpdate);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.PREVIEW_UNINSTALL_PROGRESS_UPDATE,this.onPreviewUninstallProgressUpdate);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.ENUMERATE_GAME_CLIENT_VERSIONS,this.onEnumerateGameClientVersions);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.UPDATE_PLAYER_CONNECTION,this.onUpdatePlayerConnection);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GAME_LOADING_COMPLETE,this.onGameLoadingComplete);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.ENUMERATE_UNINSTALLABLE_GAME_CLIENT_VERSIONS,this.onEnumerateUninstallableGameClientVersions);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.ENUMERATE_LATEST_GAME_CLIENT_VERSIONS,this.onGetLatestGameClientVersions);
         this.serviceProxy.maestroService.addEventListener(MaestroConstants.GET_INSTALLED_GAME_CLIENT_VERSIONS_SIZES_PROGRESS,this.onInstalledVersionsSizesProgressUpdate);
         this.serviceProxy.maestroService.start(param1);
      }
      
      public function stop() : void
      {
         this.addMessage("Sending quit message to maestro.\n");
         this.serviceProxy.maestroService.sendCloseRequest();
      }
      
      public function enableHeartbeatCheck() : void
      {
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.enableHeartbeatCheck();
         }
      }
      
      public function disableHeartbeatCheck() : void
      {
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.disableHeartbeatCheck();
         }
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") function gameClientCompletedGameSuccessfully(param1:Event) : void
      {
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.GAME_COMPLETED));
         this._gameCompleted.dispatch();
      }
      
      private function gameClientAbandoned(param1:Event) : void
      {
         this.addMessage("A game has been abandoned!\n");
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.GAME_ABANDONED));
         this._gameAbandoned.dispatch();
      }
      
      private function gameClientCrashed(param1:GameCrashedEvent) : void
      {
         this.addMessage("A game has crashed!\n");
         this.shellDispatcher.dispatchEvent(new GameCrashedEvent(param1.gamePath));
         this._gameCrashed.dispatch();
      }
      
      private function heartbeatFailed(param1:Event) : void
      {
         this.addMessage("No heartbeat received.\n");
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.MAESTRO_HEARTBEAT_ERROR));
         this._maestroHeartbeatErrored.dispatch();
      }
      
      private function connectionSuccessful(param1:Event) : void
      {
         this.addMessage("First heartbeat.\n");
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.MAESTRO_CONNECTED));
         this._maestroConnected.dispatch();
      }
      
      private function errorConnecting(param1:Event) : void
      {
         this.addMessage("Error Connecting.\n");
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.MAESTRO_CONNECTION_ERROR));
         this._maestroConnectionErrored.dispatch();
      }
      
      private function stopHeartbeat() : void
      {
         this.addMessage("Stopping sending heartbeat.\n");
         this.serviceProxy.maestroService.stopHeartbeat();
      }
      
      public function createGame(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.addMessage("Sending create game message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendCreateGameClientRequest(param1 + " " + param2 + " " + param3 + " " + param4);
         }
      }
      
      public function createObserverGame(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         this.addMessage("Sending create game message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendCreateGameClientRequest("spectator" + " " + param1 + ":" + param2 + " " + param3 + " " + param4 + " " + param5);
         }
      }
      
      public function createDirectConnectObserverGame(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         this.addMessage("Sending create game message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendCreateGameClientRequest("spectator" + " " + param1 + " " + param2 + " " + param3 + " " + param4 + " " + param5);
         }
      }
      
      public function playbackReplay(param1:String, param2:String) : void
      {
         this.addMessage("Sending create game message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            if(ClientConfig.instance.replaySystemStates.backpatchingEnabled)
            {
               this.serviceProxy.maestroService.sendCreateGameClientFromVersionRequest(param2 + " " + param1);
            }
            else
            {
               this.serviceProxy.maestroService.sendCreateGameClientRequest(param1);
            }
         }
      }
      
      public function sendChatMessage(param1:String) : void
      {
         this.addMessage("Sending chat message to game: " + param1);
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendChatMessage(param1);
         }
      }
      
      public function createClientAndPreload(param1:String) : void
      {
         this.addMessage("Sending createClientAndPreload message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendCreateClientAndPreloadRequest(param1);
         }
      }
      
      public function updatePreloadedGameWithCredentials(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.addMessage("Sending start preloaded game message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendUpdatePreloadedGameWithCredentialsMessage(param1 + " " + param2 + " " + param3 + " " + param4);
         }
      }
      
      public function playPreloadedGame() : void
      {
         this.addMessage("Sending play preloaded game message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendPlayPreloadedGameMessage();
         }
      }
      
      public function killGameClientProcess() : void
      {
         this.addMessage("Sending kill game client process request to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.sendKillGameClientProcessRequest();
         }
      }
      
      public function installVersion(param1:String) : void
      {
         this.addMessage("Sending install version message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = false;
            this.serviceProxy.maestroService.installVersion(param1);
         }
      }
      
      public function requestInstallProgress() : void
      {
         this.addMessage("Sending request install progress message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.requestInstallProgress();
         }
      }
      
      public function cancelInstall() : void
      {
         this.addMessage("Sending cancel install message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = true;
            this.serviceProxy.maestroService.cancelInstall();
         }
      }
      
      public function uninstallVersion(param1:String) : void
      {
         this.addMessage("Sending uninstall version message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = false;
            this.serviceProxy.maestroService.uninstallVersion(param1);
         }
      }
      
      public function requestUninstallProgress() : void
      {
         this.addMessage("Sending request uninstall progress message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.requestUninstallProgress();
         }
      }
      
      public function cancelUninstall() : void
      {
         this.addMessage("Sending cancel uninstall message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = true;
            this.serviceProxy.maestroService.cancelUninstall();
         }
      }
      
      public function enumerateGameClientVersions() : void
      {
         this.addMessage("Sending enumerate game client versions message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.enumerateGameClientVersions();
         }
      }
      
      public function getLatestGameClientVersions(param1:String) : void
      {
         this.addMessage("Sending get game client latest versions message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.getLatestGameClientVersions(param1);
         }
      }
      
      public function enumerateUninstallableGameClientVersions() : void
      {
         this.addMessage("Sending enumerate uninstallable game client versions message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.enumerateUninstallableGameClientVersions();
         }
      }
      
      public function installVersionPreview(param1:String) : void
      {
         this.addMessage("Sending install version preview message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = false;
            this.serviceProxy.maestroService.installVersionPreview(param1);
         }
      }
      
      public function requestInstallPreviewProgress() : void
      {
         this.addMessage("Sending request install preview progress message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.requestInstallPreviewProgress();
         }
      }
      
      public function cancelInstallPreview() : void
      {
         this.addMessage("Sending cancel install preview message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = true;
            this.serviceProxy.maestroService.cancelInstallPreview();
         }
      }
      
      public function uninstallVersionPreview(param1:String) : void
      {
         this.addMessage("Sending uninstall version preview message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = false;
            this.serviceProxy.maestroService.uninstallVersionPreview(param1);
         }
      }
      
      public function getInstalledGameVersionsSizes() : void
      {
         this.addMessage("Sending get installed game versions sizes message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = false;
            this.serviceProxy.maestroService.getInstalledGameVersionsSizes();
         }
      }
      
      public function requestInstalledGameVersionsSizesProgress() : void
      {
         this.addMessage("Sending installed game versions sizes progress message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.requestInstalledGameVersionsSizesProgress();
         }
      }
      
      public function cancelInstalledGameVersionsSizes() : void
      {
         this.addMessage("Sending cancel installed game versions sizes message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = true;
            this.serviceProxy.maestroService.cancelInstalledGameVersionsSizes();
         }
      }
      
      public function requestUninstallPreviewProgress() : void
      {
         this.addMessage("Sending request uninstall preview progress message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this.serviceProxy.maestroService.requestUninstallPreviewProgress();
         }
      }
      
      public function cancelUninstallPreview() : void
      {
         this.addMessage("Sending cancel uninstall preview message to maestro.\n");
         if(this.serviceProxy.maestroService != null)
         {
            this._requestCancelled = true;
            this.serviceProxy.maestroService.cancelUninstallPreview();
         }
      }
      
      private function onGameClientLaunched(param1:Event) : void
      {
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.GAME_STARTED));
         this._gameStarted.dispatch();
      }
      
      private function onGameClientAbandoned(param1:Event) : void
      {
         this.gameClientAbandoned(param1);
      }
      
      private function onGameClientVersionMismatch(param1:Event) : void
      {
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.GAME_CLIENT_VERSION_MISMATCH));
         this._gameClientVersionMismatched.dispatch();
      }
      
      private function onGameClientConnectedToServer(param1:Event) : void
      {
         this.shellDispatcher.dispatchEvent(new Event(MaestroController.GAME_CLIENT_CONNECTED_TO_SERVER));
         this._gameClientConnectedToServer.dispatch();
      }
      
      private function onGameChatEvent(param1:GameChatEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new GameChatEvent(param1.chatMessage));
      }
      
      private function onInstallProgressUpdate(param1:MaestroProgressUpdateEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroProgressUpdateEvent(MaestroController.INSTALL_PROGRESS_UPDATE,param1.progress));
      }
      
      private function onUninstallProgressUpdate(param1:MaestroProgressUpdateEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroProgressUpdateEvent(MaestroController.UNINSTALL_PROGRESS_UPDATE,param1.progress));
      }
      
      private function onPreviewProgressUpdate(param1:MaestroProgressUpdateEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroProgressUpdateEvent(MaestroController.PREVIEW_PROGRESS_UPDATE,param1.progress));
      }
      
      private function onInstalledVersionsSizesProgressUpdate(param1:MaestroProgressUpdateEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroProgressUpdateEvent(MaestroController.INSTALLED_GAME_CLIENT_VERSIONS_SIZES_PROGRESS_UPDATE,param1.progress));
      }
      
      private function onPreviewUninstallProgressUpdate(param1:MaestroProgressUpdateEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroProgressUpdateEvent(MaestroController.PREVIEW_UNINSTALL_PROGRESS_UPDATE,param1.progress));
      }
      
      private function onEnumerateGameClientVersions(param1:MaestroEnumerateClientVersionEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroEnumerateClientVersionEvent(MaestroController.ENUMERATE_GAME_CLIENT_VERSIONS,param1.versionsJson));
      }
      
      private function onEnumerateUninstallableGameClientVersions(param1:MaestroEnumerateClientVersionEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroEnumerateClientVersionEvent(MaestroController.ENUMERATE_UNINSTALLABLE_GAME_CLIENT_VERSIONS,param1.versionsJson));
      }
      
      private function onUpdatePlayerConnection(param1:MaestroUpdatePlayerConnectionEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroUpdatePlayerConnectionEvent(MaestroController.UPDATE_PLAYER_CONNECTION,param1._payload));
         this._updatePlayerConnection.dispatch(param1);
      }
      
      private function onGetLatestGameClientVersions(param1:MaestroGetLatestClientVersionsEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new MaestroGetLatestClientVersionsEvent(MaestroController.ENUMERATE_LATEST_GAME_CLIENT_VERSIONS,param1.versionsJson));
      }
      
      private function onGameLoadingComplete(param1:Event) : void
      {
         this._gameLoadingComplete.dispatch();
      }
      
      private function addMessage(param1:String) : void
      {
      }
      
      public function getGameCompleted() : ISignal
      {
         return this._gameCompleted;
      }
      
      public function getGameAbandoned() : ISignal
      {
         return this._gameAbandoned;
      }
      
      public function getGameCrashed() : ISignal
      {
         return this._gameCrashed;
      }
      
      public function getMaestroHeartbeatErrored() : IOnceSignal
      {
         return this._maestroHeartbeatErrored;
      }
      
      public function getMaestroConnected() : ISignal
      {
         return this._maestroConnected;
      }
      
      public function getMaestroConnectionErrored() : IOnceSignal
      {
         return this._maestroConnectionErrored;
      }
      
      public function getGameStarted() : ISignal
      {
         return this._gameStarted;
      }
      
      public function getGameClientVersionMismatched() : ISignal
      {
         return this._gameClientVersionMismatched;
      }
      
      public function getGameClientConnectedToServer() : ISignal
      {
         return this._gameClientConnectedToServer;
      }
      
      public function getUpdatePlayerConnection() : ISignal
      {
         return this._updatePlayerConnection;
      }
      
      public function getGameLoadingComplete() : ISignal
      {
         return this._gameLoadingComplete;
      }
      
      public function get requestCancelled() : Boolean
      {
         return this._requestCancelled;
      }
   }
}

