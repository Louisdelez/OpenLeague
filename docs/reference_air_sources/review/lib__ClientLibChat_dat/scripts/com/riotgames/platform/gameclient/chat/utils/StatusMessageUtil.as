package com.riotgames.platform.gameclient.chat.utils
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   
   public class StatusMessageUtil
   {
      
      public function StatusMessageUtil()
      {
         super();
      }
      
      public static function presenceToStatusMessage(param1:String, param2:RiotPresence, param3:String) : String
      {
         var _loc4_:Boolean = param1 != null && param1 != "";
         if(param2 == RiotPresence.DND)
         {
            if(Boolean(param3) && param3 != "")
            {
               return RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_" + param3,"");
            }
         }
         else
         {
            if(param2 == RiotPresence.MOBILE && !_loc4_)
            {
               return RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_onMobile");
            }
            if(param2 == RiotPresence.AWAY && !_loc4_)
            {
               return RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_away");
            }
            if(Boolean(PresenceStatusXML.isGameLobbyStatus(param3)))
            {
               return RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_" + param3,"");
            }
            if(!_loc4_)
            {
               return RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_outOfGame");
            }
         }
         return param1;
      }
   }
}

