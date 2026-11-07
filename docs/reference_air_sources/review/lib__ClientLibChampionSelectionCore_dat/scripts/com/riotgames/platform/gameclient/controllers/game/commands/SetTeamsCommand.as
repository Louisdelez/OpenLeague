package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   
   public class SetTeamsCommand extends CommandBase
   {
      
      private var championSelectionModel:ChampionSelectionModel;
      
      public function SetTeamsCommand(param1:ChampionSelectionModel)
      {
         super();
         this.championSelectionModel = param1;
      }
      
      private function setTeams(param1:GameDTO) : void
      {
         if(Boolean(this.championSelectionModel.currentPlayerParticipant) && Boolean(param1.isPlayerOnTeamOne(this.championSelectionModel.currentPlayerParticipant.summonerName)))
         {
            this.championSelectionModel.currentTeam = param1.teamOne;
            this.championSelectionModel.enemyTeam = param1.teamTwo;
            this.championSelectionModel.currentTeamName = Team.TEAM_BLUE;
            this.championSelectionModel.enemyTeamName = Team.TEAM_PURPLE;
         }
         else if(Boolean(this.championSelectionModel.currentPlayerParticipant) && Boolean(param1.isPlayerOnTeamTwo(this.championSelectionModel.currentPlayerParticipant.summonerName)))
         {
            this.championSelectionModel.enemyTeam = param1.teamOne;
            this.championSelectionModel.currentTeam = param1.teamTwo;
            this.championSelectionModel.currentTeamName = Team.TEAM_PURPLE;
            this.championSelectionModel.enemyTeamName = Team.TEAM_BLUE;
         }
         else
         {
            this.championSelectionModel.currentTeam = param1.teamOne;
            this.championSelectionModel.enemyTeam = param1.teamTwo;
            this.championSelectionModel.currentTeamName = Team.TEAM_BLUE;
            this.championSelectionModel.enemyTeamName = Team.TEAM_PURPLE;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this.setTeams(this.championSelectionModel.currentGame);
         onComplete();
         onResult();
      }
   }
}

