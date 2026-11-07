package com.riotgames.platform.common.services
{
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import mx.messaging.events.MessageEvent;
   
   public interface MessageRouterService
   {
      
      function initialize(param1:ServerSessionObject) : void;
      
      function removeClientNotificationMessageListener(param1:Function) : void;
      
      function addBroadcastMessageListener(param1:Function) : void;
      
      function addClientNotificationMessageListener(param1:Function) : void;
      
      function removeGameMessageListener(param1:Function) : void;
      
      function addGameMessageListener(param1:Function) : void;
      
      function invalidateConsumers() : void;
      
      function fireClientNotificationMessage(param1:MessageEvent) : void;
      
      function disconnect() : void;
      
      function fireGameMessage(param1:MessageEvent) : void;
   }
}

