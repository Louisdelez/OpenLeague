package com.riotgames.pvpnet.chat
{
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.docked.IFriendScroller;
   
   public interface IFriendListProvider extends IProvider
   {
      
      function getFriendList() : IFriendScroller;
   }
}

