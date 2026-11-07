package com.riotgames.pvpnet.tracking.trackers.chat
{
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   import com.riotgames.pvpnet.tracker.parts.Recorder;
   import flash.utils.Dictionary;
   
   public class ChatBehaviorTracker extends SessionTimeframedTracker implements IChatBehaviorTracker
   {
      
      private static const PER_BUDDY_TRACKER_NAME:String = "PER_BUDDY_TRACKER";
      
      public static const CHAT_SESSION_TOTAL_DURATION:String = "chat_session_total.duration";
      
      public static const CHAT_SESSION_ACTIVE_DURATION:String = "chat_session_active.duration";
      
      public static const CHAT_WINDOWS_OPEN_AT_SESSION_CLOSE_COUNT:String = "chat_windows_open_at_session_close.count";
      
      public static const CHAT_MESSAGES_TOTAL_MESSAGES_COUNT:String = "chat_messages_total_messages.count";
      
      public static const CHAT_WINDOW_OPENED_TOTAL:String = "chat_window_opened.total";
      
      public static const CHAT_PREFERENCES_TIMESTAMPS_ON:String = "chat_preferences_timestamps_on.boolean";
      
      public static const CHAT_MESSAGES_TOTAL_SEND_VS_RECEIVE_PREFERENCE:String = "chat_messages_total_send_vs_receive.preference";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_ACTIVE:String = "chat_messages_best_friend_active.duration";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_MESSAGES:String = "chat_messages_best_friend_messages.count";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_SEND_VS_RECEIVE:String = "chat_messages_best_friend_send_vs_receive.preference";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_RECEIVED_WHILE_INACTIVE:String = "chat_messages_best_friend_received_while_not_active.count";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_AVERAGE_MESSAGE_SENT:String = "chat_messages_best_friend_average_message_sent.length";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_LARGEST_MESSAGE_SENT:String = "chat_messages_best_friend_largest_message_sent.length";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_INITIAL_MESSAGE_SEND_VS_RECEIVE:String = "chat_messages_best_friend_initial_message_send_vs_receive.preference";
      
      public static const CHAT_WINDOWS_OPEN_SESSION_TOTAL_MAX:String = "chat_windows_open_session_total.max";
      
      public static const CHAT_WINDOW_OPENED_BY_USER_COUNT:String = "chat_window_opened_by_user.count";
      
      public static const CHAT_WINDOW_OPENED_VIA_MESSAGE_RECEIVED_COUNT:String = "chat_window_opened_via_message_received.count";
      
      public static const CHAT_WINDOW_MINIMIZED_VIA_BUTTON_COUNT:String = "chat_window_minimized_via_button.count";
      
      public static const CHAT_WINDOW_SWITCHED_COUNT:String = "chat_window_switched.count";
      
      public static const CHAT_WINDOWS_OPEN_SESSION_CONVERSATION_COUNT:String = "chat_windows_open_session_conversation.count";
      
      public static const CHAT_WINDOWS_OPEN_SESSION_TOTAL_CONVERSATION_LENGTH_10_COUNT:String = "chat_windows_open_session_total_conversation_length_10.count";
      
      public static const CHAT_WINDOWS_OPEN_SESSION_TOTAL_CONVERSATION_LENGTH_25_COUNT:String = "chat_windows_open_session_total_conversation_length_25.count";
      
      public static const CHAT_WINDOW_OPTIONS_OPENED_COUNT:String = "chat_window_options_opened.count";
      
      public static const CHAT_WINDOW_OPTIONS_VIEW_PROFILE_CLICKED_COUNT:String = "chat_window_options_view_profile_clicked.count";
      
      public static const CHAT_MESSAGES_HYPERLINK_RECEIVED_COUNT:String = "chat_messages_hyperlink_received.count";
      
      public static const CHAT_MESSAGES_HYPERLINK_CLICKED_COUNT:String = "chat_messages_hyperlink_clicked.count";
      
      public static const CHAT_MESSAGES_TOTAL_RECEIVED_COUNT:String = "chat_messages_total_received.count";
      
      public static const CHAT_MESSAGES_TOTAL_SENT_COUNT:String = "chat_messages_total_sent.count";
      
      public static const CHAT_WINDOW_CLOSED_COUNT:String = "chat_window_closed.count";
      
      public static const CHAT_MESSAGES_TOTAL_RECEIVED_WHILE_INACTIVE_COUNT:String = "chat_messages_total_received_while_not_active.count";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_RECEIVED:String = "chat_messages_best_friend_received.count";
      
      public static const CHAT_MESSAGES_BEST_FRIEND_SENT:String = "chat_messages_best_friend_sent.count";
      
      public static const CHAT_MESSAGES_TOTAL_SENT_LENGTH:String = "chat_messages_total_sent_length";
      
      public static const CHAT_MESSAGES_TOTAL_RECEIVED_LENGTH:String = "chat_messages_total_received_length";
      
      public static const CHAT_WINDOWS_OPEN_SESSION_TOTAL:String = "chat_windows_open_session_total";
      
      private var bestFriendJID:String = "";
      
      private var maxChatWindows:int = 0;
      
      private var lastNumOfWindowsClosed:uint = 0;
      
      private var buddyJIDsToMessages:Dictionary = new Dictionary();
      
      public function ChatBehaviorTracker(param1:Boolean = true)
      {
         super("front_end__iron__chat",param1);
         this.add(PER_BUDDY_TRACKER_NAME);
         this.get(PER_BUDDY_TRACKER_NAME).start();
      }
      
      public function incrementChatWindowOptionsClicked() : void
      {
         incrementCounter(CHAT_WINDOW_OPTIONS_OPENED_COUNT);
      }
      
      public function incrementURLReceived() : void
      {
         incrementCounter(CHAT_MESSAGES_HYPERLINK_RECEIVED_COUNT);
      }
      
      public function incrementChatRoomsCreated_InASession() : void
      {
      }
      
      public function incrementChatWindowsMinimizedViaButton() : void
      {
         incrementCounter(CHAT_WINDOW_MINIMIZED_VIA_BUTTON_COUNT);
      }
      
      public function incrementInGameChatSent_InASession() : void
      {
      }
      
      private function hasHadChatActions() : Boolean
      {
         return getCounterValue(CHAT_MESSAGES_TOTAL_RECEIVED_COUNT) > 0 || getCounterValue(CHAT_MESSAGES_TOTAL_SENT_COUNT) > 0;
      }
      
      public function setChatWindowsOpenedAtOnce(param1:uint) : void
      {
         recordValue(CHAT_WINDOWS_OPEN_SESSION_TOTAL,param1,true);
         this.lastNumOfWindowsClosed = param1;
      }
      
      public function incrementChatWindowSwitched_InASession() : void
      {
         incrementCounter(CHAT_WINDOW_SWITCHED_COUNT);
      }
      
      public function incrementViewProfileClicked() : void
      {
         incrementCounter(CHAT_WINDOW_OPTIONS_VIEW_PROFILE_CLICKED_COUNT);
      }
      
      public function incrementInGameChatReceived_InASession() : void
      {
      }
      
      public function incrementChatWindowClosed_InASession(param1:String) : void
      {
         incrementCounter(CHAT_WINDOW_CLOSED_COUNT);
         var _loc2_:Number = Number(this.get(PER_BUDDY_TRACKER_NAME).getElapsedTimeInMS());
         var _loc3_:ChatBehaviorBestFriend = this.getBestFriendFromJID(param1);
         if(_loc3_.last_start != 0)
         {
            _loc3_.duration += _loc2_ - _loc3_.last_start;
            _loc3_.is_open = false;
         }
      }
      
      public function incrementURLClicked() : void
      {
         incrementCounter(CHAT_MESSAGES_HYPERLINK_CLICKED_COUNT);
      }
      
      public function incrementChatMessageSent_InASession(param1:String, param2:String) : void
      {
         this.incrementChatStartBySentMessage_InASession(param1);
         this.trackMessageToBuddyJID(param1,true,param2);
         recordValue(CHAT_MESSAGES_TOTAL_SENT_LENGTH,param2.length);
         incrementCounter(CHAT_MESSAGES_TOTAL_SENT_COUNT);
      }
      
      override public function sessionClosed() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:ChatBehaviorBestFriend = null;
         if(_sessionMetrics)
         {
            _loc2_ = Number(_sessionMetrics.getSessionElapsedTimeInMS());
            _loc3_ = Number(_sessionMetrics.getActiveSessionElapsedTimeInMS());
            setProperty(CHAT_SESSION_TOTAL_DURATION,_loc2_);
            setProperty(CHAT_SESSION_ACTIVE_DURATION,_loc3_);
         }
         setProperty(CHAT_PREFERENCES_TIMESTAMPS_ON,UserPreferencesManager.userPrefs.personalImTimeStamps);
         var _loc1_:Recorder = this.getRecording(CHAT_WINDOWS_OPEN_SESSION_TOTAL);
         if(_loc1_)
         {
            _loc1_.calculateSummary();
            setProperty(CHAT_WINDOWS_OPEN_SESSION_TOTAL_MAX,_loc1_.summary.max);
            this.removeRecording(CHAT_WINDOWS_OPEN_SESSION_TOTAL);
         }
         if(Boolean(hasCounter(CHAT_MESSAGES_TOTAL_RECEIVED_COUNT)) || Boolean(hasCounter(CHAT_MESSAGES_TOTAL_SENT_COUNT)))
         {
            _loc4_ = Number(getCounterValue(CHAT_MESSAGES_TOTAL_RECEIVED_COUNT));
            _loc5_ = Number(getCounterValue(CHAT_MESSAGES_TOTAL_SENT_COUNT));
            if(isNaN(_loc4_))
            {
               _loc4_ = 0;
            }
            if(isNaN(_loc5_))
            {
               _loc5_ = 0;
            }
            setProperty(CHAT_MESSAGES_TOTAL_MESSAGES_COUNT,_loc4_ + _loc5_);
         }
         if(Boolean(hasCounter(CHAT_WINDOW_OPENED_BY_USER_COUNT)) || Boolean(hasCounter(CHAT_WINDOW_OPENED_VIA_MESSAGE_RECEIVED_COUNT)))
         {
            _loc4_ = Number(getCounterValue(CHAT_WINDOW_OPENED_BY_USER_COUNT));
            _loc5_ = Number(getCounterValue(CHAT_WINDOW_OPENED_VIA_MESSAGE_RECEIVED_COUNT));
            if(isNaN(_loc4_))
            {
               _loc4_ = 0;
            }
            if(isNaN(_loc5_))
            {
               _loc5_ = 0;
            }
            setProperty(CHAT_WINDOW_OPENED_TOTAL,_loc4_ + _loc5_);
         }
         if(this.hasHadChatActions())
         {
            this.setChatSendVSReceivePref(false);
         }
         if(Boolean(hasCounter(CHAT_WINDOW_OPENED_BY_USER_COUNT)) || Boolean(hasCounter(CHAT_WINDOW_OPENED_VIA_MESSAGE_RECEIVED_COUNT)))
         {
            _loc6_ = Number(getCounterValue(CHAT_WINDOW_OPENED_BY_USER_COUNT));
            _loc7_ = Number(getCounterValue(CHAT_WINDOW_OPENED_VIA_MESSAGE_RECEIVED_COUNT));
            if(isNaN(_loc6_))
            {
               _loc6_ = 0;
            }
            if(isNaN(_loc7_))
            {
               _loc7_ = 0;
            }
            this.setChatWindowsOpened_InASession(_loc6_ + _loc7_);
         }
         if(this.lastNumOfWindowsClosed > 0)
         {
            setProperty(CHAT_WINDOWS_OPEN_AT_SESSION_CLOSE_COUNT,this.lastNumOfWindowsClosed);
         }
         if(this.buddyJIDsToMessages[this.bestFriendJID] != null)
         {
            _loc8_ = this.getBestFriendFromJID(this.bestFriendJID);
            if(_loc8_.message_count_sent > 0)
            {
               setCounterValue(CHAT_MESSAGES_BEST_FRIEND_SENT,_loc8_.message_count_sent);
               setProperty(CHAT_MESSAGES_BEST_FRIEND_LARGEST_MESSAGE_SENT,_loc8_.largest_sent);
               setProperty(CHAT_MESSAGES_BEST_FRIEND_AVERAGE_MESSAGE_SENT,_loc8_.total_chars_sent / _loc8_.message_count_sent);
            }
            if(_loc8_.message_count_rcvd > 0)
            {
               setCounterValue(CHAT_MESSAGES_BEST_FRIEND_RECEIVED,_loc8_.message_count_rcvd);
            }
            setProperty(CHAT_MESSAGES_BEST_FRIEND_MESSAGES,_loc8_.message_count_rcvd + _loc8_.message_count_sent);
            this.setChatSendVSReceivePref(true);
            if(_loc8_.message_count_rcvd_while_inactive > 0)
            {
               setProperty(CHAT_MESSAGES_BEST_FRIEND_RECEIVED_WHILE_INACTIVE,_loc8_.message_count_rcvd_while_inactive);
            }
            setProperty(CHAT_MESSAGES_BEST_FRIEND_INITIAL_MESSAGE_SEND_VS_RECEIVE,_loc8_.init_by_me ? "SENT" : "RECEIVED");
            if(_loc8_.is_open)
            {
               _loc8_.duration += this.get(PER_BUDDY_TRACKER_NAME).getElapsedTimeInMS() - _loc8_.last_start;
            }
            setProperty(CHAT_MESSAGES_BEST_FRIEND_ACTIVE,_loc8_.duration);
         }
         this.remove([PER_BUDDY_TRACKER_NAME]);
         super.sessionClosed();
      }
      
      public function incrementChatStartBySentMessage_InASession(param1:String) : void
      {
         if(!this.hasAlreadyChattedWithUser(param1))
         {
            incrementCounter(CHAT_WINDOW_OPENED_BY_USER_COUNT);
         }
      }
      
      public function incrementChatMessagesReceived_InASession(param1:String, param2:String) : void
      {
         var _loc3_:ChatBehaviorBestFriend = null;
         this.incrementChatStartByReceivedMessage_InASession(param1);
         this.trackMessageToBuddyJID(param1,false,param2);
         recordValue(CHAT_MESSAGES_TOTAL_RECEIVED_LENGTH,param2.length);
         incrementCounter(CHAT_MESSAGES_TOTAL_RECEIVED_COUNT);
         if(Boolean(_sessionMetrics) && !_sessionMetrics.isSessionActive())
         {
            incrementCounter(CHAT_MESSAGES_TOTAL_RECEIVED_WHILE_INACTIVE_COUNT);
            _loc3_ = this.getBestFriendFromJID(param1);
            _loc3_.message_count_rcvd_while_inactive += 1;
         }
      }
      
      private function hasAlreadyChattedWithUser(param1:String) : Boolean
      {
         if(this.buddyJIDsToMessages[param1] != null)
         {
            return true;
         }
         return false;
      }
      
      public function setChatWindowsOpened_InASession(param1:uint) : void
      {
         setProperty(CHAT_WINDOW_OPENED_TOTAL,param1);
      }
      
      private function getBestFriendFromJID(param1:String) : ChatBehaviorBestFriend
      {
         if(this.buddyJIDsToMessages[param1] == null)
         {
            this.buddyJIDsToMessages[param1] = new ChatBehaviorBestFriend();
         }
         return this.buddyJIDsToMessages[param1] as ChatBehaviorBestFriend;
      }
      
      private function trackMessageToBuddyJID(param1:String, param2:Boolean, param3:String) : void
      {
         var _loc4_:ChatBehaviorBestFriend = this.getBestFriendFromJID(param1);
         if(param2)
         {
            if(_loc4_.message_count_sent == 0 && _loc4_.message_count_rcvd == 0)
            {
               _loc4_.init_by_me = true;
            }
            _loc4_.message_count_sent += 1;
            _loc4_.recordMessageLength(param3.length);
         }
         else
         {
            _loc4_.message_count_rcvd += 1;
         }
         if(!_loc4_.is_open)
         {
            _loc4_.is_open = true;
            _loc4_.last_start = this.get(PER_BUDDY_TRACKER_NAME).getElapsedTimeInMS();
         }
         var _loc5_:int = _loc4_.message_count_rcvd + _loc4_.message_count_sent;
         if(_loc4_.message_count_sent > 0 && _loc4_.message_count_rcvd > 0)
         {
            if(param2 && _loc4_.message_count_sent == 1 || !param2 && _loc4_.message_count_rcvd == 1)
            {
               incrementCounter(CHAT_WINDOWS_OPEN_SESSION_CONVERSATION_COUNT);
            }
            if(_loc5_ == 10)
            {
               incrementCounter(CHAT_WINDOWS_OPEN_SESSION_TOTAL_CONVERSATION_LENGTH_10_COUNT);
            }
            if(_loc5_ == 25)
            {
               incrementCounter(CHAT_WINDOWS_OPEN_SESSION_TOTAL_CONVERSATION_LENGTH_25_COUNT);
            }
         }
         if(this.bestFriendJID == "")
         {
            this.bestFriendJID = param1;
         }
         var _loc6_:ChatBehaviorBestFriend = this.getBestFriendFromJID(this.bestFriendJID);
         var _loc7_:int = _loc6_.message_count_rcvd + _loc6_.message_count_sent;
         if(_loc7_ < _loc5_)
         {
            this.bestFriendJID = param1;
         }
      }
      
      public function incrementChatStartByReceivedMessage_InASession(param1:String) : void
      {
         if(!this.hasAlreadyChattedWithUser(param1))
         {
            incrementCounter(CHAT_WINDOW_OPENED_VIA_MESSAGE_RECEIVED_COUNT);
         }
      }
      
      private function setChatSendVSReceivePref(param1:Boolean) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc2_:String = param1 ? CHAT_MESSAGES_BEST_FRIEND_SENT : CHAT_MESSAGES_TOTAL_SENT_COUNT;
         var _loc3_:String = param1 ? CHAT_MESSAGES_BEST_FRIEND_RECEIVED : CHAT_MESSAGES_TOTAL_RECEIVED_COUNT;
         var _loc4_:String = param1 ? CHAT_MESSAGES_BEST_FRIEND_SEND_VS_RECEIVE : CHAT_MESSAGES_TOTAL_SEND_VS_RECEIVE_PREFERENCE;
         if(this.hasHadChatActions())
         {
            _loc5_ = ["RECEIVER","NEUTRAL","SENDER"];
            _loc6_ = Number(getCounterValue(_loc2_));
            _loc7_ = Number(getCounterValue(_loc3_));
            if(isNaN(_loc6_))
            {
               _loc6_ = 0;
            }
            if(isNaN(_loc7_))
            {
               _loc7_ = 0;
            }
            _loc8_ = int(_loc5_.length * _loc6_ / (_loc7_ + _loc6_));
            setProperty(_loc4_,_loc5_[Math.min(_loc8_,_loc5_.length - 1)]);
         }
      }
   }
}

