package com.riotgames.pvpnet.chrome
{
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleChrome extends Sprite implements IProviderModule
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      public function ClientModuleChrome()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.getProvider(IWindowControlsProvider,this.onGotWindowControls);
      }
      
      private function onGotWindowControls(param1:IWindowControlsProvider) : void
      {
         var _loc2_:ChromeFactory = new ChromeFactory(null,this._moduleInfo,param1);
         ProviderLookup.publishProvider(IChromeProvider,_loc2_);
      }
   }
}

