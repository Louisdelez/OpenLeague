package com.riotgames.pvpnet.docked
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.components.button.ButtonX;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IDockedFriendListProvider extends IProvider
   {
      
      function dock(param1:ButtonX, param2:DisplayObjectContainerProxy) : void;
   }
}

