package com.riotgames.pvpnet.system.maestro
{
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   import blix.signals.SignalPromise;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class MaestroProviderProxy extends ProviderProxyBase implements IMaestroProvider
   {
      
      private static var _instance:IMaestroProvider;
      
      public function MaestroProviderProxy()
      {
         super(IMaestroProvider);
      }
      
      public static function get instance() : IMaestroProvider
      {
         if(_instance == null)
         {
            _instance = new MaestroProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IMaestroProvider) : void
      {
         _instance = param1;
      }
      
      public function start(param1:int) : void
      {
         _invoke("start",[param1]);
      }
      
      public function stop() : void
      {
         _invoke("stop");
      }
      
      public function enableHeartbeatCheck() : void
      {
         _invoke("enableHeartbeatCheck");
      }
      
      public function disableHeartbeatCheck() : void
      {
         _invoke("disableHeartbeatCheck");
      }
      
      public function createGame(param1:String, param2:String, param3:String, param4:String) : void
      {
         _invoke("createGame",[param1,param2,param3,param4]);
      }
      
      public function createObserverGame(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         _invoke("createObserverGame",[param1,param2,param3,param4,param5]);
      }
      
      public function createDirectConnectObserverGame(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         _invoke("createDirectConnectObserverGame",[param1,param2,param3,param4,param5]);
      }
      
      public function sendChatMessage(param1:String) : void
      {
         _invoke("sendChatMessage",[param1]);
      }
      
      public function createClientAndPreload(param1:String) : void
      {
         _invoke("createClientAndPreload",[param1]);
      }
      
      public function updatePreloadedGameWithCredentials(param1:String, param2:String, param3:String, param4:String) : void
      {
         _invoke("updatePreloadedGameWithCredentials",[param1,param2,param3,param4]);
      }
      
      public function playPreloadedGame() : void
      {
         _invoke("playPreloadedGame");
      }
      
      public function killGameClientProcess() : void
      {
         _invoke("killGameClientProcess");
      }
      
      public function playbackReplay(param1:String, param2:String) : void
      {
         _invoke("playbackReplay",[param1,param2]);
      }
      
      public function installVersion(param1:String) : void
      {
         _invoke("installVersion",[param1]);
      }
      
      public function requestInstallProgress() : void
      {
         _invoke("requestInstallProgress");
      }
      
      public function cancelInstall() : void
      {
         _invoke("cancelInstall");
      }
      
      public function uninstallVersion(param1:String) : void
      {
         _invoke("uninstallVersion",[param1]);
      }
      
      public function requestUninstallProgress() : void
      {
         _invoke("requestUninstallProgress");
      }
      
      public function cancelUninstall() : void
      {
         _invoke("cancelUninstall");
      }
      
      public function installVersionPreview(param1:String) : void
      {
         _invoke("installVersionPreview",[param1]);
      }
      
      public function requestInstallPreviewProgress() : void
      {
         _invoke("requestInstallPreviewProgress");
      }
      
      public function cancelInstallPreview() : void
      {
         _invoke("cancelInstallPreview");
      }
      
      public function uninstallVersionPreview(param1:String) : void
      {
         _invoke("uninstallVersionPreview",[param1]);
      }
      
      public function requestUninstallPreviewProgress() : void
      {
         _invoke("requestUninstallPreviewProgress");
      }
      
      public function cancelUninstallPreview() : void
      {
         _invoke("cancelUninstallPreview");
      }
      
      public function enumerateGameClientVersions() : void
      {
         _invoke("enumerateGameClientVersions");
      }
      
      public function enumerateUninstallableGameClientVersions() : void
      {
         _invoke("enumerateUninstallableGameClientVersions");
      }
      
      public function getLatestGameClientVersions(param1:String) : void
      {
         _invoke("getLatestGameClientVersions",[param1]);
      }
      
      public function getInstalledGameVersionsSizes() : void
      {
         _invoke("getInstalledGameVersionsSizes");
      }
      
      public function requestInstalledGameVersionsSizesProgress() : void
      {
         _invoke("requestInstalledGameVersionsSizesProgress");
      }
      
      public function cancelInstalledGameVersionsSizes() : void
      {
         _invoke("cancelInstalledGameVersionsSizes");
      }
      
      public function getGameCompleted() : ISignal
      {
         return _getSignal("getGameCompleted");
      }
      
      public function getGameAbandoned() : ISignal
      {
         return _getSignal("getGameAbandoned");
      }
      
      public function getGameCrashed() : ISignal
      {
         return _getSignal("getGameCrashed");
      }
      
      public function getMaestroHeartbeatErrored() : IOnceSignal
      {
         var _loc1_:SignalPromise = _getSignal("getMaestroHeartbeatErrored") as SignalPromise;
         if(_loc1_ != null)
         {
            return _loc1_.getSignalTarget() as IOnceSignal;
         }
         return null;
      }
      
      public function getMaestroConnected() : ISignal
      {
         return _getSignal("getMaestroConnected");
      }
      
      public function getMaestroConnectionErrored() : IOnceSignal
      {
         var _loc1_:SignalPromise = _getSignal("getMaestroConnectionErrored") as SignalPromise;
         if(_loc1_ != null)
         {
            return _loc1_.getSignalTarget() as IOnceSignal;
         }
         return null;
      }
      
      public function getGameStarted() : ISignal
      {
         return _getSignal("getGameStarted");
      }
      
      public function getGameClientVersionMismatched() : ISignal
      {
         return _getSignal("getGameClientVersionMismatched");
      }
      
      public function getGameClientConnectedToServer() : ISignal
      {
         return _getSignal("getGameClientConnectedToServer");
      }
      
      public function getUpdatePlayerConnection() : ISignal
      {
         return _getSignal("getUpdatePlayerConnection");
      }
      
      public function getGameLoadingComplete() : ISignal
      {
         return _getSignal("getGameLoadingComplete");
      }
      
      public function get requestCancelled() : Boolean
      {
         return _invokeGetter("requestCancelled");
      }
   }
}

