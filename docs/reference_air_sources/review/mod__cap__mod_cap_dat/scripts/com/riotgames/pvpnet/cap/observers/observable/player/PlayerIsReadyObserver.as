package com.riotgames.pvpnet.cap.observers.observable.player
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.observers.observable.BaseObservable;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   
   public class PlayerIsReadyObserver extends BaseObservable implements IObservable
   {
      
      protected var _playerSelection:CapPlayerSelection;
      
      public function PlayerIsReadyObserver(param1:CapPlayerSelection)
      {
         this._playerSelection = param1;
         super();
      }
      
      override public function removeSignals() : void
      {
         this._playerSelection.isReadyChanged.remove(refresh);
      }
      
      override public function setupSignals() : void
      {
         this._playerSelection.isReadyChanged.add(refresh);
      }
      
      override protected function determineOccurrance() : Boolean
      {
         return this._playerSelection.isReady;
      }
   }
}

