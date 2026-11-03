package com.riotgames.pvpnet.matchhistoryiron
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IMatchHistoryIronProvider extends IProvider
   {
      
      function show(param1:Number, param2:DisplayAdapter) : void;
      
      function hide() : void;
   }
}

