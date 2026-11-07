package com.riotgames.pvpnet.chat
{
   import blix.context.IContext;
   import com.riotgames.pvpnet.docked.IDockedChatView;
   import com.riotgames.pvpnet.docked.IDockedChatViewProvider;
   import com.riotgames.pvpnet.docked.chat.view.DockedChatRootView;
   
   public class DockedChatViewProvider implements IDockedChatViewProvider
   {
      
      private var _parentContext:IContext;
      
      public function DockedChatViewProvider(param1:IContext)
      {
         super();
         this._parentContext = param1;
      }
      
      public function getDockedChatView() : IDockedChatView
      {
         return new DockedChatRootView(this._parentContext);
      }
   }
}

