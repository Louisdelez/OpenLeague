package com.riotgames.pvpnet.chrome
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IChromeProvider extends IProvider
   {
      
      function addFrame(param1:DisplayAdapter) : void;
      
      function addWindowControls(param1:DisplayAdapter) : void;
      
      function registerCloseRequestedResponder(param1:Function) : void;
   }
}

