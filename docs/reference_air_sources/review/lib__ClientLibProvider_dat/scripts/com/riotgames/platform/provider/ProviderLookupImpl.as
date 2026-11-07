package com.riotgames.platform.provider
{
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.utils.Dictionary;
   
   public class ProviderLookupImpl implements IProviderLookup
   {
      
      private var _providerPublished:Signal = new Signal();
      
      private var _providerFailed:Signal = new Signal();
      
      private var _providerRequested:Signal = new Signal();
      
      private var _providerLookupEntries:Dictionary = new Dictionary(true);
      
      public function ProviderLookupImpl()
      {
         super();
      }
      
      public function publishProvider(param1:String, param2:IProvider) : void
      {
         this._providerPublished.dispatch(param1,param2);
         this.getProviderLookupEntry(param1).publish(param2);
      }
      
      public function getProviderPublished() : ISignal
      {
         return this._providerPublished;
      }
      
      public function getSpecificProviderPublished(param1:String) : IOnceSignal
      {
         return this.getProviderLookupEntry(param1).getPublished();
      }
      
      public function failProvider(param1:String, param2:Error) : void
      {
         this._providerFailed.dispatch(param1,param2);
         this.getProviderLookupEntry(param1).fail(param2);
      }
      
      public function getProviderFailed() : ISignal
      {
         return this._providerFailed;
      }
      
      public function getSpecificProviderFailed(param1:String) : IOnceSignal
      {
         return this.getProviderLookupEntry(param1).getFailed();
      }
      
      public function requestProvider(param1:String) : void
      {
         this._providerRequested.dispatch(param1);
         this.getProviderLookupEntry(param1).request();
      }
      
      public function getProviderRequested() : ISignal
      {
         return this._providerRequested;
      }
      
      public function getSpecificProviderRequested(param1:String) : IOnceSignal
      {
         return this.getProviderLookupEntry(param1).getRequested();
      }
      
      protected function getProviderLookupEntry(param1:String) : ProviderLookupEntry
      {
         if(!(param1 in this._providerLookupEntries))
         {
            this._providerLookupEntries[param1] = new ProviderLookupEntry();
         }
         return this._providerLookupEntries[param1];
      }
   }
}

