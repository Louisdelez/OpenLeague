package com.riotgames.pvpnet.tracking.trackers.friend
{
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class FriendListBehaviorTracker extends SessionTimeframedTracker implements IFriendListBehaviorTracker
   {
      
      public static const NUMBER_OF_FRIENDS_A_USER_HAS_IN_A_SESSION:String = "number_of_friends_a_user_has_in_a_session";
      
      public static const USER_HAS_FRIENDS_ONLINE:String = "user_has_friends_online";
      
      public static const BUDDY_GROUP_CREATED:String = "buddy_group_created";
      
      public static const BUDDY_GROUP_DELETED:String = "buddy_group_deleted";
      
      public static const BUDDY_GROUP_COUNT:String = "buddy_group_count";
      
      public static const BUDDY_GROUP_GAME_INVITE_SENT:String = "buddy_group_game_invite_sent";
      
      public static const BUDDY_GROUP_CHAT_INVITE_SENT:String = "buddy_group_chat_invite_sent";
      
      public static const FRIEND_ADD_CLICKED:String = "friend_add_clicked";
      
      public static const FRIEND_REMOVED:String = "friend_removed";
      
      public static const FRIEND_IGNORED:String = "friend_ignored";
      
      public static const FRIEND_UNIGNORED:String = "friend_unignored";
      
      public static const FRIEND_SEARCH:String = "friend_search";
      
      public static const FRIEND_TOOLTIP_LOOKED:String = "friend_tooltip_looked";
      
      public static const FRIEND_GAME_INVITE_SENT:String = "friend_game_invite_sent";
      
      public static const FRIEND_PROFILE_VIEWED:String = "friend_profile_viewed";
      
      public static const FRIEND_GAME_SPECTATE:String = "friend_game_spectate";
      
      public static const FRIEND_MOVED_TO_GROUP:String = "friend_moved_to_group";
      
      public static const FRIEND_CHAT_INVITE_SENT:String = "friend_chat_invite_sent";
      
      public static const STATUS_MESSAGE_CHANGED:String = "status_message_changed";
      
      public static const BUDDY_NOTE_CREATED:String = "buddy_note_created";
      
      public static const BUDDY_NOTE_LOOKED:String = "buddy_note_looked";
      
      public static const FRIEND_REQUEST_RECEIVED:String = "friend_request_received";
      
      public static const FRIEND_REQUEST_ACCEPTED:String = "friend_request_accepted";
      
      public static const FRIEND_REQUEST_DENIED:String = "friend_request_denied";
      
      public static const FRIEND_REQUEST_SENT:String = "friend_request_sent";
      
      public static const FRIEND_REQUEST_PENDING_COUNT:String = "friend_request_pending_count";
      
      public static const FRIEND_REQUEST_DENY_CHAIN_COUNT:String = "friend_request_deny_chain_count";
      
      public static const RECENT_PLAYERS_LIST_TAB_CLICKED:String = "recent_players_list_tab_clicked";
      
      public static const IGNORED_PLAYERS_LIST_TAB_CLICKED:String = "ignored_players_list_tab_clicked";
      
      public static const ADD_FRIEND_FROM_GROUP_CHAT_CLICKED:String = "add_friend_from_group_chat_clicked";
      
      public static const VIEW_USER_PROFILE_FROM_GROUP_CHAT_CLICKED:String = "view_user_profile_from_group_chat_clicked";
      
      public static const IGNORE_FRIEND_FROM_GROUP_CHAT_CLICKED:String = "ignore_friend_from_group_chat_clicked";
      
      public static const UNIGNORE_FRIEND_FROM_GROUP_CHAT_CLICKED:String = "unignore_friend_from_group_chat_clicked";
      
      public static const FRIEND_LIST_BUTTON_CLICKED:String = "friend_list_button_clicked";
      
      public static const FRIEND_LIST_TAB_CLOSED:String = "friend_list_tab_closed";
      
      public static const CHAT_ROOM_BUTTON_CLICKED:String = "chat_room_button_clicked";
      
      public static const CHAT_ROOM_TAB_CLOSED:String = "chat_room_tab_closed";
      
      public static const FRIEND_LIST_CHAT_ROOM_TAB_SWITCH:String = "friend_list_chat_room_tab_switch";
      
      private var lastTabClickedIndex:int = -1;
      
      private var isChainClickingDeny:Boolean = false;
      
      private var chainClickingDenyCount:int = 0;
      
      public function FriendListBehaviorTracker(param1:Boolean = true)
      {
         super("friendslist_behavior",param1);
         isTimer = false;
      }
      
      public function incrementFriendGameSpectate_InASession() : void
      {
         incrementCounter(FRIEND_GAME_SPECTATE);
      }
      
      public function incrementFriendTooltipLooked_InASession() : void
      {
         incrementCounter(FRIEND_TOOLTIP_LOOKED);
      }
      
      public function incrementFriendAddClicked_InASession() : void
      {
         incrementCounter(FRIEND_ADD_CLICKED);
      }
      
      public function incrementBuddyGroupDeleted_InASession() : void
      {
         incrementCounter(BUDDY_GROUP_DELETED);
         this.setBuddyGroupCount((getProperty(BUDDY_GROUP_COUNT) as int) - 1);
      }
      
      public function incrementChatRoomTabClosed_InASession() : void
      {
         incrementCounter(CHAT_ROOM_TAB_CLOSED);
      }
      
      public function incrementBuddyNoteLooked_InASession() : void
      {
         incrementCounter(BUDDY_NOTE_LOOKED);
      }
      
      public function incrementBuddyNoteCreated_InASession() : void
      {
         incrementCounter(BUDDY_NOTE_CREATED);
      }
      
      public function incrementFriendMovedToGroup_InASession() : void
      {
         incrementCounter(FRIEND_MOVED_TO_GROUP);
      }
      
      public function incrementFriendListButtonClicked_InASession() : void
      {
         incrementCounter(FRIEND_LIST_BUTTON_CLICKED);
         if(this.lastTabClickedIndex == 1)
         {
            incrementCounter(FRIEND_LIST_CHAT_ROOM_TAB_SWITCH);
         }
         this.lastTabClickedIndex = 0;
      }
      
      public function incrementFriendGameInviteSent_InASession() : void
      {
         incrementCounter(FRIEND_GAME_INVITE_SENT);
      }
      
      public function incrementIgnoreFriendFromGroupChatClicked_InASession() : void
      {
         incrementCounter(IGNORE_FRIEND_FROM_GROUP_CHAT_CLICKED);
      }
      
      override public function sessionClosed() : void
      {
         this.checkDenyChainClicking();
         super.sessionClosed();
      }
      
      public function incrementFriendRequestSent_InASession() : void
      {
         incrementCounter(FRIEND_REQUEST_SENT);
      }
      
      public function incrementRecentPlayersListTabClicked_InASession() : void
      {
         incrementCounter(RECENT_PLAYERS_LIST_TAB_CLICKED);
      }
      
      public function incrementAddFriendFromGroupChatClicked_InASession() : void
      {
         incrementCounter(ADD_FRIEND_FROM_GROUP_CHAT_CLICKED);
      }
      
      public function incrementFriendRequestAccepted_InASession() : void
      {
         incrementCounter(FRIEND_REQUEST_ACCEPTED);
         decrementCounter(FRIEND_REQUEST_PENDING_COUNT);
         this.checkDenyChainClicking();
      }
      
      public function incrementFriendChatInviteSent_InASession() : void
      {
         incrementCounter(FRIEND_CHAT_INVITE_SENT);
      }
      
      public function incrementFriendIgnored_InASession() : void
      {
         incrementCounter(FRIEND_IGNORED);
      }
      
      public function incrementFriendRequestDenied_InASession() : void
      {
         incrementCounter(FRIEND_REQUEST_DENIED);
         decrementCounter(FRIEND_REQUEST_PENDING_COUNT);
         this.isChainClickingDeny = true;
         ++this.chainClickingDenyCount;
      }
      
      public function incrementFriendRequestReceived_InASession() : void
      {
         incrementCounter(FRIEND_REQUEST_RECEIVED);
         incrementCounter(FRIEND_REQUEST_PENDING_COUNT);
      }
      
      public function incrementUnignoreFriendFromGroupChatClicked_InASession() : void
      {
         incrementCounter(UNIGNORE_FRIEND_FROM_GROUP_CHAT_CLICKED);
      }
      
      public function incrementChatRoomButtonClicked_InASession() : void
      {
         incrementCounter(CHAT_ROOM_BUTTON_CLICKED);
         if(this.lastTabClickedIndex == 0)
         {
            incrementCounter(FRIEND_LIST_CHAT_ROOM_TAB_SWITCH);
         }
         this.lastTabClickedIndex = 1;
      }
      
      public function incrementFriendListTabClosed_InASession() : void
      {
         incrementCounter(FRIEND_LIST_TAB_CLOSED);
      }
      
      public function incrementFriendUnignored_InASession() : void
      {
         incrementCounter(FRIEND_UNIGNORED);
      }
      
      public function incrementViewUserProfileFromGroupChatClicked_InASession() : void
      {
         incrementCounter(VIEW_USER_PROFILE_FROM_GROUP_CHAT_CLICKED);
      }
      
      public function incrementIgnoredPlayersListTabClicked_InASession() : void
      {
         incrementCounter(IGNORED_PLAYERS_LIST_TAB_CLICKED);
      }
      
      public function setNumberOfFriendsUserHas_InASession(param1:uint) : void
      {
         setCounterValue(NUMBER_OF_FRIENDS_A_USER_HAS_IN_A_SESSION,param1);
      }
      
      public function incrementBuddyGroupChatInviteSent_InASession() : void
      {
         incrementCounter(BUDDY_GROUP_CHAT_INVITE_SENT);
      }
      
      public function incrementFriendRemoved_InASession() : void
      {
         incrementCounter(FRIEND_REMOVED);
      }
      
      private function checkDenyChainClicking() : void
      {
         if(this.isChainClickingDeny && this.chainClickingDenyCount > 1)
         {
            recordValue(FRIEND_REQUEST_DENY_CHAIN_COUNT,this.chainClickingDenyCount);
         }
         this.isChainClickingDeny = false;
         this.chainClickingDenyCount = 0;
      }
      
      public function incrementFriendSearch_InASession() : void
      {
         incrementCounter(FRIEND_SEARCH);
      }
      
      public function setFriendsOnlineUserHas_InASession(param1:uint) : void
      {
         recordValue(USER_HAS_FRIENDS_ONLINE,param1);
      }
      
      public function incrementBuddyGroupCreated_InASession() : void
      {
         incrementCounter(BUDDY_GROUP_CREATED);
         this.setBuddyGroupCount((getProperty(BUDDY_GROUP_COUNT) as int) + 1);
      }
      
      public function incrementStatusMessageChanged_InASession() : void
      {
         incrementCounter(STATUS_MESSAGE_CHANGED);
      }
      
      public function setBuddyGroupCount(param1:int) : void
      {
         setProperty(BUDDY_GROUP_COUNT,param1);
      }
      
      public function incrementFriendProfileViewed_InASession() : void
      {
         incrementCounter(FRIEND_PROFILE_VIEWED);
      }
      
      public function incrementBuddyGroupGameInviteSent_InASession() : void
      {
         incrementCounter(BUDDY_GROUP_GAME_INVITE_SENT);
      }
   }
}

