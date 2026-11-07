package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.metrics.NotificationsTracker;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelInviteNotificationsView extends BuddyPanelNotificationsViewBase
   {
      
      public function BuddyPanelInviteNotificationsView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _sectionHeader.setLabel(ResourceManager.getInstance().getString("resources","chat_notificationsPanel_inviteSection"));
      }
      
      override protected function notificationFilter(param1:DockedPrompt) : Boolean
      {
         return param1.type == DockedPrompt.TYPE_GAME_INVITE;
      }
      
      override protected function handleClearRequested() : void
      {
         NotificationsTracker.instance.clearedAllGameInviteNotifications();
         _notificationsProvider.removeMultipleNotifications(_myNotifications,ButtonNameType.DISMISS_BUTTON,NotificationsProvider.RESPONSE_SOURCE_PANEL,false);
      }
   }
}

