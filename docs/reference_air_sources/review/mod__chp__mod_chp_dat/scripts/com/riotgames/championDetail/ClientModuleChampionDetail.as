package com.riotgames.championDetail
{
   import com.riotgames.championdetails.Main;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import flash.display.Sprite;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleChampionDetail extends Sprite implements IProviderModule
   {
      
      protected var resourceManager:IResourceManager;
      
      public var CHAMPION_DETAILS_RESOURCE_ID:String;
      
      private var loadModuleResourceBundleAction:LoadModuleResourceBundleAction;
      
      public function ClientModuleChampionDetail()
      {
         this.CHAMPION_DETAILS_RESOURCE_ID = Main.CHAMPION_DETAILS_RESOURCE_ID;
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         var _loc2_:String = ClientConfig.instance.locale;
         var _loc3_:Boolean = Boolean(ClientConfig.instance.debugLocale);
         this.resourceManager = ResourceManager.getInstance();
         this.loadModuleResourceBundleAction = new LoadModuleResourceBundleAction(this.resourceManager,_loc2_,"ChampionDetails","ChampionDetails","chp",_loc3_);
         this.loadModuleResourceBundleAction.getCompleted().add(this.onResourceManagerChange);
         this.loadModuleResourceBundleAction.invoke();
      }
      
      private function onResourceManagerChange() : void
      {
         ProviderLookup.publishProvider(IChampionDetailProvider,new ChampionDetailProvider());
      }
   }
}

