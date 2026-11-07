package com.riotgames.platform.gameclient.domain.game
{
   public class QueueThrottleDTO
   {
      
      public var queueThrottles:Array;
      
      public function QueueThrottleDTO()
      {
         super();
      }
      
      public function isQueueThrottled(param1:int) : Boolean
      {
         return this.queueThrottles != null && this.queueThrottles.indexOf(param1) >= 0;
      }
   }
}

