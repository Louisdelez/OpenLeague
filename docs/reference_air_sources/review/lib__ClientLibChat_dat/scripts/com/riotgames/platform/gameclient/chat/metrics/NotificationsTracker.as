package com.riotgames.platform.gameclient.chat.metrics
{
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class NotificationsTracker extends SessionTimeframedTracker
   {
      
      private static var _instance:NotificationsTracker;
      
      private static const ALL_OPEN_AT_SESSION_CLOSE:String = "all.open_at_session_close.int";
      
      private static const ALL_MAX_CONCURRENT_NOTIFICATIONS:String = "all.open.max_at_one_time";
      
      private static const ALL_MAX_CONCURRENT_TOASTS:String = "all.open_toasts.max_at_one_time";
      
      private static const ALL_TOTAL_NOTIFICATIONS_RECEIVED:String = "all.open.total";
      
      private static const ALL_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE:String = "all.received_needing_response.count";
      
      private static const ALL_NOTIFICATIONS_ACCEPTED:String = "all.accepted.count";
      
      private static const ALL_NOTIFICATIONS_ACCEPTED_VIA_TOAST:String = "all.accepted_via_toast.count";
      
      private static const ALL_NOTIFICATIONS_SHORTEST_RESPONSE_TIME:String = "all.received_shortest_response_time";
      
      private static const ALL_NOTIFICATIONS_SHORTEST_ACCEPT_TIME:String = "all.received_shortest_response_time_to_accept";
      
      private static const ALL_NOTIFICATIONS_SHORTEST_DECLINE_TIME:String = "all.received_shortest_response_time_to_decline";
      
      private static const ALL_NOTIFICATIONS_CLEAR_BUTTON_CLICKED:String = "all.clear_all_button_clicked.total";
      
      private static const GAME_INVITES_OPEN_AT_SESSION_CLOSE:String = "game_invites.open_at_session_close.int";
      
      private static const GAME_INVITES_MAX_CONCURRENT_NOTIFICATIONS:String = "game_invites.open.max_at_one_time";
      
      private static const GAME_INVITES_MAX_CONCURRENT_TOASTS:String = "game_invites.open_toasts.max_at_one_time";
      
      private static const GAME_INVITES_TOTAL_NOTIFICATIONS_RECEIVED:String = "game_invites.open.total";
      
      private static const GAME_INVITES_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE:String = "game_invites.received_needing_response.count";
      
      private static const GAME_INVITES_NOTIFICATIONS_ACCEPTED:String = "game_invites.accepted.count";
      
      private static const GAME_INVITES_NOTIFICATIONS_ACCEPTED_VIA_TOAST:String = "game_invites.accepted_via_toast.count";
      
      private static const GAME_INVITES_NOTIFICATIONS_SHORTEST_RESPONSE_TIME:String = "game_invites.received_shortest_response_time";
      
      private static const GAME_INVITES_NOTIFICATIONS_SHORTEST_ACCEPT_TIME:String = "game_invites.received_shortest_response_time_to_accept";
      
      private static const GAME_INVITES_NOTIFICATIONS_SHORTEST_DECLINE_TIME:String = "game_invites.received_shortest_response_time_to_decline";
      
      private static const GAME_INVITES_NOTIFICATIONS_CLEAR_BUTTON_CLICKED:String = "game_invites.clear_all_button_clicked.total";
      
      private static const SOCIAL_INVITES_OPEN_AT_SESSION_CLOSE:String = "social.open_at_session_close.int";
      
      private static const SOCIAL_INVITES_MAX_CONCURRENT_NOTIFICATIONS:String = "social.open.max_at_one_time";
      
      private static const SOCIAL_INVITES_MAX_CONCURRENT_TOASTS:String = "social.open_toasts.max_at_one_time";
      
      private static const SOCIAL_INVITES_TOTAL_NOTIFICATIONS_RECEIVED:String = "social.open.total";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE:String = "social.received_needing_response.count";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_ACCEPTED:String = "social.accepted.count";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_ACCEPTED_VIA_TOAST:String = "social.accepted_via_toast.count";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_SHORTEST_RESPONSE_TIME:String = "social.received_shortest_response_time";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_SHORTEST_ACCEPT_TIME:String = "social.received_shortest_response_time_to_accept";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_SHORTEST_DECLINE_TIME:String = "social.received_shortest_response_time_to_decline";
      
      private static const SOCIAL_INVITES_NOTIFICATIONS_CLEAR_BUTTON_CLICKED:String = "social.clear_all_button_clicked.total";
      
      private static const OTHER_OPEN_AT_SESSION_CLOSE:String = "other.open_at_session_close.int";
      
      private static const OTHER_MAX_CONCURRENT_NOTIFICATIONS:String = "other.open.max_at_one_time";
      
      private static const OTHER_MAX_CONCURRENT_TOASTS:String = "other.open_toasts.max_at_one_time";
      
      private static const OTHER_TOTAL_NOTIFICATIONS_RECEIVED:String = "other.open.total";
      
      private static const OTHER_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE:String = "other.received_needing_response.count";
      
      private static const OTHER_NOTIFICATIONS_ACCEPTED:String = "other.accepted.count";
      
      private static const OTHER_NOTIFICATIONS_ACCEPTED_VIA_TOAST:String = "other.accepted_via_toast.count";
      
      private static const OTHER_NOTIFICATIONS_SHORTEST_RESPONSE_TIME:String = "other.received_shortest_response_time";
      
      private static const OTHER_NOTIFICATIONS_SHORTEST_ACCEPT_TIME:String = "other.received_shortest_response_time_to_accept";
      
      private static const OTHER_NOTIFICATIONS_SHORTEST_DECLINE_TIME:String = "other.received_shortest_response_time_to_decline";
      
      private static const OTHER_NOTIFICATIONS_CLEAR_BUTTON_CLICKED:String = "other.clear_all_button_clicked.total";
      
      private static var TRACK_ALL_NOTIFICATIONS_MAX_COUNT:uint = 0;
      
      private static var TRACK_SOCIAL_NOTIFICATIONS_MAX_COUNT:uint = 0;
      
      private static var TRACK_GAME_INVITE_NOTIFICATIONS_MAX_COUNT:uint = 0;
      
      private static var TRACK_OTHER_NOTIFICATIONS_MAX_COUNT:uint = 0;
      
      private static var TRACK_ALL_NOTIFICATIONS_MAX_TOAST_COUNT:uint = 0;
      
      private static var TRACK_SOCIAL_NOTIFICATIONS_MAX_TOAST_COUNT:uint = 0;
      
      private static var TRACK_GAME_INVITE_NOTIFICATIONS_MAX_TOAST_COUNT:uint = 0;
      
      private static var TRACK_OTHER_NOTIFICATIONS_MAX_TOAST_COUNT:uint = 0;
      
      private static var TRACK_ALL_NOTIFICATIONS_CURRENT_COUNT:uint = 0;
      
      private static var TRACK_SOCIAL_NOTIFICATIONS_CURRENT_COUNT:uint = 0;
      
      private static var TRACK_GAME_INVITE_NOTIFICATIONS_CURRENT_COUNT:uint = 0;
      
      private static var TRACK_OTHER_NOTIFICATIONS_CURRENT_COUNT:uint = 0;
      
      private static var TRACK_ALL_SHORTEST_RESPONSE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_ALL_SHORTEST_ACCEPT_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_ALL_SHORTEST_DECLINE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_SOCIAL_SHORTEST_RESPONSE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_SOCIAL_SHORTEST_ACCEPT_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_SOCIAL_SHORTEST_DECLINE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_GAME_INVITE_SHORTEST_RESPONSE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_GAME_INVITE_SHORTEST_ACCEPT_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_GAME_INVITE_SHORTEST_DECLINE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_OTHER_SHORTEST_RESPONSE_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_OTHER_SHORTEST_ACCEPT_TIME:Number = Number.MAX_VALUE;
      
      private static var TRACK_OTHER_SHORTEST_DECLINE_TIME:Number = Number.MAX_VALUE;
      
      public function NotificationsTracker(param1:String, param2:Boolean = false, param3:Number = NaN, param4:Number = NaN, param5:Number = NaN)
      {
         super("front_end__iron__notifications");
      }
      
      public static function get instance() : NotificationsTracker
      {
         if(!_instance)
         {
            _instance = new NotificationsTracker(null);
         }
         return _instance;
      }
      
      public function activeToastsChanged(param1:Vector.<DockedPrompt>) : void
      {
         var _loc6_:DockedPrompt = null;
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         for each(_loc6_ in param1)
         {
            if(_loc6_.type == DockedPrompt.TYPE_FRIEND_INVITE)
            {
               _loc4_++;
            }
            else if(_loc6_.type == DockedPrompt.TYPE_GAME_INVITE)
            {
               _loc3_++;
            }
            else if(_loc6_.type == DockedPrompt.TYPE_OTHER)
            {
               _loc5_++;
            }
         }
         if(_loc2_ > TRACK_ALL_NOTIFICATIONS_MAX_TOAST_COUNT)
         {
            TRACK_ALL_NOTIFICATIONS_MAX_TOAST_COUNT = _loc2_;
         }
         if(_loc3_ > TRACK_GAME_INVITE_NOTIFICATIONS_MAX_TOAST_COUNT)
         {
            TRACK_GAME_INVITE_NOTIFICATIONS_MAX_TOAST_COUNT = _loc3_;
         }
         if(_loc4_ > TRACK_SOCIAL_NOTIFICATIONS_MAX_TOAST_COUNT)
         {
            TRACK_SOCIAL_NOTIFICATIONS_MAX_TOAST_COUNT = _loc4_;
         }
         if(_loc5_ > TRACK_OTHER_NOTIFICATIONS_MAX_TOAST_COUNT)
         {
            TRACK_OTHER_NOTIFICATIONS_MAX_TOAST_COUNT = _loc5_;
         }
      }
      
      public function clearedAllOtherNotifications() : void
      {
         incrementCounter(ALL_NOTIFICATIONS_CLEAR_BUTTON_CLICKED);
         incrementCounter(OTHER_NOTIFICATIONS_CLEAR_BUTTON_CLICKED);
      }
      
      public function notificationRemoved(param1:DockedPrompt, param2:String, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         if(param1.rightButtonLabel != null && param1.rightButtonLabel.length > 0)
         {
            _loc4_ = new Date().time - param1.timeStamp.time;
            if(_loc4_ < TRACK_ALL_SHORTEST_RESPONSE_TIME)
            {
               TRACK_ALL_SHORTEST_RESPONSE_TIME = _loc4_;
            }
            if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
            {
               if(_loc4_ < TRACK_SOCIAL_SHORTEST_RESPONSE_TIME)
               {
                  TRACK_SOCIAL_SHORTEST_RESPONSE_TIME = _loc4_;
               }
            }
            else if(param1.type == DockedPrompt.TYPE_GAME_INVITE)
            {
               if(_loc4_ < TRACK_GAME_INVITE_SHORTEST_RESPONSE_TIME)
               {
                  TRACK_GAME_INVITE_SHORTEST_RESPONSE_TIME = _loc4_;
               }
            }
            else if(param1.type == DockedPrompt.TYPE_OTHER)
            {
               if(_loc4_ < TRACK_OTHER_SHORTEST_RESPONSE_TIME)
               {
                  TRACK_OTHER_SHORTEST_RESPONSE_TIME = _loc4_;
               }
            }
            if(param2 == ButtonNameType.LEFT_BUTTON)
            {
               if(_loc4_ < TRACK_ALL_SHORTEST_ACCEPT_TIME)
               {
                  TRACK_ALL_SHORTEST_ACCEPT_TIME = _loc4_;
               }
               if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
               {
                  if(_loc4_ < TRACK_SOCIAL_SHORTEST_ACCEPT_TIME)
                  {
                     TRACK_SOCIAL_SHORTEST_ACCEPT_TIME = _loc4_;
                  }
               }
               else if(param1.type == DockedPrompt.TYPE_GAME_INVITE)
               {
                  if(_loc4_ < TRACK_GAME_INVITE_SHORTEST_ACCEPT_TIME)
                  {
                     TRACK_GAME_INVITE_SHORTEST_ACCEPT_TIME = _loc4_;
                  }
               }
               else if(param1.type == DockedPrompt.TYPE_OTHER)
               {
                  if(_loc4_ < TRACK_OTHER_SHORTEST_ACCEPT_TIME)
                  {
                     TRACK_OTHER_SHORTEST_ACCEPT_TIME = _loc4_;
                  }
               }
               incrementCounter(ALL_NOTIFICATIONS_ACCEPTED);
               if(param3)
               {
                  incrementCounter(ALL_NOTIFICATIONS_ACCEPTED_VIA_TOAST);
               }
               if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
               {
                  incrementCounter(SOCIAL_INVITES_NOTIFICATIONS_ACCEPTED);
                  if(param3)
                  {
                     incrementCounter(SOCIAL_INVITES_NOTIFICATIONS_ACCEPTED_VIA_TOAST);
                  }
               }
               else if(param1.type == DockedPrompt.TYPE_GAME_INVITE)
               {
                  incrementCounter(GAME_INVITES_NOTIFICATIONS_ACCEPTED);
                  if(param3)
                  {
                     incrementCounter(GAME_INVITES_NOTIFICATIONS_ACCEPTED_VIA_TOAST);
                  }
               }
               else if(param1.type == DockedPrompt.TYPE_OTHER)
               {
                  incrementCounter(OTHER_NOTIFICATIONS_ACCEPTED);
                  if(param3)
                  {
                     incrementCounter(OTHER_NOTIFICATIONS_ACCEPTED_VIA_TOAST);
                  }
               }
            }
            else if(param2 == ButtonNameType.RIGHT_BUTTON)
            {
               if(_loc4_ < TRACK_ALL_SHORTEST_DECLINE_TIME)
               {
                  TRACK_ALL_SHORTEST_DECLINE_TIME = _loc4_;
               }
               if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
               {
                  if(_loc4_ < TRACK_SOCIAL_SHORTEST_DECLINE_TIME)
                  {
                     TRACK_SOCIAL_SHORTEST_DECLINE_TIME = _loc4_;
                  }
               }
               else if(param1.type == DockedPrompt.TYPE_GAME_INVITE)
               {
                  if(_loc4_ < TRACK_GAME_INVITE_SHORTEST_DECLINE_TIME)
                  {
                     TRACK_GAME_INVITE_SHORTEST_DECLINE_TIME = _loc4_;
                  }
               }
               else if(param1.type == DockedPrompt.TYPE_OTHER)
               {
                  if(_loc4_ < TRACK_OTHER_SHORTEST_DECLINE_TIME)
                  {
                     TRACK_OTHER_SHORTEST_DECLINE_TIME = _loc4_;
                  }
               }
            }
         }
      }
      
      public function clearedAllGameInviteNotifications() : void
      {
         incrementCounter(ALL_NOTIFICATIONS_CLEAR_BUTTON_CLICKED);
         incrementCounter(GAME_INVITES_NOTIFICATIONS_CLEAR_BUTTON_CLICKED);
      }
      
      override public function sessionClosed() : void
      {
         setProperty(ALL_OPEN_AT_SESSION_CLOSE,TRACK_ALL_NOTIFICATIONS_CURRENT_COUNT);
         setProperty(GAME_INVITES_OPEN_AT_SESSION_CLOSE,TRACK_GAME_INVITE_NOTIFICATIONS_CURRENT_COUNT);
         setProperty(SOCIAL_INVITES_OPEN_AT_SESSION_CLOSE,TRACK_SOCIAL_NOTIFICATIONS_CURRENT_COUNT);
         setProperty(OTHER_OPEN_AT_SESSION_CLOSE,TRACK_OTHER_NOTIFICATIONS_CURRENT_COUNT);
         setProperty(ALL_MAX_CONCURRENT_NOTIFICATIONS,TRACK_ALL_NOTIFICATIONS_MAX_COUNT);
         setProperty(GAME_INVITES_MAX_CONCURRENT_NOTIFICATIONS,TRACK_GAME_INVITE_NOTIFICATIONS_MAX_COUNT);
         setProperty(SOCIAL_INVITES_MAX_CONCURRENT_NOTIFICATIONS,TRACK_SOCIAL_NOTIFICATIONS_MAX_COUNT);
         setProperty(OTHER_MAX_CONCURRENT_NOTIFICATIONS,TRACK_OTHER_NOTIFICATIONS_MAX_COUNT);
         setProperty(ALL_MAX_CONCURRENT_TOASTS,TRACK_ALL_NOTIFICATIONS_MAX_TOAST_COUNT);
         setProperty(GAME_INVITES_MAX_CONCURRENT_TOASTS,TRACK_GAME_INVITE_NOTIFICATIONS_MAX_TOAST_COUNT);
         setProperty(SOCIAL_INVITES_MAX_CONCURRENT_TOASTS,TRACK_SOCIAL_NOTIFICATIONS_MAX_TOAST_COUNT);
         setProperty(OTHER_MAX_CONCURRENT_TOASTS,TRACK_OTHER_NOTIFICATIONS_MAX_TOAST_COUNT);
         if(TRACK_ALL_SHORTEST_RESPONSE_TIME < Number.MAX_VALUE)
         {
            setProperty(ALL_NOTIFICATIONS_SHORTEST_RESPONSE_TIME,TRACK_ALL_SHORTEST_RESPONSE_TIME);
         }
         if(TRACK_GAME_INVITE_SHORTEST_RESPONSE_TIME < Number.MAX_VALUE)
         {
            setProperty(GAME_INVITES_NOTIFICATIONS_SHORTEST_RESPONSE_TIME,TRACK_GAME_INVITE_SHORTEST_RESPONSE_TIME);
         }
         if(TRACK_SOCIAL_SHORTEST_RESPONSE_TIME < Number.MAX_VALUE)
         {
            setProperty(SOCIAL_INVITES_NOTIFICATIONS_SHORTEST_RESPONSE_TIME,TRACK_SOCIAL_SHORTEST_RESPONSE_TIME);
         }
         if(TRACK_OTHER_SHORTEST_RESPONSE_TIME < Number.MAX_VALUE)
         {
            setProperty(OTHER_NOTIFICATIONS_SHORTEST_RESPONSE_TIME,TRACK_OTHER_SHORTEST_RESPONSE_TIME);
         }
         if(TRACK_ALL_SHORTEST_ACCEPT_TIME < Number.MAX_VALUE)
         {
            setProperty(ALL_NOTIFICATIONS_SHORTEST_ACCEPT_TIME,TRACK_ALL_SHORTEST_ACCEPT_TIME);
         }
         if(TRACK_GAME_INVITE_SHORTEST_ACCEPT_TIME < Number.MAX_VALUE)
         {
            setProperty(GAME_INVITES_NOTIFICATIONS_SHORTEST_ACCEPT_TIME,TRACK_GAME_INVITE_SHORTEST_ACCEPT_TIME);
         }
         if(TRACK_SOCIAL_SHORTEST_ACCEPT_TIME < Number.MAX_VALUE)
         {
            setProperty(SOCIAL_INVITES_NOTIFICATIONS_SHORTEST_ACCEPT_TIME,TRACK_SOCIAL_SHORTEST_ACCEPT_TIME);
         }
         if(TRACK_OTHER_SHORTEST_ACCEPT_TIME < Number.MAX_VALUE)
         {
            setProperty(OTHER_NOTIFICATIONS_SHORTEST_ACCEPT_TIME,TRACK_OTHER_SHORTEST_ACCEPT_TIME);
         }
         if(TRACK_ALL_SHORTEST_DECLINE_TIME < Number.MAX_VALUE)
         {
            setProperty(ALL_NOTIFICATIONS_SHORTEST_DECLINE_TIME,TRACK_ALL_SHORTEST_DECLINE_TIME);
         }
         if(TRACK_GAME_INVITE_SHORTEST_DECLINE_TIME < Number.MAX_VALUE)
         {
            setProperty(GAME_INVITES_NOTIFICATIONS_SHORTEST_DECLINE_TIME,TRACK_GAME_INVITE_SHORTEST_DECLINE_TIME);
         }
         if(TRACK_SOCIAL_SHORTEST_DECLINE_TIME < Number.MAX_VALUE)
         {
            setProperty(SOCIAL_INVITES_NOTIFICATIONS_SHORTEST_DECLINE_TIME,TRACK_SOCIAL_SHORTEST_DECLINE_TIME);
         }
         if(TRACK_OTHER_SHORTEST_DECLINE_TIME < Number.MAX_VALUE)
         {
            setProperty(OTHER_NOTIFICATIONS_SHORTEST_DECLINE_TIME,TRACK_OTHER_SHORTEST_DECLINE_TIME);
         }
         super.sessionClosed();
      }
      
      public function notificationsChanged(param1:Vector.<DockedPrompt>) : void
      {
         var _loc6_:DockedPrompt = null;
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         for each(_loc6_ in param1)
         {
            if(_loc6_.type == DockedPrompt.TYPE_FRIEND_INVITE)
            {
               _loc4_++;
            }
            else if(_loc6_.type == DockedPrompt.TYPE_GAME_INVITE)
            {
               _loc3_++;
            }
            else if(_loc6_.type == DockedPrompt.TYPE_OTHER)
            {
               _loc5_++;
            }
         }
         if(_loc2_ > TRACK_ALL_NOTIFICATIONS_MAX_COUNT)
         {
            TRACK_ALL_NOTIFICATIONS_MAX_COUNT = _loc2_;
         }
         if(_loc3_ > TRACK_GAME_INVITE_NOTIFICATIONS_MAX_COUNT)
         {
            TRACK_GAME_INVITE_NOTIFICATIONS_MAX_COUNT = _loc3_;
         }
         if(_loc4_ > TRACK_SOCIAL_NOTIFICATIONS_MAX_COUNT)
         {
            TRACK_SOCIAL_NOTIFICATIONS_MAX_COUNT = _loc4_;
         }
         if(_loc5_ > TRACK_OTHER_NOTIFICATIONS_MAX_COUNT)
         {
            TRACK_OTHER_NOTIFICATIONS_MAX_COUNT = _loc5_;
         }
         TRACK_ALL_NOTIFICATIONS_CURRENT_COUNT = _loc2_;
         TRACK_GAME_INVITE_NOTIFICATIONS_CURRENT_COUNT = _loc3_;
         TRACK_SOCIAL_NOTIFICATIONS_CURRENT_COUNT = _loc4_;
         TRACK_OTHER_NOTIFICATIONS_CURRENT_COUNT = _loc5_;
      }
      
      public function notificationAdded(param1:DockedPrompt) : void
      {
         incrementCounter(ALL_TOTAL_NOTIFICATIONS_RECEIVED);
         if(param1.rightButtonLabel != null && param1.rightButtonLabel.length > 0)
         {
            incrementCounter(ALL_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE);
            if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
            {
               incrementCounter(SOCIAL_INVITES_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE);
            }
            else if(param1.type == DockedPrompt.TYPE_GAME_INVITE)
            {
               incrementCounter(GAME_INVITES_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE);
            }
            else if(param1.type == DockedPrompt.TYPE_OTHER)
            {
               incrementCounter(OTHER_NOTIFICATIONS_RECEIVED_REQUIRING_RESPONSE);
            }
         }
         if(param1.type == DockedPrompt.TYPE_FRIEND_INVITE)
         {
            incrementCounter(SOCIAL_INVITES_TOTAL_NOTIFICATIONS_RECEIVED);
         }
         else if(param1.type == DockedPrompt.TYPE_GAME_INVITE)
         {
            incrementCounter(GAME_INVITES_TOTAL_NOTIFICATIONS_RECEIVED);
         }
         else if(param1.type == DockedPrompt.TYPE_OTHER)
         {
            incrementCounter(OTHER_TOTAL_NOTIFICATIONS_RECEIVED);
         }
      }
      
      public function clearedAllSocialInviteNotifications() : void
      {
         incrementCounter(ALL_NOTIFICATIONS_CLEAR_BUTTON_CLICKED);
         incrementCounter(SOCIAL_INVITES_NOTIFICATIONS_CLEAR_BUTTON_CLICKED);
      }
   }
}

