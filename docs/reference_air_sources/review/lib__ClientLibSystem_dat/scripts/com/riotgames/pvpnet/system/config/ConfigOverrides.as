package com.riotgames.pvpnet.system.config
{
   public dynamic class ConfigOverrides
   {
      
      public function ConfigOverrides()
      {
         super();
      }
      
      public function hasOverrides() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for(_loc2_ in this)
         {
            _loc1_++;
         }
         return _loc1_ > 0;
      }
      
      public function overrideProperties(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this)
         {
            if(param1.hasOwnProperty(_loc2_))
            {
               param1[_loc2_] = this[_loc2_];
            }
         }
      }
   }
}

