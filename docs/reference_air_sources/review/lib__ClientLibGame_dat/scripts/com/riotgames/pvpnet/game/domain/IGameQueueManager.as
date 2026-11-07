package com.riotgames.pvpnet.game.domain
{
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueInfo;
   import com.riotgames.platform.provider.IProvider;
   import mx.collections.ArrayCollection;
   
   public interface IGameQueueManager extends IProvider
   {
      
      function checkQueuesHaveChanged(param1:ArrayCollection) : void;
      
      function beginQueueWait(param1:Boolean) : void;
      
      function endQueueWait() : void;
      
      function getSelectedGameQueueConfig() : GameQueueConfig;
      
      function getQueueInfo() : QueueInfo;
      
      function getActualWaitTimeStr() : String;
   }
}

