package com.riotgames.platform.common.profile
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IOldProfileScreenProvider extends IProvider
   {
      
      function hide() : void;
      
      function show(param1:Number, param2:DisplayAdapter) : void;
   }
}

