package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class RosterEvent extends Event
   {
      
      public static const SUBSCRIPTION_REVOCATION:String = "subscriptionRevocation";
      
      public static const SUBSCRIPTION_REQUEST:String = "subscriptionRequest";
      
      public static const SUBSCRIPTION_DENIAL:String = "subscriptionDenial";
      
      public static const USER_AVAILABLE:String = "userAvailable";
      
      public static const USER_UNAVAILABLE:String = "userUnavailable";
      
      public static const USER_ADDED:String = "userAdded";
      
      public static const USER_REMOVED:String = "userRemoved";
      
      public static const USER_PRESENCE_UPDATED:String = "userPresenceUpdated";
      
      public static const USER_SUBSCRIPTION_UPDATED:String = "userSubscriptionUpdated";
      
      public static const ROSTER_LOADED:String = "rosterLoaded";
      
      public static const USER_PRESENCE_ONLINE:String = "userPresenceOnline";
      
      private var _data:*;
      
      private var _jid:UnescapedJID;
      
      public function RosterEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      public function set jid(param1:UnescapedJID) : void
      {
         this._jid = param1;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
      }
   }
}

