package com.riotgames.pvpnet.championinventory
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.MainScreenProviderProxy;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.championinventory.views.ChampionInventoryRootView;
   import flash.display.Sprite;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleChampionInventory extends Sprite implements IProviderModule, IChampionInventoryProvider
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _inventoryRootView:ChampionInventoryRootView;
      
      public function ClientModuleChampionInventory()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.publishProvider(IChampionInventoryProvider,this);
         MainScreenProviderProxy.instance.registerMainScreenFactory(param1.getExtraDataValue("mainScreen"),this.getChampionInventoryScreen);
      }
      
      public function getChampionInventoryScreen(param1:IContext) : IMainScreen
      {
         if(this._inventoryRootView == null)
         {
            this._inventoryRootView = new ChampionInventoryRootView(param1,this._moduleInfo);
         }
         return this._inventoryRootView;
      }
      
      public function show(param1:Number, param2:DisplayAdapter) : void
      {
         var _loc3_:ChampionInventoryRootView = this.getChampionInventoryScreen(null) as ChampionInventoryRootView;
         _loc3_.show();
         param2.addChild(_loc3_);
      }
      
      public function hide() : void
      {
         this._inventoryRootView.hide();
      }
   }
}

