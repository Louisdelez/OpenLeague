package com.riotgames.platform.gameclient.chat.views
{
   import blix.ds.IListX;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.BuddyGroup;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomInfo;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomListViewModel;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.provider.IProvider;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public interface ChatViewMediator extends IProvider
   {
      
      function updateRosterNoteOnBuddy(param1:Buddy, param2:String) : void;
      
      function getPrivacyListChanged() : ISignal;
      
      function getTotalChatViews() : ArrayCollection;
      
      function inviteGroupToChat(param1:BuddyGroup) : void;
      
      function getPresenceUpdated() : ISignal;
      
      function getBuddyGroups() : IListX;
      
      function moveBuddyToGroup(param1:Buddy, param2:String) : void;
      
      function inviteBuddyToChat(param1:Buddy, param2:String = "pu", param3:String = null) : void;
      
      function getOnlineBuddyCount() : int;
      
      function ignoreBuddy(param1:Buddy) : void;
      
      function getCurrentStatus() : String;
      
      function get chatPrompts() : ArrayCollection;
      
      function openChatRoomByName(param1:String, param2:String) : void;
      
      function removeBuddy(param1:Buddy) : void;
      
      function getSummonerStatusMessageChanged() : ISignal;
      
      function ignoreBuddyBySummonerName(param1:String) : void;
      
      function addBuddy(param1:String, param2:String = null) : void;
      
      function getCurrentChatModelChanged() : ISignal;
      
      function getCurrentPresenceData() : PresenceStatusData;
      
      function closeChatRoomBySubject(param1:String, param2:String = "pu") : void;
      
      function getCurrentChatModel() : Object;
      
      function inviteBuddyToGame(param1:Buddy) : void;
      
      function getPrivacyList() : ArrayCollection;
      
      function emptyAndRemoveGroup(param1:String) : void;
      
      function reconnectToChat() : void;
      
      function canInviteBuddyToGame(param1:Buddy) : Boolean;
      
      function get recentChatPrompts() : ArrayCollection;
      
      function openChatRoom(param1:ChatRoomInfo) : void;
      
      function setCurrentChatModel(param1:Object) : void;
      
      function getOnlineBuddyCountChanged() : ISignal;
      
      function viewProfile(param1:Buddy) : void;
      
      function getSummonerNameChanged() : ISignal;
      
      function isBuddyEligibleQueuePartner(param1:Buddy) : Boolean;
      
      function spectateGameByBuddy(param1:Buddy) : void;
      
      function setSummonerStatusMessage(param1:String) : void;
      
      function getRecentlyPlayedList() : ArrayCollection;
      
      function createPersonalPopUp(param1:String, param2:Boolean = false) : void;
      
      function markChatPromptAsRead(param1:DockedPrompt) : void;
      
      function closePersonalPopupWindow(param1:UnescapedJID) : void;
      
      function getChatRoomListViewModel() : ChatRoomListViewModel;
      
      function getSummonerStatusMessage() : String;
      
      function openBuddyList() : void;
      
      function getPrivacyListController() : PrivacyListController;
      
      function getCurrentStatusChanged() : ISignal;
      
      function renameGroup(param1:BuddyGroup, param2:String) : Boolean;
      
      function deleteRecentChatPrompt(param1:Object) : void;
      
      function getDefaultGroupName() : String;
      
      function deleteChatPrompt(param1:Object) : void;
      
      function canDropInSpectateBuddy(param1:Buddy) : Boolean;
      
      function getChatControllerStartFocused() : Boolean;
      
      function getSummonerName() : String;
      
      function moveGroupUp(param1:BuddyGroup) : void;
      
      function createBuddyGroup(param1:String) : Boolean;
      
      function moveGroupDown(param1:BuddyGroup) : void;
      
      function cycleStatus() : void;
      
      function isCustomRosterGroup(param1:BuddyGroup) : Boolean;
      
      function getOfflineGroupName() : String;
      
      function unblockUser(param1:PrivacyListItem) : void;
   }
}

