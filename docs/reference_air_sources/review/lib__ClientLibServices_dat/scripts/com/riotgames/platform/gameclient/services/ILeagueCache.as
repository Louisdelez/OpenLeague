package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.domain.systemstates.TeamRewardQaulificationVO;
   
   public interface ILeagueCache
   {
      
      function setTeamQualifications(param1:Object) : void;
      
      function setDemotionWarningsMap(param1:Object) : void;
      
      function getTierRangeWithinMyTierForQueue(param1:String, param2:Number, param3:String) : Array;
      
      function getTopLeagueForChatPrescence() : LeagueItemDTO;
      
      function getMyLeagueItemForQueue(param1:String) : LeagueItemDTO;
      
      function parseLeagueName(param1:String) : String;
      
      function get myLeagueStandings() : Vector.<LeagueItemDTO>;
      
      function getDemotionWarning(param1:String, param2:String) : int;
      
      function addLeague(param1:LeagueListDTO, param2:Boolean = false) : void;
      
      function getLeaguePointsFromTeamCache(param1:String, param2:String = null) : int;
      
      function getLeaguePointsForSummonerOrTeam(param1:String) : int;
      
      function getLeagueDataForQueue(param1:String, param2:String) : LeagueListDTO;
      
      function clearData() : void;
      
      function getLeagueDataFromTeamCache(param1:String, param2:String = null) : LeagueListDTO;
      
      function getIsQualifiedForRewardsFromTeam(param1:String, param2:String) : TeamRewardQaulificationVO;
      
      function updatePrescenceData(param1:SummonerLeagueItemsDTO) : void;
   }
}

