package com.riotgames.championdetails
{
   import blix.signals.ISignal;
   import com.riotgames.store.model.CatalogResult;
   
   public interface IChampionDetailsContext extends ITrackingContext
   {
      
      function getCatalogResultChanged() : ISignal;
      
      function getCatalogResult() : CatalogResult;
      
      function getConfig() : CDPConfig;
      
      function getServices() : CDPServices;
      
      function close() : void;
      
      function displayUserError(param1:String, param2:Function = null) : void;
   }
}

