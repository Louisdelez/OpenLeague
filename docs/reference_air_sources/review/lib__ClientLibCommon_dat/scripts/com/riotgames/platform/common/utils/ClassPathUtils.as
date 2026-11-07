package com.riotgames.platform.common.utils
{
   import flash.utils.getQualifiedClassName;
   
   public class ClassPathUtils
   {
      
      public function ClassPathUtils()
      {
         super();
      }
      
      public static function getPackage(param1:*) : String
      {
         var _loc2_:String = getQualifiedClassName(param1).replace(/::/,".");
         return _loc2_.substring(0,_loc2_.lastIndexOf("."));
      }
   }
}

