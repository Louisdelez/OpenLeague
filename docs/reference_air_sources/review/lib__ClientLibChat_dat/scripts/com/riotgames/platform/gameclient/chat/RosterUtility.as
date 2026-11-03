package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkContact;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.utils.Dictionary;
   import mx.utils.StringUtil;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterExtension;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class RosterUtility
   {
      
      private static var rosterItemToBuddyMap:Dictionary = new Dictionary(true);
      
      private static var jidToRosterMap:Dictionary = new Dictionary();
      
      public function RosterUtility()
      {
         super();
      }
      
      public static function getBuddy(param1:RosterItemVO) : Buddy
      {
         var _loc2_:Buddy = rosterItemToBuddyMap[param1];
         if(!_loc2_)
         {
            _loc2_ = new Buddy();
            rosterItemToBuddyMap[param1] = _loc2_;
            populateBuddyFromRosterItem(_loc2_,param1);
         }
         return _loc2_;
      }
      
      public static function isOnlineAndAvailableForInvite(param1:RosterItemVO) : Boolean
      {
         return Boolean(param1.online) && param1.show != Presence.SHOW_DND && !param1.isOnMobile;
      }
      
      public static function populateBuddyFromRosterItem(param1:Buddy, param2:RosterItemVO) : void
      {
         var _loc7_:PresenceStatusData = null;
         var _loc3_:Number = summonerIdFromJID(param2.jid);
         var _loc4_:SocialNetworkContact = param2.localUserData as SocialNetworkContact;
         var _loc5_:String = Boolean(_loc4_) ? _loc4_.displayName : null;
         var _loc6_:int = int(Buddy.STATUS_OFFLINE);
         var _loc8_:String = param2.show;
         if(!(param2.status == null || param2.status == "Offline"))
         {
            _loc6_ = int(Buddy.STATUS_ONLINE);
            if(param2.status != "Available")
            {
               _loc7_ = PresenceController.getPresenceData(param2.status);
            }
         }
         param1.disablePropertyChangeEvents = true;
         param1.setName(param2.displayName);
         param1.setRealName(_loc5_);
         param1.setSummonerId(_loc3_);
         param1.setStatus(_loc6_);
         param1.setPresence(_loc7_);
         param1.setBusyStatus(_loc8_);
         param1.setIsOnMobile(param2.isOnMobile);
         param1.setJId(param2.jid.bareJID);
         param1.setNote(param2.note);
         param1.setIsMutualFriend(param2.subscribeType == RosterExtension.SUBSCRIBE_TYPE_BOTH);
         param1.setEligibleQueuePartner(!param2.isRankedRestricted && !param2.isDuoQueueRestricted);
         param1.disablePropertyChangeEvents = false;
         param1.update();
      }
      
      public static function getRosterItemVoFromJID(param1:String) : RosterItemVO
      {
         var _loc2_:RosterItemVO = jidToRosterMap[param1];
         if(!_loc2_)
         {
            _loc2_ = RosterItemVO.get(new UnescapedJID(param1),false);
            jidToRosterMap[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public static function jidFromInternalName(param1:String) : UnescapedJID
      {
         return new UnescapedJID(StringUtil.trim(param1) + "@" + ClientConfig.JABBER_DOMAIN);
      }
      
      public static function isAvailableForInvite(param1:RosterItemVO) : Boolean
      {
         return param1.show != Presence.SHOW_DND && !param1.isOnMobile;
      }
      
      public static function summonerIdFromJID(param1:UnescapedJID) : Number
      {
         var _loc2_:String = param1.bareJID;
         var _loc3_:int = _loc2_.indexOf("@");
         _loc2_ = _loc2_.substring(3,_loc3_);
         return Number(_loc2_);
      }
   }
}

