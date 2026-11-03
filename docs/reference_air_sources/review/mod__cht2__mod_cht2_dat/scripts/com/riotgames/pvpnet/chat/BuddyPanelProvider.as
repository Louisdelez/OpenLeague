package com.riotgames.pvpnet.chat
{
   import blix.context.IContext;
   import com.riotgames.pvpnet.docked.IBuddyPanel;
   import com.riotgames.pvpnet.docked.IBuddyPanelProvider;
   import com.riotgames.pvpnet.docked.chat.view.buddypanel.BuddyPanelView;
   
   public class BuddyPanelProvider implements IBuddyPanelProvider
   {
      
      private var _parentContext:IContext;
      
      public function BuddyPanelProvider(param1:IContext)
      {
         super();
         this._parentContext = param1;
      }
      
      public function getBuddyPanel() : IBuddyPanel
      {
         return new BuddyPanelView(this._parentContext);
      }
   }
}

