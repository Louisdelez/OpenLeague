package com.riotgames.pvpnet.cap.observers.observable
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   
   public class BaseObservable implements IObserver
   {
      
      private var _occurredSignal:Signal = new Signal();
      
      private var _isOccurring:Boolean;
      
      public function BaseObservable()
      {
         super();
         this._isOccurring = false;
         this.setupSignals();
         this.refresh();
      }
      
      public function destroy() : void
      {
         this.removeSignals();
         this._occurredSignal.removeAll();
      }
      
      public function refresh() : void
      {
         var _loc1_:Boolean = this._isOccurring;
         this._isOccurring = this.determineOccurrance();
         if(_loc1_ != this._isOccurring)
         {
            this._occurredSignal.dispatch();
         }
      }
      
      public function get occurred() : ISignal
      {
         return this._occurredSignal;
      }
      
      public function removeSignals() : void
      {
      }
      
      protected function determineOccurrance() : Boolean
      {
         return false;
      }
      
      public function get isOccurring() : Boolean
      {
         return this._isOccurring;
      }
      
      public function setupSignals() : void
      {
      }
   }
}

