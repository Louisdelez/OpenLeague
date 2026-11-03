package com.riotgames.platform.module.masteries.interfaces
{
   import blix.assets.proxy.DisplayAdapter;
   
   public interface IMasteriesViewMediator
   {
      
      function closeView(param1:Boolean = false) : void;
      
      function displayView(param1:DisplayAdapter, param2:Boolean = false) : void;
   }
}

