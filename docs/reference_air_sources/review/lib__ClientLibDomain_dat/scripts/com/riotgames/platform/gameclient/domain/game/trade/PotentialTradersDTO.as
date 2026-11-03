package com.riotgames.platform.gameclient.domain.game.trade
{
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.trade.api.contract.PotentialTradersDTO")]
   public class PotentialTradersDTO
   {
      
      public var potentialTraders:ArrayCollection;
      
      public function PotentialTradersDTO()
      {
         super();
      }
   }
}

