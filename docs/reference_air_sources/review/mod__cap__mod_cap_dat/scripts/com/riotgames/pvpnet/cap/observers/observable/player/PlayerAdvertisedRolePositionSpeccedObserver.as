package com.riotgames.pvpnet.cap.observers.observable.player
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.observers.observable.BaseObservable;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   
   public class PlayerAdvertisedRolePositionSpeccedObserver extends BaseObservable implements IObservable
   {
      
      protected var _playerSelection:CapPlayerSelection;
      
      public function PlayerAdvertisedRolePositionSpeccedObserver(param1:CapPlayerSelection)
      {
         this._playerSelection = param1;
         super();
      }
      
      override public function removeSignals() : void
      {
         this._playerSelection.advertisedRoleChanged.remove(refresh);
         this._playerSelection.positionChanged.remove(refresh);
      }
      
      override public function setupSignals() : void
      {
         this._playerSelection.advertisedRoleChanged.add(refresh);
         this._playerSelection.positionChanged.add(refresh);
      }
      
      override protected function determineOccurrance() : Boolean
      {
         return Boolean(this._playerSelection.advertisedRole) && Boolean(this._playerSelection.position);
      }
   }
}

