package com.riotgames.pvpnet.cap.util
{
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   
   public class CapRoleUtil
   {
      
      public function CapRoleUtil()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function hasAnyRole(param1:Array) : Boolean
      {
         return getAnyRole(param1) != null;
      }
      
      public static function getAnyRole(param1:Array) : CapRole
      {
         var _loc2_:CapRole = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_ == CapRoles.ANY)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getRoleByID(param1:Array, param2:String) : CapRole
      {
         var _loc3_:CapRole = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.id == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function getRoleIndex(param1:Array, param2:CapRole) : int
      {
         var _loc3_:int = 0;
         for each(param2 in param1)
         {
            if(param2[_loc3_] == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}

