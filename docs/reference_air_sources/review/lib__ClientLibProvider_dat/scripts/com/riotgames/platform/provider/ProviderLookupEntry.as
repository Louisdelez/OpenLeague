package com.riotgames.platform.provider
{
   import blix.signals.IOnceSignal;
   import blix.signals.OnceSignal;
   
   public class ProviderLookupEntry
   {
      
      private var _requested:OnceSignal = new OnceSignal();
      
      private var _published:OnceSignal = new OnceSignal();
      
      private var _failed:OnceSignal = new OnceSignal();
      
      public function ProviderLookupEntry()
      {
         super();
      }
      
      public function getRequested() : IOnceSignal
      {
         return this._requested;
      }
      
      public function getPublished() : IOnceSignal
      {
         return this._published;
      }
      
      public function getFailed() : IOnceSignal
      {
         return this._failed;
      }
      
      public function request() : void
      {
         this._requested.dispatch();
      }
      
      public function publish(param1:IProvider) : void
      {
         if(this._failed.getHasDispatched())
         {
            throw new Error("Cannot publish after fail.");
         }
         this._failed.removeAll();
         this._published.dispatch(param1);
      }
      
      public function fail(param1:Error) : void
      {
         if(this._published.getHasDispatched())
         {
            throw new Error("Cannot fail after publish.");
         }
         this._published.removeAll();
         this._failed.dispatch(param1);
      }
   }
}

