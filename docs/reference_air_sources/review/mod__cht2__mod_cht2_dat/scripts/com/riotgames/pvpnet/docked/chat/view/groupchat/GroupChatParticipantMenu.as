package com.riotgames.pvpnet.docked.chat.view.groupchat
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.trackers.GroupChatBehaviorTracker;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class GroupChatParticipantMenu extends NativeMenu
   {
      
      private var _viewMediator:ChatViewMediator;
      
      private var _occupant:RoomOccupant;
      
      private var _ignoreUserMenuItem:NativeMenuItem;
      
      public function GroupChatParticipantMenu(param1:RoomOccupant, param2:ChatViewMediator)
      {
         super();
         this._occupant = param1;
         this._viewMediator = param2;
         var _loc3_:Buddy = RosterUtility.getBuddy(this._occupant.rosterItem);
         var _loc4_:String = this._viewMediator.isBuddyEligibleQueuePartner(_loc3_) ? RiotResourceLoader.getString("BuddyListTreeRenderer_itemInviteToGame") : RiotResourceLoader.getString("BuddyListTreeRenderer_ineligible_partner","**Ineligible duo partner");
         this.buildMenuItem(this,_loc4_,this.onInviteToGame,!this.isMe(this._occupant) && Boolean(this._viewMediator.canInviteBuddyToGame(_loc3_)));
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemSendMessage"),this.onSendMessage,!this.isMe(this._occupant) && Boolean(_loc3_.getIsOnline()) && Boolean(_loc3_.getIsMutualFriend()));
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_viewProfile"),this.onViewProfile,LobbyConfig.instance.isSummonerSearchEnabled);
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_groupAddBuddy"),this.onAddBuddy,!this.isMe(this._occupant) && !_loc3_.getIsMutualFriend());
         this._ignoreUserMenuItem = this.buildMenuItem(this,RiotResourceLoader.getString("summonerContext_blockUser_label"),this.onIgnoreUser,!this.isMe(this._occupant));
         this.updateBlockPlayerMenuItem();
      }
      
      private function onInviteToGame(param1:Event) : void
      {
         var _loc2_:Buddy = RosterUtility.getBuddy(this._occupant.rosterItem);
         this._viewMediator.inviteBuddyToGame(_loc2_);
      }
      
      private function onSendMessage(param1:Event) : void
      {
         this._viewMediator.createPersonalPopUp(this._occupant.jid.bareJID,true);
      }
      
      private function onViewProfile(param1:Event) : void
      {
         var _loc2_:Buddy = RosterUtility.getBuddy(this._occupant.rosterItem);
         this._viewMediator.viewProfile(_loc2_);
         GroupChatBehaviorTracker.instance.incrementProfileViewedFromGroupChat(this._occupant.room.roomJID);
      }
      
      private function onAddBuddy(param1:Event) : void
      {
         this._viewMediator.addBuddy(this._occupant.displayName);
         GroupChatBehaviorTracker.instance.incrementFriendsAddedFromGroupChat(this._occupant.room.roomJID);
      }
      
      private function onIgnoreUser(param1:Event) : void
      {
         if(!this._viewMediator.getPrivacyListController().isBlocked(this._occupant.jid.bareJID))
         {
            this._viewMediator.getPrivacyListController().blockAndConfirm(this._occupant.jid.bareJID,this._occupant.displayName,this.updateBlockPlayerMenuItem);
         }
         else
         {
            this._viewMediator.getPrivacyListController().unblock(this._occupant.jid.bareJID);
            this.updateBlockPlayerMenuItem();
         }
         GroupChatBehaviorTracker.instance.incrementIgnoredFromGroupChat(this._occupant.room.roomJID);
      }
      
      private function updateBlockPlayerMenuItem(... rest) : void
      {
         if(!this._viewMediator.getPrivacyListController().isBlocked(this._occupant.jid.bareJID))
         {
            this._ignoreUserMenuItem.label = RiotResourceLoader.getString("summonerContext_blockUser_label");
         }
         else
         {
            this._ignoreUserMenuItem.label = RiotResourceLoader.getString("summonerContext_unblockUser_label");
         }
      }
      
      private function isMe(param1:RoomOccupant) : Boolean
      {
         return param1.displayName == param1.room.nickname;
      }
      
      private function buildMenuItem(param1:NativeMenu, param2:String, param3:Function, param4:Boolean) : NativeMenuItem
      {
         var _loc5_:NativeMenuItem = new NativeMenuItem(param2);
         _loc5_.enabled = param4;
         param1.addItem(_loc5_);
         if(param3 != null)
         {
            _loc5_.addEventListener(Event.SELECT,param3,false,0,true);
         }
         return _loc5_;
      }
   }
}

