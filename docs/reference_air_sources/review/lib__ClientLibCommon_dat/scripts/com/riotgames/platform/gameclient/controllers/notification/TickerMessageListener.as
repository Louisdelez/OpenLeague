package com.riotgames.platform.gameclient.controllers.notification
{
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   
   public interface TickerMessageListener
   {
      
      function tickerMessagesReceived(param1:Vector.<BroadcastMessage>) : void;
   }
}

