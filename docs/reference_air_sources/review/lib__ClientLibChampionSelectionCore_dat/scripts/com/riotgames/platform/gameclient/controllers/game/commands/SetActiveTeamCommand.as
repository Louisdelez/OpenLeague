package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   
   public class SetActiveTeamCommand extends CommandBase
   {
      
      private var championSelectionModel:ChampionSelectionModel;
      
      public function SetActiveTeamCommand(param1:ChampionSelectionModel)
      {
         super();
         this.championSelectionModel = param1;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.setActiveTeams();
         onComplete();
         onResult();
      }
      
      private function setActiveTeams() : void
      {
         var _loc3_:GameParticipant = null;
         var _loc4_:IParticipant = null;
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.championSelectionModel.currentTeam)
         {
            if(_loc3_.pickMode == GameParticipant.PICK_MODE_ACTIVE)
            {
               _loc1_ = true;
               break;
            }
         }
         for each(_loc4_ in this.championSelectionModel.enemyTeam)
         {
            if(_loc4_.getPickMode() == GameParticipant.PICK_MODE_ACTIVE)
            {
               _loc2_ = true;
               break;
            }
         }
         this.championSelectionModel.currentTeamActive = _loc1_;
         this.championSelectionModel.enemyTeamActive = _loc2_;
      }
   }
}

