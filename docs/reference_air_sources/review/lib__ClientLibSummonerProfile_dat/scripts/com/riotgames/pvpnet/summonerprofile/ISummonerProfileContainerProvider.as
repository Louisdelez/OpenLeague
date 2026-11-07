package com.riotgames.pvpnet.summonerprofile
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface ISummonerProfileContainerProvider extends IProvider
   {
      
      function showProfileContainer(param1:DisplayAdapter) : void;
      
      function hideProfileContainer(param1:DisplayAdapter) : void;
   }
}

