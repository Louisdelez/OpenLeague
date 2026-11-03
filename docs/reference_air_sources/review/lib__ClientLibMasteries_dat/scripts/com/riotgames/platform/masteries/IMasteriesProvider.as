package com.riotgames.platform.masteries
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   import mx.collections.ArrayCollection;
   
   public interface IMasteriesProvider extends IProvider
   {
      
      function showMasteries(param1:Number, param2:DisplayAdapter, param3:Boolean = false) : void;
      
      function getPagesInfo() : ArrayCollection;
      
      function getPagesInfoUpdated() : ISignal;
      
      function getSelectedPageID() : int;
      
      function setSelectedPageByID(param1:int) : void;
      
      function closeMasteries() : void;
   }
}

