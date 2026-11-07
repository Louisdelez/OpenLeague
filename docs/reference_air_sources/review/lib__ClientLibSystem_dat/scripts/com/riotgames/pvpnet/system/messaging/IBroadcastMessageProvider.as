package com.riotgames.pvpnet.system.messaging
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IBroadcastMessageProvider extends IProvider
   {
      
      function addMessageListener(param1:String, param2:Function) : void;
      
      function removeMessageListener(param1:String, param2:Function) : void;
   }
}

