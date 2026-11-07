package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.game.ChampionBanInfoDTO")]
   public class ChampionBanInfoDTO
   {
      
      public var championId:int;
      
      public var owned:Boolean;
      
      public var enemyOwned:Boolean;
      
      public function ChampionBanInfoDTO()
      {
         super();
      }
   }
}

