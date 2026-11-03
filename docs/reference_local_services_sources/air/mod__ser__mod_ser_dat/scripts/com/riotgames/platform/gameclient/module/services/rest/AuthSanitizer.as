package com.riotgames.platform.gameclient.module.services.rest
{
   import com.riotgames.platform.common.utils.Sanitizer;
   
   public class AuthSanitizer implements Sanitizer
   {
      
      private static const AUTH:String = "/authenticate/";
      
      private static const ERROR:String = " errorID=";
      
      public function AuthSanitizer()
      {
         super();
      }
      
      public function sanitize(param1:String) : String
      {
         var _loc2_:int = param1 == null ? -1 : param1.indexOf(AUTH,0);
         if(_loc2_ == -1)
         {
            return param1;
         }
         _loc2_ += AUTH.length;
         var _loc3_:int = param1.indexOf("\"",_loc2_);
         if(_loc3_ == -1)
         {
            return param1.substring(0,_loc2_);
         }
         var _loc4_:String = param1.substring(_loc2_,_loc3_);
         var _loc5_:String = param1;
         while(_loc5_.indexOf(_loc4_) != -1)
         {
            _loc5_ = _loc5_.replace(_loc4_,"");
         }
         return _loc5_;
      }
   }
}

