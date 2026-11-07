package com.riotgames.pvpnet.cap.observers.observable.player
{
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class PlayerFullySpeccedObserver extends PlayerRolePositionSpeccedObserver
   {
      
      public function PlayerFullySpeccedObserver(param1:CapPlayerSelection)
      {
         super(param1);
      }
      
      override protected function determineOccurrance() : Boolean
      {
         return super.determineOccurrance() && _playerSelection.isPopulated && _playerSelection.champion && Boolean(_playerSelection.spell1) && Boolean(_playerSelection.spell2);
      }
      
      override public function setupSignals() : void
      {
         super.setupSignals();
         _playerSelection.isPopulatedChanged.add(refresh);
         _playerSelection.championChanged.add(refresh);
         _playerSelection.spell1Changed.add(refresh);
         _playerSelection.spell2Changed.add(refresh);
      }
      
      override public function removeSignals() : void
      {
         super.removeSignals();
         _playerSelection.isPopulatedChanged.remove(refresh);
         _playerSelection.championChanged.remove(refresh);
         _playerSelection.spell1Changed.remove(refresh);
         _playerSelection.spell2Changed.remove(refresh);
      }
   }
}

