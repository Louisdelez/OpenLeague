package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   
   public interface PlayerStatsService
   {
      
      function getRecentGames(param1:Number, param2:Function, param3:Function) : void;
      
      function getAggregatedStats(param1:Number, param2:String, param3:int, param4:Function, param5:Function) : void;
      
      function retrieveTopPlayedChampions(param1:Number, param2:String, param3:Function, param4:Function) : void;
      
      function getTeamAggregatedStats(param1:TeamId, param2:Function, param3:Function, param4:Function) : void;
      
      function processEloQuestionaire(param1:String, param2:Function, param3:Function) : void;
      
      function getTeamEndOfGameStats(param1:TeamId, param2:Number, param3:Function, param4:Function, param5:Function) : void;
      
      function retrievePlayerStatsByAccountId(param1:Number, param2:int, param3:Function, param4:Function) : void;
   }
}

