package com.riotgames.platform.gameclient.chat.views.docked
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.docked.IDockedChatView;
   import com.riotgames.pvpnet.docked.IDockedChatViewProvider;
   import mx.core.UIComponent;
   import mx.events.ResizeEvent;
   
   public class DockedChatViewWrapper extends UIComponent
   {
      
      private var dockedChatViewProvider:IDockedChatViewProvider;
      
      private var dockedChatView:IDockedChatView;
      
      public function DockedChatViewWrapper()
      {
         super();
         addEventListener(ResizeEvent.RESIZE,this.resizeHandler);
      }
      
      public function showDockChatViewRoot() : void
      {
         var _loc1_:DisplayAdapter = new DisplayAdapter(this);
         this.dockedChatView = this.dockedChatViewProvider.getDockedChatView();
         this.dockedChatView.setExplicitSize(unscaledWidth,unscaledHeight);
         _loc1_.addChild(this.dockedChatView);
      }
      
      private function getChatProvider(param1:IDockedChatViewProvider) : void
      {
         this.dockedChatViewProvider = param1;
         this.showDockChatViewRoot();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         ProviderLookup.getProvider(IDockedChatViewProvider,this.getChatProvider);
      }
      
      private function resizeHandler(param1:ResizeEvent) : void
      {
         if(this.dockedChatView != null)
         {
            this.dockedChatView.setExplicitSize(unscaledWidth,unscaledHeight);
         }
      }
   }
}

