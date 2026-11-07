package com.riotgames.pvpnet.cap.observers.observable.group
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapPlayerPresenceObserver implements IObservable, IDestructible
   {
      
      private var _occurred:Signal = new Signal();
      
      private var _playerAddedToGroup:Signal = new Signal();
      
      private var _playerRemovedFromGroup:Signal = new Signal();
      
      private var _actionFactory:ICapActionFactory;
      
      private var _model:CapModel;
      
      public function CapPlayerPresenceObserver(param1:ICapActionFactory, param2:CapModel)
      {
         super();
         this._actionFactory = param1;
         this._model = param2;
      }
      
      public function setupSignals() : void
      {
         var _loc2_:CapPlayerSelection = null;
         var _loc1_:Array = CapModelUtil.getAllAvailablePlayerSelections(this._model);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.isPopulatedChanged.add(this.onSlotPopulatedChanged);
         }
         this._playerAddedToGroup.dispatch(this._occurred.dispatch);
         this._playerRemovedFromGroup.dispatch(this._occurred.dispatch);
      }
      
      public function get isOccurring() : Boolean
      {
         return false;
      }
      
      public function refresh() : void
      {
      }
      
      public function get playerAddedToGroup() : ISignal
      {
         return this._playerAddedToGroup;
      }
      
      public function removeSignals() : void
      {
         var _loc2_:CapPlayerSelection = null;
         var _loc1_:Array = CapModelUtil.getAllAvailablePlayerSelections(this._model);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.isPopulatedChanged.remove(this.onSlotPopulatedChanged);
         }
      }
      
      public function get occurred() : ISignal
      {
         return this._occurred;
      }
      
      public function get playerRemovedFromGroup() : ISignal
      {
         return this._playerRemovedFromGroup;
      }
      
      private function onSlotPopulatedChanged(param1:CapPlayerSelection) : void
      {
         if(param1.isPopulated)
         {
            this._playerAddedToGroup.dispatch(param1);
         }
         else
         {
            this._playerRemovedFromGroup.dispatch(param1);
         }
      }
      
      public function destroy() : void
      {
         this.removeSignals();
         this._playerAddedToGroup.removeAll();
         this._playerRemovedFromGroup.removeAll();
         this._occurred.removeAll();
      }
   }
}

