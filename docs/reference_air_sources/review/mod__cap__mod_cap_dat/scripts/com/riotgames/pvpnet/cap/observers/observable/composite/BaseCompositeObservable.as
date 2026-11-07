package com.riotgames.pvpnet.cap.observers.observable.composite
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.cap.observers.observable.ICapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import mx.collections.ArrayCollection;
   
   public class BaseCompositeObservable implements ICompositeObservable
   {
      
      private var _playerSelections:ArrayCollection;
      
      private var _occurredSignal:Signal = new Signal();
      
      private var _isOccurring:Boolean;
      
      private var _observeableFactory:ICapObservableFactory;
      
      private var _observers:ArrayCollection = new ArrayCollection();
      
      public function BaseCompositeObservable(param1:ArrayCollection, param2:ICapObservableFactory)
      {
         super();
         this._playerSelections = param1;
         this._observeableFactory = param2;
         this.createObservers(this._observers,this._playerSelections);
      }
      
      protected function createObservers(param1:ArrayCollection, param2:ArrayCollection) : void
      {
      }
      
      private function destroyObservers() : void
      {
         var _loc1_:IObservable = null;
         for each(_loc1_ in this._observers.source)
         {
            _loc1_.destroy();
         }
      }
      
      public function get isOccurring() : Boolean
      {
         return this._isOccurring;
      }
      
      public function setupSignals() : void
      {
         var _loc1_:IObservable = null;
         for each(_loc1_ in this._observers.source)
         {
            _loc1_.occurred.add(this.refresh);
         }
      }
      
      protected function get observableFactory() : ICapObservableFactory
      {
         return this._observeableFactory;
      }
      
      public function refresh() : void
      {
         var _loc3_:IObservable = null;
         var _loc1_:Boolean = this._isOccurring;
         var _loc2_:Boolean = this._observers.length > 0;
         for each(_loc3_ in this._observers.source)
         {
            _loc3_.refresh();
            _loc2_ &&= _loc3_.isOccurring;
         }
         this._isOccurring = _loc2_;
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
         var _loc1_:IObservable = null;
         for each(_loc1_ in this._observers.source)
         {
            _loc1_.occurred.remove(this.refresh);
         }
      }
      
      public function destroy() : void
      {
         this.removeSignals();
         this.destroyObservers();
         this._occurredSignal.removeAll();
      }
      
      public function rebuild() : void
      {
         this.destroyObservers();
         this._observers.removeAll();
         this.createObservers(this._observers,this._playerSelections);
         this.setupSignals();
         this.refresh();
      }
   }
}

