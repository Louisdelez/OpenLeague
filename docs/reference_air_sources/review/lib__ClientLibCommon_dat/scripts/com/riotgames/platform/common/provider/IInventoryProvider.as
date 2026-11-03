package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IInventoryProvider extends IProvider
   {
      
      function getInventoryController() : IInventoryController;
      
      function getInventoryInitialized() : ISignal;
      
      function getInventory() : IInventory;
   }
}

