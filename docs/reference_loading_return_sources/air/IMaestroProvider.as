package com.riotgames.pvpnet.system.maestro
{
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IMaestroProvider extends IProvider
   {
      
      function start(param1:int) : void;
      
      function stop() : void;
      
      function enableHeartbeatCheck() : void;
      
      function disableHeartbeatCheck() : void;
      
      function createGame(param1:String, param2:String, param3:String, param4:String) : void;
      
      function createObserverGame(param1:String, param2:String, param3:String, param4:String, param5:String) : void;
      
      function createDirectConnectObserverGame(param1:String, param2:String, param3:String, param4:String, param5:String) : void;
      
      function sendChatMessage(param1:String) : void;
      
      function createClientAndPreload(param1:String) : void;
      
      function playPreloadedGame() : void;
      
      function updatePreloadedGameWithCredentials(param1:String, param2:String, param3:String, param4:String) : void;
      
      function killGameClientProcess() : void;
      
      function playbackReplay(param1:String, param2:String) : void;
      
      function installVersion(param1:String) : void;
      
      function requestInstallProgress() : void;
      
      function cancelInstall() : void;
      
      function uninstallVersion(param1:String) : void;
      
      function requestUninstallProgress() : void;
      
      function cancelUninstall() : void;
      
      function installVersionPreview(param1:String) : void;
      
      function requestInstallPreviewProgress() : void;
      
      function cancelInstallPreview() : void;
      
      function uninstallVersionPreview(param1:String) : void;
      
      function requestUninstallPreviewProgress() : void;
      
      function cancelUninstallPreview() : void;
      
      function enumerateGameClientVersions() : void;
      
      function enumerateUninstallableGameClientVersions() : void;
      
      function getLatestGameClientVersions(param1:String) : void;
      
      function getInstalledGameVersionsSizes() : void;
      
      function requestInstalledGameVersionsSizesProgress() : void;
      
      function cancelInstalledGameVersionsSizes() : void;
      
      function getGameCompleted() : ISignal;
      
      function getGameAbandoned() : ISignal;
      
      function getGameCrashed() : ISignal;
      
      function getMaestroHeartbeatErrored() : IOnceSignal;
      
      function getMaestroConnected() : ISignal;
      
      function getMaestroConnectionErrored() : IOnceSignal;
      
      function getGameStarted() : ISignal;
      
      function getGameClientVersionMismatched() : ISignal;
      
      function getGameClientConnectedToServer() : ISignal;
      
      function getUpdatePlayerConnection() : ISignal;
      
      function getGameLoadingComplete() : ISignal;
      
      function get requestCancelled() : Boolean;
   }
}

