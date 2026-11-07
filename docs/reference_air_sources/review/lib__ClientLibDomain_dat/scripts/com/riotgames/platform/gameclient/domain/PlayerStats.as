package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerStats")]
   public class PlayerStats extends AbstractDomainObject
   {
      
      public var promoGamesPlayedLastUpdated:Date;
      
      public var promoGamesPlayed:int;
      
      public function PlayerStats()
      {
         super();
      }
   }
}

