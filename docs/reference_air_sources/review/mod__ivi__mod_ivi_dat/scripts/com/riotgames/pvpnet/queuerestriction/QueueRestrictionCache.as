package com.riotgames.pvpnet.queuerestriction
{
   import com.riotgames.platform.gameclient.domain.queuerestriction.QueueRestrictionCacheItem;
   import flash.utils.Dictionary;
   
   public class QueueRestrictionCache
   {
      
      private var _cache:Dictionary;
      
      public function QueueRestrictionCache()
      {
         super();
         this._cache = new Dictionary();
      }
      
      public function getQueueRestrictionCacheItem(param1:Number) : QueueRestrictionCacheItem
      {
         return this._cache[param1];
      }
      
      public function removeQueueRestrictionCacheItem(param1:Number) : void
      {
         delete this._cache[param1];
      }
      
      public function addOrUpdateQueueRestrictionCacheItem(param1:QueueRestrictionCacheItem) : void
      {
         this._cache[param1.getSummonerId()] = param1;
      }
      
      public function reset() : void
      {
         this._cache = new Dictionary();
      }
   }
}

