package com.riotgames.platform.gameclient.services.maestro
{
   import flash.events.IEventDispatcher;
   
   public interface MaestroService extends IEventDispatcher
   {
      
      function cancelInstall() : void;
      
      function requestUninstallPreviewProgress() : void;
      
      function sendKillGameClientProcessRequest() : void;
      
      function fireMaestroMessage(param1:MaestroMessage) : void;
      
      function cancelInstallPreview() : void;
      
      function cancelUninstall() : void;
      
      function installVersionPreview(param1:String) : void;
      
      function requestInstalledGameVersionsSizesProgress() : void;
      
      function enableHeartbeatCheck() : void;
      
      function getInstalledGameVersionsSizes() : void;
      
      function uninstallVersionPreview(param1:String) : void;
      
      function uninstallVersion(param1:String) : void;
      
      function requestInstallProgress() : void;
      
      function stopHeartbeat() : void;
      
      function enumerateGameClientVersions() : void;
      
      function sendCloseRequest() : void;
      
      function requestUninstallProgress() : void;
      
      function start(param1:int) : void;
      
      function cancelInstalledGameVersionsSizes() : void;
      
      function sendChatMessage(param1:String) : void;
      
      function sendPlayPreloadedGameMessage() : void;
      
      function sendCreateClientAndPreloadRequest(param1:String) : void;
      
      function cancelUninstallPreview() : void;
      
      function requestInstallPreviewProgress() : void;
      
      function sendCreateGameClientFromVersionRequest(param1:String) : void;
      
      function disableHeartbeatCheck() : void;
      
      function sendCreateGameClientRequest(param1:String) : void;
      
      function enumerateUninstallableGameClientVersions() : void;
      
      function sendUpdatePreloadedGameWithCredentialsMessage(param1:String) : void;
      
      function getLatestGameClientVersions(param1:String) : void;
      
      function installVersion(param1:String) : void;
   }
}

