package com.riotgames.pvpnet.cap.observers
{
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class ClassicChampionAvailableObserver implements IObserver
   {
      
      private var _lastChampion:Champion;
      
      private var _playerSelection:CapPlayerSelection;
      
      private var _availableParticpantChampionSelections:ParticipantChampionListView;
      
      public function ClassicChampionAvailableObserver(param1:CapPlayerSelection, param2:ParticipantChampionListView)
      {
         super();
         this._playerSelection = param1;
         this._availableParticpantChampionSelections = param2;
      }
      
      private function onChampionChanged() : void
      {
         this.removeChampionSelection(this._lastChampion);
         this._lastChampion = this._playerSelection.champion;
         this.addChampionSelection(this._lastChampion);
      }
      
      public function removeSignals() : void
      {
         this._playerSelection.championChanged.remove(this.onChampionChanged);
      }
      
      private function addChampionSelection(param1:Champion) : void
      {
         var _loc2_:ParticipantChampionSelection = null;
         var _loc3_:GameParticipant = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in this._availableParticpantChampionSelections)
         {
            if(_loc2_.champion == param1)
            {
               _loc3_ = new GameParticipant();
               _loc3_.isMe = this._playerSelection.isLocalPlayer;
               _loc3_.summonerName = this._playerSelection.summonerName;
               _loc3_.isGameOwner = this._playerSelection.isCaptain;
               _loc2_.participant = _loc3_;
               break;
            }
         }
      }
      
      public function setupSignals() : void
      {
         this._playerSelection.championChanged.add(this.onChampionChanged);
      }
      
      public function destroy() : void
      {
         this.removeSignals();
      }
      
      public function refresh() : void
      {
         this.onChampionChanged();
      }
      
      private function removeChampionSelection(param1:Champion) : void
      {
         var _loc2_:Champion = null;
         var _loc3_:ParticipantChampionSelection = null;
         if(!param1)
         {
            return;
         }
         for each(_loc2_ in this._availableParticpantChampionSelections.source)
         {
            _loc3_ = this._availableParticpantChampionSelections.getSelectionByChampion(param1);
            if(_loc2_ == param1)
            {
               _loc3_.participant = null;
               return;
            }
         }
      }
   }
}

