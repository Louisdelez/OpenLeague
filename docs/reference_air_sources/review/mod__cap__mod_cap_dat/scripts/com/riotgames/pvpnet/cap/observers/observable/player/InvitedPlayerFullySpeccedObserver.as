package com.riotgames.pvpnet.cap.observers.observable.player
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class InvitedPlayerFullySpeccedObserver extends PlayerFullySpeccedObserver
   {
      
      public function InvitedPlayerFullySpeccedObserver(param1:CapPlayerSelection)
      {
         super(param1);
      }
      
      override protected function determineOccurrance() : Boolean
      {
         return !_playerSelection.isInvitedPlayer || Boolean(super.determineOccurrance());
      }
      
      override public function setupSignals() : void
      {
         super.setupSignals();
         _playerSelection.isInvitedPlayerChanged.add(refresh);
      }
      
      override public function removeSignals() : void
      {
         super.removeSignals();
         _playerSelection.isInvitedPlayerChanged.remove(refresh);
      }
   }
}

