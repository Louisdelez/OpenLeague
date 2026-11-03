package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.notification.ClientNotificationController;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   
   public class InitializeClientNotificationsAction extends BasicAction
   {
      
      public function InitializeClientNotificationsAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:ClientNotificationController = new ClientNotificationController();
         _loc1_.initializeClientNotifications();
         ProviderLookup.publishProvider(IClientNotificationProvider,_loc1_);
         complete();
      }
   }
}

