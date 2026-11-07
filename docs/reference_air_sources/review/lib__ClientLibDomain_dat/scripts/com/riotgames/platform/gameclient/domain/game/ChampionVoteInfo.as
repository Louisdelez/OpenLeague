package com.riotgames.platform.gameclient.domain.game
{
   [RemoteClass(alias="com.riotgames.platform.game.ChampionVoteInfo")]
   public class ChampionVoteInfo
   {
      
      public var championID:int;
      
      public var percentChance:int;
      
      public var lockedIn:Boolean;
      
      public function ChampionVoteInfo()
      {
         super();
      }
   }
}

