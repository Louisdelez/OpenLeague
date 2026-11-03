package com.riotgames.pvpnet.cap.model
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.utils.Dictionary;
   
   public class CapEstimatedWaitTimeCache
   {
      
      private var cache:Dictionary = new Dictionary();
      
      public function CapEstimatedWaitTimeCache()
      {
         super();
      }
      
      public function clearCache() : void
      {
         this.cache = new Dictionary();
      }
      
      public function getEstimatedWaitTime(param1:Champion, param2:CapRole, param3:CapPosition) : CapEstimatedWaitTime
      {
         return this.cache[param1.championId + param2.id + param3.id];
      }
      
      public function cacheEstimatedWaitTime(param1:Champion, param2:CapRole, param3:CapPosition, param4:CapEstimatedWaitTime) : void
      {
         if(!param1 || !param2 || !param3 || !param4)
         {
            throw new Error("Cannot cache null values.");
         }
         this.cache[param1.championId + param2.id + param3.id] = param4;
      }
   }
}

