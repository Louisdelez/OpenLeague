package com.riotgames.platform.common.services
{
   public interface RemoteObjectGeneratorService
   {
      
      function addChannelSetListener(param1:String, param2:Function) : void;
      
      function expireAuthenticationChannel() : void;
      
      function authenticateChannel(param1:String, param2:String) : void;
      
      function removeChannelSetListener(param1:String, param2:Function) : void;
   }
}

ChannelFaultEvent;

