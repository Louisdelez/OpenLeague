package com.riotgames.pvpnet.tracking.trackers.friend
{
   public interface IFriendListBehaviorTracker
   {
      
      function setNumberOfFriendsUserHas_InASession(param1:uint) : void;
      
      function setFriendsOnlineUserHas_InASession(param1:uint) : void;
      
      function incrementBuddyGroupCreated_InASession() : void;
      
      function incrementBuddyGroupDeleted_InASession() : void;
      
      function incrementBuddyGroupGameInviteSent_InASession() : void;
      
      function incrementBuddyGroupChatInviteSent_InASession() : void;
      
      function incrementFriendAddClicked_InASession() : void;
      
      function incrementFriendRemoved_InASession() : void;
      
      function incrementFriendIgnored_InASession() : void;
      
      function incrementFriendUnignored_InASession() : void;
      
      function incrementFriendSearch_InASession() : void;
      
      function incrementFriendTooltipLooked_InASession() : void;
      
      function incrementFriendGameInviteSent_InASession() : void;
      
      function incrementFriendProfileViewed_InASession() : void;
      
      function incrementFriendGameSpectate_InASession() : void;
      
      function incrementFriendMovedToGroup_InASession() : void;
      
      function incrementFriendChatInviteSent_InASession() : void;
      
      function incrementStatusMessageChanged_InASession() : void;
      
      function incrementBuddyNoteCreated_InASession() : void;
      
      function incrementBuddyNoteLooked_InASession() : void;
      
      function incrementFriendRequestReceived_InASession() : void;
      
      function incrementFriendRequestAccepted_InASession() : void;
      
      function incrementFriendRequestDenied_InASession() : void;
      
      function incrementFriendRequestSent_InASession() : void;
      
      function incrementRecentPlayersListTabClicked_InASession() : void;
      
      function incrementIgnoredPlayersListTabClicked_InASession() : void;
      
      function incrementAddFriendFromGroupChatClicked_InASession() : void;
      
      function incrementViewUserProfileFromGroupChatClicked_InASession() : void;
      
      function incrementIgnoreFriendFromGroupChatClicked_InASession() : void;
      
      function incrementUnignoreFriendFromGroupChatClicked_InASession() : void;
      
      function incrementFriendListButtonClicked_InASession() : void;
      
      function incrementChatRoomButtonClicked_InASession() : void;
      
      function incrementFriendListTabClosed_InASession() : void;
      
      function incrementChatRoomTabClosed_InASession() : void;
   }
}

