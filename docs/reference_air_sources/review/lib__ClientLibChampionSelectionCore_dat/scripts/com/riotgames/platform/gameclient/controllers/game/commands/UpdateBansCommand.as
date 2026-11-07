package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.BannedChampion;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   import mx.collections.ArrayCollection;
   
   public class UpdateBansCommand extends CommandBase
   {
      
      private var isSpectating:Boolean;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var enemyBansList:ArrayCollection;
      
      private var friendlyBansList:ArrayCollection;
      
      private var game:GameDTO;
      
      public function UpdateBansCommand(param1:GameDTO, param2:ArrayCollection, param3:ArrayCollection, param4:ChampionSelectionModel, param5:Boolean)
      {
         super();
         this.game = param1;
         this.friendlyBansList = param2;
         this.enemyBansList = param3;
         this.championSelectionModel = param4;
         this.isSpectating = param5;
      }
      
      private function includeBan(param1:int, param2:ArrayCollection) : void
      {
         var _loc3_:Champion = null;
         var _loc4_:Champion = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.championId == param1)
            {
               return;
            }
         }
         _loc4_ = InventoryProviderProxy.instance.getInventory().championIdMapping[param1];
         if(_loc4_ != null)
         {
            param2.addItem(_loc4_);
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateBannedChampionStates();
         onComplete();
         onResult();
      }
      
      private function updateBannedChampionStates() : void
      {
         var _loc1_:BannedChampion = null;
         var _loc2_:Boolean = false;
         var _loc3_:ParticipantChampionSelection = null;
         for each(_loc1_ in this.game.bannedChampions)
         {
            if(this.isSpectating)
            {
               this.includeBan(_loc1_.championId,_loc1_.teamId == Team.TEAM_ID_BLUE ? this.friendlyBansList : this.enemyBansList);
            }
            else
            {
               _loc2_ = this.championSelectionModel.currentTeamName == Team.TEAM_BLUE && _loc1_.teamId == Team.TEAM_ID_BLUE || this.championSelectionModel.currentTeamName == Team.TEAM_PURPLE && _loc1_.teamId == Team.TEAM_ID_PURPLE;
               this.includeBan(_loc1_.championId,_loc2_ ? this.friendlyBansList : this.enemyBansList);
            }
         }
         for each(_loc1_ in this.game.bannedChampions)
         {
            _loc3_ = this.championSelectionModel.championSelections.getSelectionByChampionId(_loc1_.championId);
            if(Boolean(_loc3_) && !_loc3_.banned)
            {
               _loc3_.banned = true;
               this.championSelectionModel.championSelections.refresh();
            }
         }
      }
   }
}

