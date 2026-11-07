package com.riotgames.pvpnet.cap.observers
{
   import com.riotgames.pvpnet.cap.controllers.CapMmaController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class MmaObserver implements IObserver
   {
      
      private var _playerSelection:CapPlayerSelection;
      
      private var _mmaController:CapMmaController;
      
      public function MmaObserver(param1:CapPlayerSelection, param2:CapMmaController)
      {
         super();
         this._playerSelection = param1;
         this._mmaController = param2;
      }
      
      private function onChampionChanged() : void
      {
         this._playerSelection.mmaBonus.championBonusActive = this._mmaController.isChampionBonusActive(this._playerSelection.champion);
      }
      
      public function removeSignals() : void
      {
         this._playerSelection.championChanged.remove(this.onChampionChanged);
         this._playerSelection.roleChanged.remove(this.onRoleChanged);
         this._playerSelection.positionChanged.remove(this.onPositionChanged);
      }
      
      private function onPositionChanged() : void
      {
         this._playerSelection.mmaBonus.positionBonusActive = this._mmaController.isPositionBonusActive(this._playerSelection.position);
      }
      
      public function destroy() : void
      {
         this.removeSignals();
      }
      
      public function refresh() : void
      {
         this.onChampionChanged();
         this.onPositionChanged();
         this.onRoleChanged();
      }
      
      public function setupSignals() : void
      {
         this._playerSelection.championChanged.add(this.onChampionChanged);
         this._playerSelection.roleChanged.add(this.onRoleChanged);
         this._playerSelection.positionChanged.add(this.onPositionChanged);
      }
      
      private function onRoleChanged() : void
      {
         this._playerSelection.mmaBonus.roleBonusActive = this._mmaController.isRoleBonusActive(this._playerSelection.role);
      }
   }
}

