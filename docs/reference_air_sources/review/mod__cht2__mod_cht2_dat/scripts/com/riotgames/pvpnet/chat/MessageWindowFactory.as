package com.riotgames.pvpnet.chat
{
   import blix.context.IContext;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   import com.riotgames.pvpnet.docked.chat.view.ChatWindowView;
   
   public class MessageWindowFactory implements IChatWindowProvider
   {
      
      private var _parentContext:IContext;
      
      public function MessageWindowFactory(param1:IContext)
      {
         super();
         this._parentContext = param1;
      }
      
      public function getPersonalChatWindow(param1:ChatWindowModel) : IDockedMessageWindow
      {
         var _loc2_:ChatWindowView = new ChatWindowView(this._parentContext);
         _loc2_.setModel(param1);
         return _loc2_;
      }
   }
}

