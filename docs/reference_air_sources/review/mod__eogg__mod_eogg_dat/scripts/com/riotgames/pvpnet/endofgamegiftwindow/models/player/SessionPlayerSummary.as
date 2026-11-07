package com.riotgames.pvpnet.endofgamegiftwindow.models.player
{
   import com.riotgames.platform.common.session.Session;
   
   public class SessionPlayerSummary
   {
      
      public function SessionPlayerSummary()
      {
         super();
      }
      
      public static function getPlayerSummaryForSessionPlayer(param1:Session, param2:String, param3:Number) : ISessionPlayer
      {
         return new SessionPlayer(param1.accountSummary.accountId,param1.getSummonerId(),param1.accountSummary.summonerName,param1.summonerLevel.summonerLevel,param2,param3);
      }
   }
}

