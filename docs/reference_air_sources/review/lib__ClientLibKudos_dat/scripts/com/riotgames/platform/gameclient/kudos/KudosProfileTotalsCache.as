package com.riotgames.platform.gameclient.kudos
{
   import flash.utils.Dictionary;
   
   public class KudosProfileTotalsCache implements IKudosProfileTotalsCache
   {
      
      private static var instance:KudosProfileTotalsCache;
      
      protected var cache:Dictionary;
      
      public function KudosProfileTotalsCache()
      {
         super();
         this.clearCache();
      }
      
      public function clearCache() : void
      {
         this.cache = new Dictionary();
      }
      
      public function getKudosTotals(param1:Number) : Object
      {
         if(!this.cache)
         {
            return null;
         }
         return this.cache[param1];
      }
      
      public function cacheKudosTotals(param1:Number, param2:Object) : void
      {
         if(Boolean(this.cache))
         {
            this.cache[param1] = param2;
         }
      }
   }
}

