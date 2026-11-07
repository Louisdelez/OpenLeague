package com.riotgames.platform.gameclient.domain.game.trade
{
   [RemoteClass(alias="com.riotgames.platform.trade.api.contract.TradeContractDTO")]
   public class TradeContractDTO
   {
      
      public var state:String;
      
      public var requesterInternalSummonerName:String;
      
      public var responderChampionId:int;
      
      public var requesterChampionId:int;
      
      public var responderInternalSummonerName:String;
      
      public function TradeContractDTO()
      {
         super();
      }
   }
}

