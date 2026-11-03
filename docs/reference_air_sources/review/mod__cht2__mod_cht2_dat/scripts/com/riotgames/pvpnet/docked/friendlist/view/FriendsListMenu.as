package com.riotgames.pvpnet.docked.friendlist.view
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.BuddyGroup;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   import mx.resources.ResourceManager;
   
   public class FriendsListMenu extends NativeMenu
   {
      
      private var _buddy:Buddy;
      
      private var _viewMediator:ChatViewMediator;
      
      private var _editNoteSelect:Signal = new Signal();
      
      public function FriendsListMenu(param1:Buddy, param2:ChatViewMediator)
      {
         var _loc4_:NativeMenuItem = null;
         super();
         this._buddy = param1;
         this._viewMediator = param2;
         var _loc3_:String = this._viewMediator.isBuddyEligibleQueuePartner(this._buddy) ? RiotResourceLoader.getString("BuddyListTreeRenderer_itemInviteToGame") : RiotResourceLoader.getString("BuddyListTreeRenderer_ineligible_partner","**Ineligible duo partner");
         this.buildMenuItem(this,_loc3_,this.onInviteToGameMenuItemSelected,this._viewMediator.canInviteBuddyToGame(this._buddy));
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemSendMessage"),this.onSendMessageMenuItemSelected,this._buddy.getIsOnline());
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_viewProfile"),this.onViewProfileMenuItemSelected,LobbyConfig.instance.isSummonerSearchEnabled);
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemInviteToChat"),this.onInviteToChatMenuItemSelected,this._buddy.getIsOnline());
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemRemoveBuddy"),this.onRemoveBuddyMenuItemSelected,true);
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemIgnoreBuddy"),this.onIgnoreBuddyMenuItemSelected,true);
         if(this._viewMediator.getBuddyGroups().getLength() > 1)
         {
            addSubmenu(this.createMoveBuddyToGroupSubmenu(),RiotResourceLoader.getString("BuddyListTreeRenderer_itemMoveUser"));
         }
         else
         {
            this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemMoveUser"),null,false);
         }
         if(ClientConfig.instance.buddyNotesEnabled)
         {
            _loc4_ = this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemEditNote"),null,true);
            _loc4_.addEventListener(Event.SELECT,this.editNoteSelectHandler,false,0,true);
         }
         this.buildMenuItem(this,RiotResourceLoader.getString("BuddyListTreeRenderer_itemSpectateGame"),this.onSpectateBuddySelected,this._viewMediator.canDropInSpectateBuddy(this._buddy));
      }
      
      public function get editNoteSelect() : ISignal
      {
         return this._editNoteSelect;
      }
      
      private function editNoteSelectHandler(param1:Event) : void
      {
         this._editNoteSelect.dispatch(this);
      }
      
      public function get buddy() : Buddy
      {
         return this._buddy;
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
      
      private function createMoveBuddyToGroupSubmenu() : NativeMenu
      {
         var _loc2_:BuddyGroup = null;
         var _loc3_:String = null;
         var _loc1_:NativeMenu = new NativeMenu();
         for each(_loc2_ in this._viewMediator.getBuddyGroups())
         {
            _loc3_ = _loc2_.getLabel();
            if(_loc3_ == this._viewMediator.getDefaultGroupName())
            {
               _loc3_ = ResourceManager.getInstance().getString("resources","chat_defaultBuddyGroup");
            }
            this.buildMenuItem(_loc1_,_loc3_,this.onMoveBuddyToGroupMenuItemSelected,true);
         }
         return _loc1_;
      }
      
      private function onInviteToChatMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.inviteBuddyToChat(this._buddy,ChatRoomType.PRIVATE);
      }
      
      private function onMoveBuddyToGroupMenuItemSelected(param1:Event) : void
      {
         var _loc2_:NativeMenuItem = param1.target as NativeMenuItem;
         var _loc3_:String = _loc2_.label;
         if(_loc3_ == ResourceManager.getInstance().getString("resources","chat_defaultBuddyGroup"))
         {
            _loc3_ = this._viewMediator.getDefaultGroupName();
         }
         this._viewMediator.moveBuddyToGroup(this._buddy,_loc3_);
      }
      
      private function onIgnoreBuddyMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.ignoreBuddy(this._buddy);
      }
      
      private function onRemoveBuddyMenuItemSelected(param1:Event) : void
      {
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getString("chat_buddyWindow_removeBuddyAlertTitle"),RiotResourceLoader.getString("chat_buddyWindow_removeContactMessage","Remove buddy?",[this._buddy.getName()]));
         _loc2_.setYesNoLabels();
         _loc2_.showNegative = true;
         _loc2_.affirmativeDefault = false;
         _loc2_.getCompleted().add(this.onRemoveBuddyAlertCompleted);
         _loc2_.add();
      }
      
      private function onRemoveBuddyAlertCompleted(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this._viewMediator.removeBuddy(this._buddy);
         }
      }
      
      private function onSpectateBuddySelected(param1:Event) : void
      {
         this._viewMediator.spectateGameByBuddy(this._buddy);
      }
      
      private function onInviteToGameMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.inviteBuddyToGame(this._buddy);
      }
      
      private function onSendMessageMenuItemSelected(param1:Event) : void
      {
         this.startChat();
      }
      
      private function onViewProfileMenuItemSelected(param1:Event) : void
      {
         this._viewMediator.viewProfile(this._buddy);
      }
      
      private function startChat() : void
      {
         if(this._buddy.getStatus() == Buddy.STATUS_ONLINE)
         {
            this._viewMediator.createPersonalPopUp(this._buddy.getJID(),true);
         }
      }
   }
}

