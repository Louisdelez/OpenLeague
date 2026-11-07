package com.riotgames.pvpnet.cap.observers.group
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   
   public class BaseGroupObserver implements IObserver
   {
      
      protected var _model:CapModel;
      
      protected var _signalHandlers:Array = [];
      
      public function BaseGroupObserver(param1:CapModel)
      {
         super();
         this._model = param1;
      }
      
      public function refresh() : void
      {
      }
      
      protected function onPropertyChange(param1:CapPlayerSelection) : void
      {
         throw new Error("Abstract");
      }
      
      protected function createSignalHandler(param1:CapPlayerSelection, param2:Array) : void
      {
         this._signalHandlers.push(new CapPlayerSelectionSignalsHandler(this,param1,param2,this.onPropertyChange));
      }
      
      public function removeSignals() : void
      {
         var _loc1_:CapPlayerSelectionSignalsHandler = null;
         for each(_loc1_ in this._signalHandlers)
         {
            _loc1_.destroy();
         }
         this._signalHandlers.splice(0);
      }
      
      public function setupSignals() : void
      {
         throw new Error("Abstract");
      }
      
      public function destroy() : void
      {
         this.removeSignals();
      }
   }
}

import blix.IDestructible;
import blix.signals.ISignal;
import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
import com.riotgames.pvpnet.cap.observers.group.BaseGroupObserver;

class CapPlayerSelectionSignalsHandler implements IDestructible
{
   
   private var _target:BaseGroupObserver;
   
   private var _playerSelection:CapPlayerSelection;
   
   private var _callback:Function;
   
   private var _signals:Array;
   
   public function CapPlayerSelectionSignalsHandler(param1:BaseGroupObserver, param2:CapPlayerSelection, param3:Array, param4:Function)
   {
      var _loc5_:ISignal = null;
      super();
      this._target = param1;
      this._playerSelection = param2;
      this._signals = param3;
      this._callback = param4;
      for each(_loc5_ in this._signals)
      {
         _loc5_.add(this.onSignalInvoked);
      }
   }
   
   public function destroy() : void
   {
      var _loc1_:ISignal = null;
      for each(_loc1_ in this._signals)
      {
         _loc1_.remove(this.onSignalInvoked);
      }
   }
   
   public function onSignalInvoked() : void
   {
      this._callback.call(this._target,this._playerSelection);
   }
}
