package com.riotgames.platform.common.xmpp.data.privacy
{
   public class PrivacyListItemType
   {
      
      public static const JID:String = "jid";
      
      public static const GROUP:String = "group";
      
      public static const SUBSCRIPTION:String = "subscription";
      
      public function PrivacyListItemType()
      {
         super();
         throw new Error("Cannot instantiate this class.");
      }
   }
}

