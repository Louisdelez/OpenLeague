package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   
   public class ResolveChampionReassignmentCommand extends CommandBase
   {
      
      private var participantChampionSelections:ParticipantChampionListView;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var inventory:IInventory;
      
      public function ResolveChampionReassignmentCommand(param1:ParticipantChampionListView, param2:ChampionSelectionModel, param3:IInventory)
      {
         super();
         this.participantChampionSelections = param1;
         this.championSelectionModel = param2;
         this.inventory = param3;
      }
      
      private function resolveAssignedChampion(param1:Champion, param2:PlayerChampionSelectionDTO) : void
      {
         var _loc4_:ChampionSkin = null;
         var _loc3_:PlayerSelection = this.championSelectionModel.currentPlayerSelection;
         if(_loc3_.champion == null || param1.championId != _loc3_.champion.championId)
         {
            for each(_loc4_ in param1.championSkins)
            {
               _loc4_.lastSelected = false;
            }
            _loc3_.selectedSkin = param1.defaultSkin;
         }
      }
      
      override public function execute() : void
      {
         var _loc2_:PlayerChampionSelectionDTO = null;
         var _loc3_:Champion = null;
         super.execute();
         if(this.championSelectionModel.championSelectionState != GameState.POST_CHAMPION_SELECTION)
         {
            return;
         }
         var _loc1_:GameTypeConfig = this.championSelectionModel.gameTypeConfig;
         if(_loc1_ == null || !_loc1_.votePickGameTypeConfig)
         {
            return;
         }
         if(this.championSelectionModel.currentPlayerSelection == null || this.championSelectionModel.currentPlayerSelection.participant == null)
         {
            return;
         }
         for each(_loc2_ in this.championSelectionModel.currentGame.playerChampionSelections)
         {
            if(_loc2_.summonerInternalName == this.championSelectionModel.currentPlayerSelection.participant.summonerInternalName)
            {
               _loc3_ = this.getSelectedChampion(_loc2_);
               if(_loc3_ != null)
               {
                  this.resolveAssignedChampion(_loc3_,_loc2_);
               }
               break;
            }
         }
      }
      
      private function getSelectedChampion(param1:PlayerChampionSelectionDTO) : Champion
      {
         var _loc2_:Champion = null;
         var _loc3_:ParticipantChampionSelection = this.participantChampionSelections.getSelectionByChampionId(param1.championId);
         if(_loc3_ != null && _loc3_.champion != null)
         {
            _loc2_ = _loc3_.champion;
         }
         else
         {
            _loc2_ = this.inventory.championIdMapping[param1.championId];
         }
         return _loc2_;
      }
   }
}

