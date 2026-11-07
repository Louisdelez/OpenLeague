package com.riotgames.platform.provider
{
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   
   public interface IProviderLookup
   {
      
      function publishProvider(param1:String, param2:IProvider) : void;
      
      function getProviderPublished() : ISignal;
      
      function getSpecificProviderPublished(param1:String) : IOnceSignal;
      
      function failProvider(param1:String, param2:Error) : void;
      
      function getProviderFailed() : ISignal;
      
      function getSpecificProviderFailed(param1:String) : IOnceSignal;
      
      function requestProvider(param1:String) : void;
      
      function getProviderRequested() : ISignal;
      
      function getSpecificProviderRequested(param1:String) : IOnceSignal;
   }
}

