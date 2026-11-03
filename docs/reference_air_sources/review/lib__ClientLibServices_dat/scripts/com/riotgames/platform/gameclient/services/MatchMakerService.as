package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.MatchMakerParams;
   
   public interface MatchMakerService
   {
      
      function attachToQueue(param1:MatchMakerParams, param2:Object, param3:Function, param4:Function, param5:Function) : void;
      
      function cancelFromQueueIfPossible(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function getAvailableQueues(param1:Function, param2:Function, param3:Function) : void;
      
      function purgeFromQueues(param1:Function, param2:Function, param3:Function) : void;
      
      function getQueueInfo(param1:Number, param2:Function, param3:Function, param4:Function) : void;
      
      function acceptInviteForMatchmakingGame(param1:String, param2:Function, param3:Function, param4:Function, param5:Object) : void;
      
      function isMatchmakingEnabled(param1:Function) : void;
   }
}

