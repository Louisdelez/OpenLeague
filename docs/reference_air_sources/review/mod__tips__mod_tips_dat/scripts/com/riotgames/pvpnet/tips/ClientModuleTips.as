package com.riotgames.pvpnet.tips
{
   import blix.action.IAction;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import flash.display.Sprite;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleTips extends Sprite implements IProviderModule
   {
      
      private var _tipsProvider:TipsProvider;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      public function ClientModuleTips()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this._tipsProvider = new TipsProvider();
         this._tipsProvider.setModuleInfo(param1);
         ProviderLookup.publishProvider(ITipsProvider,this._tipsProvider);
         this.loadLocalization();
      }
      
      private function loadLocalization() : void
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"Tips","Tips","tips",ClientConfig.instance.debugLocale);
         _loc3_.invoke();
      }
   }
}

