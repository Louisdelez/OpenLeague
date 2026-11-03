package com.riotgames.pvpnet.login
{
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.ILoginProvider;
   import com.riotgames.platform.common.provider.MainScreenProviderProxy;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.login.ILoginProcessTracker;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleLogin extends Sprite implements ILoginProvider, IProviderModule
   {
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var loginModule:LoginModule;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var loginTracker:ILoginProcessTracker;
      
      public function ClientModuleLogin()
      {
         super();
      }
      
      public function createLoginModule(param1:IContext) : IMainScreen
      {
         this.loginModule = new LoginModule(param1,this._moduleInfo,this.loginTracker);
         return this.loginModule;
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.gotTrackerProvider);
      }
      
      private function gotTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this.loginTracker = param1.getLoginProcessTracker();
         MainScreenProviderProxy.instance.registerMainScreenFactory(this._moduleInfo.getExtraDataValue("mainScreen"),this.createLoginModule);
         ProviderLookup.publishProvider(ILoginProvider,this);
      }
   }
}

