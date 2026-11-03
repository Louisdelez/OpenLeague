package com.riotgames.platform.gameclient.domain.game.trade
{
   import com.riotgames.platform.common.exception.PlatformException;
   
   [RemoteClass(alias="com.riotgames.platform.trade.api.contract.exception.ChampionTradeException")]
   public class ChampionTradeException extends PlatformException
   {
      
      public function ChampionTradeException()
      {
         super();
      }
   }
}

