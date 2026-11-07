package com.riotgames.platform.gameclient.domain.loyalty
{
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.inventory.loyalty.ChampionReward")]
   public class ChampionReward
   {
      
      public var championId:Number;
      
      public var skins:ArrayCollection;
      
      public function ChampionReward()
      {
         super();
      }
   }
}

