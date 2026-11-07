package com.riotgames.pvpnet.cap.observers.observable.player
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.observers.observable.BaseObservable;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   
   public class PlayerRolePositionSpeccedObserver extends BaseObservable implements IObservable
   {
      
      protected var _playerSelection:CapPlayerSelection;
      
      public function PlayerRolePositionSpeccedObserver(param1:CapPlayerSelection)
      {
         this._playerSelection = param1;
         super();
      }
      
      override public function removeSignals() : void
      {
         this._playerSelection.roleChanged.remove(refresh);
         this._playerSelection.positionChanged.remove(refresh);
      }
      
      override public function setupSignals() : void
      {
         this._playerSelection.roleChanged.add(refresh);
         this._playerSelection.positionChanged.add(refresh);
      }
      
      override protected function determineOccurrance() : Boolean
      {
         return Boolean(this._playerSelection.role) && Boolean(this._playerSelection.position);
      }
   }
}

