package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.messaging.BroadcastMessageController;
   import com.riotgames.pvpnet.system.messaging.IBroadcastMessageProvider;
   
   public class InitializeBroadcastMessagesAction extends BasicAction
   {
      
      public function InitializeBroadcastMessagesAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:BroadcastMessageController = new BroadcastMessageController();
         _loc1_.initialize();
         ProviderLookup.publishProvider(IBroadcastMessageProvider,_loc1_);
         complete();
      }
   }
}

