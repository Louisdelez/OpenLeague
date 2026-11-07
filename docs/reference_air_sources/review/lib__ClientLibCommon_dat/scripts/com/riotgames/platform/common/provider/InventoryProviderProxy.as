package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class InventoryProviderProxy extends ProviderProxyBase implements IInventoryProvider
   {
      
      private static var _instance:IInventoryProvider;
      
      public function InventoryProviderProxy()
      {
         super(IInventoryProvider);
      }
      
      public static function get instance() : IInventoryProvider
      {
         if(_instance == null)
         {
            _instance = new InventoryProviderProxy();
         }
         return _instance;
      }
      
      public function getInventoryController() : IInventoryController
      {
         return _invoke("getInventoryController") as IInventoryController;
      }
      
      public function getInventory() : IInventory
      {
         return _invoke("getInventory") as IInventory;
      }
      
      public function getInventoryInitialized() : ISignal
      {
         return _getSignal("getInventoryInitialized");
      }
   }
}

