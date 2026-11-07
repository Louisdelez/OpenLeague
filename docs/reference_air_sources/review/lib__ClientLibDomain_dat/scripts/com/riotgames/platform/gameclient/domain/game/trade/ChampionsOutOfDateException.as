package com.riotgames.platform.gameclient.domain.game.trade
{
   import com.riotgames.platform.common.exception.PlatformException;
   
   [RemoteClass(alias="com.riotgames.platform.trade.api.contract.exception.ChampionsOutOfDateException")]
   public class ChampionsOutOfDateException extends PlatformException
   {
      
      public function ChampionsOutOfDateException()
      {
         super();
      }
   }
}

