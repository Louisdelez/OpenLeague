package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IStoreProvider extends IProvider
   {
      
      function getCurrentStoreUrl(param1:String = "", param2:String = "") : String;
      
      function getStoreUrlReadyChanged() : ISignal;
      
      function openInventoryBrowser(param1:String, param2:String = "", param3:String = "", param4:Boolean = false) : void;
      
      function getIsStoreAvailable() : Boolean;
      
      function refreshStoreUrl(param1:Boolean = false) : void;
      
      function discardToken() : void;
      
      function getStoreUrlReady() : Boolean;
   }
}

