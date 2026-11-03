package com.riotgames.pvpnet.CLS.views.helpers
{
   public class StringHelper
   {
      
      public function StringHelper()
      {
         super();
      }
      
      public static function truncate(param1:String, param2:int) : String
      {
         if(param1.length >= param2)
         {
            return param1.substr(0,param2) + "...";
         }
         return param1;
      }
   }
}

