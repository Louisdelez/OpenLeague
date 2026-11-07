package com.riotgames.platform.common.utils
{
   import flash.net.URLLoader;
   
   public class URLLoaderPool
   {
      
      private var type:Class = URLLoader;
      
      private var counter:int;
      
      private var pool:Array;
      
      public function URLLoaderPool(param1:int)
      {
         super();
         this.init(param1);
      }
      
      public function init(param1:int) : void
      {
         this.pool = new Array();
         this.counter = param1;
         var _loc2_:int = param1;
         while(--_loc2_ > -1)
         {
            this.pool[_loc2_] = new this.type();
         }
      }
      
      public function returnURLLoader(param1:URLLoader) : void
      {
         this.pool.push(param1);
      }
      
      public function getURLLoader() : URLLoader
      {
         if(this.pool.length > 0)
         {
            return this.pool.shift() as URLLoader;
         }
         return new this.type();
      }
   }
}

