package com.riotgames.pvpnet.invite.controller
{
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatStateProvider;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   
   public class InviteSystemManager
   {
      
      private var _inviteController:IInviteController;
      
      private var _chatStateProvider:IChatStateProvider;
      
      private var _platformInviteController:PlatformInviteController;
      
      private var _inviteGroup:InviteGroup;
      
      public function InviteSystemManager(param1:IInviteController, param2:IChatStateProvider, param3:PlatformInviteController, param4:InviteGroup)
      {
         super();
         this._inviteController = param1;
         this._platformInviteController = param3;
         this._inviteGroup = param4;
         this._chatStateProvider = param2;
      }
      
      public function enable() : void
      {
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration("GameInvites","ServiceEnabled",true,this.onGameInviteServiceEnabledChanged);
         this.updateInviteService(_loc1_.getBoolean());
      }
      
      private function updateInviteService(param1:Boolean) : void
      {
         if(param1)
         {
            this._platformInviteController.connectInviteListeners();
            if(this._chatStateProvider)
            {
               this._chatStateProvider.getCurrentStateChanged().remove(this.onCurrentChatStateChanged);
            }
            this._inviteGroup.isInviteActive = true;
         }
         else
         {
            this._inviteGroup.isInviteActive = this.isChatOnline();
            if(this._chatStateProvider)
            {
               this._chatStateProvider.getCurrentStateChanged().add(this.onCurrentChatStateChanged);
            }
            this._platformInviteController.disconnectInviteListeners();
         }
      }
      
      private function onCurrentChatStateChanged() : void
      {
         this._inviteGroup.isInviteActive = this.isChatOnline();
      }
      
      private function onGameInviteServiceEnabledChanged() : void
      {
         this.enable();
      }
      
      public function setChatStateProvider(param1:IChatStateProvider) : void
      {
         if(this._chatStateProvider == param1)
         {
            return;
         }
         this._chatStateProvider = param1;
         this.enable();
      }
      
      private function isChatOnline() : Boolean
      {
         if(this._chatStateProvider)
         {
            return this._chatStateProvider.getCurrentState() == ChatController.ONLINE;
         }
         return false;
      }
   }
}

