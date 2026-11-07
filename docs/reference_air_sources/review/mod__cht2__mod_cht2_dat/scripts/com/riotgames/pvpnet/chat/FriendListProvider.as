package com.riotgames.pvpnet.chat
{
   import blix.context.IContext;
   import com.riotgames.pvpnet.docked.IFriendScroller;
   import com.riotgames.pvpnet.docked.friendlist.view.FriendScroller;
   
   public class FriendListProvider implements IFriendListProvider
   {
      
      private var _parentContext:IContext;
      
      public function FriendListProvider(param1:IContext)
      {
         super();
         this._parentContext = param1;
      }
      
      public function getFriendList() : IFriendScroller
      {
         return new FriendScroller(this._parentContext);
      }
   }
}

