package com.riotgames.platform.gameclient.chat.trackers
{
   import com.riotgames.platform.gameclient.chat.domain.AutojoinChatDesc;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   import com.riotgames.pvpnet.tracker.Tracker;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import flash.utils.Dictionary;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class GroupChatBehaviorTracker extends SessionTimeframedTracker
   {
      
      private static var _instance:GroupChatBehaviorTracker;
      
      public static const CHAT_PUBLIC_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT:String = "public_room_total_attempted_to_join.count";
      
      public static const CHAT_PUBLIC_ROOM_TOTAL_FOCUSED_DURATION:String = "public_room_total_focused.duration";
      
      public static const CHAT_PUBLIC_ROOM_TOTAL_DURATION:String = "public_room_total.duration";
      
      public static const CHAT_PUBLIC_ROOM_MESSAGES_SENT_COUNT:String = "public_room_messages_sent.count";
      
      public static const CHAT_PUBLIC_ROOM_PROFILES_VIEWED_COUNT:String = "public_room_profiles_viewed.count";
      
      public static const CHAT_PUBLIC_ROOM_FRIENDS_ADDED_COUNT:String = "public_room_friends_added.count";
      
      public static const CHAT_PUBLIC_ROOM_IGNORES_COUNT:String = "public_room_ignores.count";
      
      public static const CHAT_STRATEGY_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT:String = "strategy_room_total_attempted_to_join.count";
      
      public static const CHAT_STRATEGY_ROOM_TOTAL_FOCUSED_DURATION:String = "strategy_room_total_focused.duration";
      
      public static const CHAT_STRATEGY_ROOM_TOTAL_DURATION:String = "strategy_room_total.duration";
      
      public static const CHAT_STRATEGY_ROOM_MESSAGES_SENT_COUNT:String = "strategy_room_messages_sent.count";
      
      public static const CHAT_STRATEGY_ROOM_PROFILES_VIEWED_COUNT:String = "strategy_room_profiles_viewed.count";
      
      public static const CHAT_STRATEGY_ROOM_FRIENDS_ADDED_COUNT:String = "strategy_room_friends_added.count";
      
      public static const CHAT_STRATEGY_ROOM_IGNORES_COUNT:String = "strategy_ignores.count";
      
      public static const CHAT_STRATEGY_ROOM_AUTOJOIN_BOOLEAN:String = "strategy_room_autojoin.boolean";
      
      public static const CHAT_NOOB_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT:String = "noob_room_total_attempted_to_join.count";
      
      public static const CHAT_NOOB_ROOM_TOTAL_FOCUSED_DURATION:String = "noob_room_total_focused.duration";
      
      public static const CHAT_NOOB_ROOM_TOTAL_DURATION:String = "noob_room_total.duration";
      
      public static const CHAT_NOOB_ROOM_MESSAGES_SENT_COUNT:String = "noob_room_messages_sent.count";
      
      public static const CHAT_NOOB_ROOM_PROFILES_VIEWED_COUNT:String = "noob_room_profiles_viewed.count";
      
      public static const CHAT_NOOB_ROOM_FRIENDS_ADDED_COUNT:String = "noob_room_friends_added.count";
      
      public static const CHAT_NOOB_ROOM_IGNORES_COUNT:String = "noob_room_ignores.count";
      
      public static const CHAT_NOOB_ROOM_AUTOJOIN_BOOLEAN:String = "noob_room_autojoin.boolean";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT:String = "looking_for_group_room_total_attempted_to_join.count";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_TOTAL_FOCUSED_DURATION:String = "looking_for_group_room_total_focused.duration";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_TOTAL_DURATION:String = "looking_for_group_room_total.duration";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_MESSAGES_SENT_COUNT:String = "looking_for_group_room_messages_sent.count";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_PROFILES_VIEWED_COUNT:String = "looking_for_group_room_profiles_viewed.count";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_FRIENDS_ADDED_COUNT:String = "looking_for_group_room_friends_added.count";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_IGNORES_COUNT:String = "looking_for_group_room_ignores.count";
      
      public static const CHAT_LOOKING_FOR_GROUP_ROOM_AUTOJOIN_BOOLEAN:String = "looking_for_group_room_autojoin.boolean";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT:String = "public_chat_1_room_total_attempted_to_join.count";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_TOTAL_FOCUSED_DURATION:String = "public_chat_1_room_total_focused.duration";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_TOTAL_DURATION:String = "public_chat_1_room_total.duration";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_MESSAGES_SENT_COUNT:String = "public_chat_1_room_messages_sent.count";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_PROFILES_VIEWED_COUNT:String = "public_chat_1_room_profiles_viewed.count";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_FRIENDS_ADDED_COUNT:String = "public_chat_1_room_friends_added.count";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_IGNORES_COUNT:String = "public_chat_1_room_ignores.count";
      
      public static const CHAT_PUBLIC_CHAT_1_ROOM_AUTOJOIN_BOOLEAN:String = "public_chat_1_room_autojoin.boolean";
      
      private static const GROUP_CHAT_JOIN_ATTEMPTS:int = 0;
      
      private static const GROUP_CHAT_TOTAL_FOCUSED:int = 1;
      
      private static const GROUP_CHAT_TOTAL_DURATION:int = 2;
      
      private static const GROUP_CHAT_SENT_COUNT:int = 3;
      
      private static const GROUP_CHAT_PROFILES_VIEWED:int = 4;
      
      private static const GROUP_CHAT_FRIENDS_ADDED:int = 5;
      
      private static const GROUP_CHAT_IGNORES:int = 6;
      
      private static const GROUP_CHAT_AUTOJOIN:int = 7;
      
      public static const CHAT_GROUP_CHAT_TOTAL_AUTOJOIN_COUNT:String = "group_chat_total_autojoin.count";
      
      public static const CHAT_GROUP_CHAT_OPENED_COUNT:String = "group_chat_opened.count";
      
      public static const CHAT_GROUP_CHAT_FOCUSED_DURATION:String = "group_chat_focused.duration";
      
      public static const CHAT_GROUP_CHAT_DURATION:String = "group_chat_total.duration";
      
      public static const CHAT_GROUP_CHAT_MESSAGES_TOTAL_COUNT:String = "group_chat_messages_total.count";
      
      public static const CHAT_GROUP_CHAT_MESSAGES_SENT_COUNT:String = "group_chat_messages_sent.count";
      
      public static const CHAT_NOISIEST_GROUP_CHAT_AUTOJOIN_BOOLEAN:String = "noisiest_group_chat_autojoin.boolean";
      
      public static const CHAT_NOISIEST_GROUP_CHAT_FOCUSED_DURATION:String = "noisiest_group_chat_focused.duration";
      
      public static const CHAT_NOISIEST_GROUP_CHAT_DURATION:String = "noisiest_group_chat_total.duration";
      
      public static const CHAT_NOISIEST_GROUP_CHAT_MESSAGES_TOTAL_COUNT:String = "noisiest_group_chat_messages_total.count";
      
      public static const CHAT_NOISIEST_GROUP_CHAT_MESSAGES_SENT_COUNT:String = "noisiest_group_chat_messages_sent.count";
      
      public static const CHAT_PRIVATE_CHAT_AUTOJOIN_BOOLEAN:String = "private_chat_autojoin.boolean";
      
      public static const CHAT_PRIVATE_CHAT_INVITED_COUNT:String = "private_chat_invited.count";
      
      public static const CHAT_PRIVATE_CHAT_FOCUSED_DURATION:String = "private_chat_focused.duration";
      
      public static const CHAT_PRIVATE_CHAT_DURATION:String = "private_chat_total.duration";
      
      public static const CHAT_PRIVATE_CHAT_MESSAGES_TOTAL_COUNT:String = "private_chat_messages_total.count";
      
      public static const CHAT_PRIVATE_CHAT_MESSAGES_SENT_COUNT:String = "private_chat_messages_sent.count";
      
      private var noisiestChatJID:UnescapedJID;
      
      private var default_chats_total_duration:Number = 0;
      
      private var default_chats_timer_last_start:Number = 0;
      
      private var public_chats_focused_duration:Number = 0;
      
      private var public_chats_num_windows:int = 0;
      
      private var public_chats_timer_active_last_start:Number = 0;
      
      private var privateChatName:String;
      
      private var chatNamesToTrackingStrings:Dictionary;
      
      private var default_chats_num_windows:int = 0;
      
      private var public_chats_total_duration:Number = 0;
      
      private var public_chats_timer_last_start:Number = 0;
      
      private var chatJIDsToEntries:Dictionary;
      
      private var default_chats_timer_active_last_start:* = 0;
      
      private var default_chats_focused_duration:Number = 0;
      
      public function GroupChatBehaviorTracker()
      {
         super("group_chat");
         this.chatJIDsToEntries = new Dictionary();
         this.chatNamesToTrackingStrings = new Dictionary();
         var _loc1_:String = ResourceManager.getInstance().getString("resources","chat_room_strategy").toLowerCase();
         var _loc2_:String = ResourceManager.getInstance().getString("resources","chat_room_noob").toLowerCase();
         var _loc3_:String = ResourceManager.getInstance().getString("resources","chat_room_lookingforgroup").toLowerCase();
         var _loc4_:String = ResourceManager.getInstance().getString("resources","chat_room_public_chat").toLowerCase();
         this.chatNamesToTrackingStrings[_loc1_] = new Array(CHAT_STRATEGY_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT,CHAT_STRATEGY_ROOM_TOTAL_FOCUSED_DURATION,CHAT_STRATEGY_ROOM_TOTAL_DURATION,CHAT_STRATEGY_ROOM_MESSAGES_SENT_COUNT,CHAT_STRATEGY_ROOM_PROFILES_VIEWED_COUNT,CHAT_STRATEGY_ROOM_FRIENDS_ADDED_COUNT,CHAT_STRATEGY_ROOM_IGNORES_COUNT,CHAT_STRATEGY_ROOM_AUTOJOIN_BOOLEAN);
         this.chatNamesToTrackingStrings[_loc4_] = new Array(CHAT_PUBLIC_CHAT_1_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT,CHAT_PUBLIC_CHAT_1_ROOM_TOTAL_FOCUSED_DURATION,CHAT_PUBLIC_CHAT_1_ROOM_TOTAL_DURATION,CHAT_PUBLIC_CHAT_1_ROOM_MESSAGES_SENT_COUNT,CHAT_PUBLIC_CHAT_1_ROOM_PROFILES_VIEWED_COUNT,CHAT_PUBLIC_CHAT_1_ROOM_FRIENDS_ADDED_COUNT,CHAT_PUBLIC_CHAT_1_ROOM_IGNORES_COUNT,CHAT_PUBLIC_CHAT_1_ROOM_AUTOJOIN_BOOLEAN);
         this.chatNamesToTrackingStrings[_loc3_] = new Array(CHAT_LOOKING_FOR_GROUP_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT,CHAT_LOOKING_FOR_GROUP_ROOM_TOTAL_FOCUSED_DURATION,CHAT_LOOKING_FOR_GROUP_ROOM_TOTAL_DURATION,CHAT_LOOKING_FOR_GROUP_ROOM_MESSAGES_SENT_COUNT,CHAT_LOOKING_FOR_GROUP_ROOM_PROFILES_VIEWED_COUNT,CHAT_LOOKING_FOR_GROUP_ROOM_FRIENDS_ADDED_COUNT,CHAT_LOOKING_FOR_GROUP_ROOM_IGNORES_COUNT,CHAT_LOOKING_FOR_GROUP_ROOM_AUTOJOIN_BOOLEAN);
         this.chatNamesToTrackingStrings[_loc2_] = new Array(CHAT_NOOB_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT,CHAT_NOOB_ROOM_TOTAL_FOCUSED_DURATION,CHAT_NOOB_ROOM_TOTAL_DURATION,CHAT_NOOB_ROOM_MESSAGES_SENT_COUNT,CHAT_NOOB_ROOM_PROFILES_VIEWED_COUNT,CHAT_NOOB_ROOM_FRIENDS_ADDED_COUNT,CHAT_NOOB_ROOM_IGNORES_COUNT,CHAT_NOOB_ROOM_AUTOJOIN_BOOLEAN);
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
      }
      
      public static function get instance() : GroupChatBehaviorTracker
      {
         if(_instance == null)
         {
            _instance = new GroupChatBehaviorTracker();
         }
         return _instance;
      }
      
      public function incrementJoinAttempts_InASession(param1:UnescapedJID) : void
      {
         var _loc2_:GroupChatBehaviorChatEntry = this.getGroupChatEntry(param1);
         var _loc3_:String = _loc2_.subject;
         if(this.chatNamesToTrackingStrings[_loc3_] != null)
         {
            incrementCounter(this.chatNamesToTrackingStrings[_loc3_][GROUP_CHAT_JOIN_ATTEMPTS]);
            incrementCounter(CHAT_PUBLIC_ROOM_TOTAL_ATTEMPTED_TO_JOIN_COUNT);
         }
      }
      
      public function incrementGroupChatMessageSent_InASession(param1:UnescapedJID, param2:String) : void
      {
         this.trackMessageToGroupChat(param1,true,param2);
      }
      
      public function incrementPublicChatRoomClosed_InASession(param1:UnescapedJID) : void
      {
         var _loc2_:Number = Number(_sessionMetrics.getActiveSessionElapsedTimeInMS());
         var _loc3_:Number = Number(_sessionMetrics.getSessionElapsedTimeInMS());
         var _loc4_:GroupChatBehaviorChatEntry = this.getGroupChatEntry(param1);
         _loc4_.is_open = false;
         _loc4_.focused_duration += _loc2_ - _loc4_.focused_last_start;
         _loc4_.duration += _loc3_ - _loc4_.last_start;
         if(this.chatNamesToTrackingStrings[_loc4_.subject] != null)
         {
            --this.default_chats_num_windows;
            if(this.default_chats_num_windows == 0)
            {
               this.default_chats_focused_duration += _loc2_ - this.default_chats_timer_active_last_start;
               this.default_chats_total_duration += _loc3_ - this.default_chats_timer_last_start;
            }
         }
         else
         {
            --this.public_chats_num_windows;
            if(this.public_chats_num_windows == 0)
            {
               this.public_chats_focused_duration += _loc2_ - this.public_chats_timer_active_last_start;
               this.public_chats_total_duration += _loc3_ - this.public_chats_timer_last_start;
            }
         }
      }
      
      public function incrementProfileViewedFromGroupChat(param1:UnescapedJID) : void
      {
         var _loc2_:String = this.getGroupChatEntry(param1).subject;
         if(this.chatNamesToTrackingStrings[_loc2_] == null)
         {
            return;
         }
         incrementCounter(this.chatNamesToTrackingStrings[_loc2_][GROUP_CHAT_PROFILES_VIEWED]);
         incrementCounter(CHAT_PUBLIC_ROOM_PROFILES_VIEWED_COUNT);
      }
      
      private function getGroupChatEntry(param1:UnescapedJID) : GroupChatBehaviorChatEntry
      {
         if(this.chatJIDsToEntries[param1] == null)
         {
            this.chatJIDsToEntries[param1] = new GroupChatBehaviorChatEntry();
         }
         return this.chatJIDsToEntries[param1];
      }
      
      public function incrementInvitedPeople_InASession(param1:UnescapedJID) : *
      {
         var _loc2_:GroupChatBehaviorChatEntry = this.getGroupChatEntry(param1);
         var _loc3_:String = _loc2_.subject;
         if(_loc3_ == this.privateChatName)
         {
            incrementCounter(CHAT_PRIVATE_CHAT_INVITED_COUNT);
         }
      }
      
      public function incrementFriendsAddedFromGroupChat(param1:UnescapedJID) : void
      {
         var _loc2_:String = this.getGroupChatEntry(param1).subject;
         if(this.chatNamesToTrackingStrings[_loc2_] == null)
         {
            return;
         }
         incrementCounter(this.chatNamesToTrackingStrings[_loc2_][GROUP_CHAT_FRIENDS_ADDED]);
         incrementCounter(CHAT_PUBLIC_ROOM_FRIENDS_ADDED_COUNT);
      }
      
      public function incrementGroupChatMessageReceived_InASession(param1:UnescapedJID, param2:String) : void
      {
         this.trackMessageToGroupChat(param1,false,param2);
      }
      
      public function setPrivateChatName(param1:String) : void
      {
         this.privateChatName = param1;
      }
      
      override public function sessionClosed() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:GroupChatBehaviorChatEntry = null;
         var _loc3_:AutojoinChatDesc = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:GroupChatBehaviorChatEntry = null;
         while(_loc1_ < UserPreferencesManager.userPrefs.autoJoinList.length)
         {
            _loc3_ = UserPreferencesManager.userPrefs.autoJoinList[_loc1_];
            _loc4_ = _loc3_.roomSubject.toLowerCase();
            if(this.chatNamesToTrackingStrings[_loc4_] != null)
            {
               setProperty(this.chatNamesToTrackingStrings[_loc4_][GROUP_CHAT_AUTOJOIN],true);
            }
            else if(_loc4_ == this.privateChatName)
            {
               setProperty(CHAT_PRIVATE_CHAT_AUTOJOIN_BOOLEAN,true);
            }
            else
            {
               incrementCounter(CHAT_GROUP_CHAT_TOTAL_AUTOJOIN_COUNT);
               if(this.noisiestChatJID != null && _loc4_ == this.chatJIDsToEntries[this.noisiestChatJID].subject)
               {
                  setProperty(CHAT_NOISIEST_GROUP_CHAT_AUTOJOIN_BOOLEAN,true);
               }
            }
            _loc1_++;
         }
         for each(_loc2_ in this.chatJIDsToEntries)
         {
            if(_loc2_.last_start != 0)
            {
               if(_loc2_.is_open)
               {
                  _loc2_.focused_duration += _sessionMetrics.getActiveSessionElapsedTimeInMS() - _loc2_.focused_last_start;
                  _loc2_.duration += _sessionMetrics.getSessionElapsedTimeInMS() - _loc2_.last_start;
                  _loc2_.is_open = false;
               }
               if(this.chatNamesToTrackingStrings[_loc2_.subject] != null)
               {
                  _loc5_ = this.chatNamesToTrackingStrings[_loc2_.subject][GROUP_CHAT_TOTAL_FOCUSED];
                  _loc6_ = this.chatNamesToTrackingStrings[_loc2_.subject][GROUP_CHAT_TOTAL_DURATION];
                  setProperty(_loc5_,_loc2_.focused_duration);
                  setProperty(_loc6_,_loc2_.duration);
               }
               else if(_loc2_.subject == this.privateChatName)
               {
                  setProperty(CHAT_PRIVATE_CHAT_FOCUSED_DURATION,_loc2_.focused_duration);
                  setProperty(CHAT_PRIVATE_CHAT_DURATION,_loc2_.duration);
               }
            }
         }
         if(Boolean(this.default_chats_num_windows))
         {
            this.default_chats_focused_duration = _sessionMetrics.getActiveSessionElapsedTimeInMS() - this.default_chats_timer_active_last_start;
            this.default_chats_total_duration = _sessionMetrics.getSessionElapsedTimeInMS() - this.default_chats_timer_last_start;
         }
         if(Boolean(this.default_chats_focused_duration))
         {
            setProperty(CHAT_PUBLIC_ROOM_TOTAL_FOCUSED_DURATION,this.default_chats_focused_duration);
            setProperty(CHAT_PUBLIC_ROOM_TOTAL_DURATION,this.default_chats_total_duration);
         }
         if(Boolean(this.public_chats_num_windows))
         {
            this.public_chats_focused_duration = _sessionMetrics.getActiveSessionElapsedTimeInMS() - this.public_chats_timer_active_last_start;
            this.public_chats_total_duration = _sessionMetrics.getSessionElapsedTimeInMS() - this.public_chats_timer_last_start;
         }
         if(Boolean(this.public_chats_focused_duration))
         {
            setProperty(CHAT_GROUP_CHAT_FOCUSED_DURATION,this.public_chats_focused_duration);
            setProperty(CHAT_GROUP_CHAT_DURATION,this.public_chats_total_duration);
         }
         if(this.noisiestChatJID != null)
         {
            _loc7_ = this.getGroupChatEntry(this.noisiestChatJID);
            setCounterValue(CHAT_NOISIEST_GROUP_CHAT_MESSAGES_TOTAL_COUNT,_loc7_.messages_total);
            setCounterValue(CHAT_NOISIEST_GROUP_CHAT_MESSAGES_SENT_COUNT,_loc7_.messages_sent);
            setProperty(CHAT_NOISIEST_GROUP_CHAT_FOCUSED_DURATION,_loc7_.focused_duration);
            setProperty(CHAT_NOISIEST_GROUP_CHAT_DURATION,_loc7_.duration);
         }
         super.sessionClosed();
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         var _loc2_:Tracker = param1.getChatTracker() as Tracker;
         _loc2_.addChildTrackerToCollection(this);
         this.sendable = false;
      }
      
      public function incrementIgnoredFromGroupChat(param1:UnescapedJID) : void
      {
         var _loc2_:String = this.getGroupChatEntry(param1).subject;
         if(this.chatNamesToTrackingStrings[_loc2_] == null)
         {
            return;
         }
         incrementCounter(this.chatNamesToTrackingStrings[_loc2_][GROUP_CHAT_IGNORES]);
         incrementCounter(CHAT_PUBLIC_ROOM_IGNORES_COUNT);
      }
      
      private function trackMessageToGroupChat(param1:UnescapedJID, param2:Boolean, param3:String) : void
      {
         var _loc6_:GroupChatBehaviorChatEntry = null;
         var _loc4_:GroupChatBehaviorChatEntry = this.getGroupChatEntry(param1);
         var _loc5_:String = _loc4_.subject.toLowerCase();
         if(this.chatNamesToTrackingStrings[_loc5_] == null && _loc5_ != this.privateChatName)
         {
            if(this.noisiestChatJID == null)
            {
               this.noisiestChatJID = param1;
            }
            if(param2)
            {
               _loc4_.messages_sent += 1;
               incrementCounter(CHAT_GROUP_CHAT_MESSAGES_SENT_COUNT);
            }
            _loc4_.messages_total += 1;
            incrementCounter(CHAT_GROUP_CHAT_MESSAGES_TOTAL_COUNT);
            _loc6_ = this.getGroupChatEntry(this.noisiestChatJID);
            if(_loc6_.messages_total < _loc4_.messages_total)
            {
               this.noisiestChatJID = param1;
            }
            return;
         }
         if(_loc5_ == this.privateChatName)
         {
            incrementCounter(CHAT_PRIVATE_CHAT_MESSAGES_TOTAL_COUNT);
            if(param2)
            {
               incrementCounter(CHAT_PRIVATE_CHAT_MESSAGES_SENT_COUNT);
            }
            return;
         }
         if(param2)
         {
            incrementCounter(this.chatNamesToTrackingStrings[_loc5_][GROUP_CHAT_SENT_COUNT]);
            incrementCounter(CHAT_PUBLIC_ROOM_MESSAGES_SENT_COUNT);
         }
      }
      
      public function incrementPublicChatRoomsVisited_InASession(param1:String, param2:UnescapedJID) : void
      {
         param1 = param1.toLowerCase();
         if(this.chatJIDsToEntries[param2] == null && this.chatNamesToTrackingStrings[param1] == null)
         {
            incrementCounter(CHAT_GROUP_CHAT_OPENED_COUNT);
         }
         var _loc3_:GroupChatBehaviorChatEntry = this.getGroupChatEntry(param2);
         var _loc4_:Number = Number(_sessionMetrics.getActiveSessionElapsedTimeInMS());
         var _loc5_:Number = Number(_sessionMetrics.getSessionElapsedTimeInMS());
         _loc3_.subject = param1;
         _loc3_.is_open = true;
         _loc3_.last_start = _loc5_;
         _loc3_.focused_last_start = _loc4_;
         if(this.chatNamesToTrackingStrings[param1] != null)
         {
            if(this.default_chats_num_windows == 0)
            {
               this.default_chats_timer_last_start = _loc5_;
               this.default_chats_timer_active_last_start = _loc4_;
            }
            ++this.default_chats_num_windows;
         }
         else
         {
            if(this.public_chats_num_windows == 0)
            {
               this.public_chats_timer_last_start = _loc5_;
               this.public_chats_timer_active_last_start = _loc4_;
            }
            ++this.public_chats_num_windows;
         }
      }
   }
}

