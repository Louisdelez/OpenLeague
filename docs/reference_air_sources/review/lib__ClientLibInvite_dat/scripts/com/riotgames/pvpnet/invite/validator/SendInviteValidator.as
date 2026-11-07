package com.riotgames.pvpnet.invite.validator
{
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class SendInviteValidator
   {
      
      public function SendInviteValidator()
      {
         super();
      }
      
      private function meetsLevelRequirement(param1:GameQueueConfig, param2:int) : Boolean
      {
         if(Boolean(param1) && Boolean(param1.minLevel) && param2 < param1.minLevel)
         {
            return false;
         }
         return true;
      }
      
      public function publicSummonerMeetsLevelRequirement(param1:PublicSummoner, param2:GameQueueConfig) : Boolean
      {
         var _loc3_:int = int(param1.summonerLevel);
         return this.meetsLevelRequirement(param2,_loc3_);
      }
      
      public function rosterItemMeetsLevelRequirement(param1:RosterItemVO, param2:GameQueueConfig) : Boolean
      {
         var _loc3_:int = int(PresenceController.getPresenceData(param1.status).level);
         return this.meetsLevelRequirement(param2,_loc3_);
      }
   }
}

