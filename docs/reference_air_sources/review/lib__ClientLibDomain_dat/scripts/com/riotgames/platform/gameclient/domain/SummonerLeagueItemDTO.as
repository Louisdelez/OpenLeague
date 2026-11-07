package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.leagues.client.dto.SummonerLeagueItemDTO")]
   public class SummonerLeagueItemDTO extends LeagueItemDTO
   {
      
      public var qualifiedTierReward:Boolean;
      
      public var gameWinForReward:int;
      
      public function SummonerLeagueItemDTO()
      {
         super();
      }
   }
}

