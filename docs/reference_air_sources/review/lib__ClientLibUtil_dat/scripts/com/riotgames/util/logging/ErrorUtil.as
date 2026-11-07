package com.riotgames.util.logging
{
   import flash.events.ErrorEvent;
   
   public class ErrorUtil
   {
      
      public function ErrorUtil()
      {
         super();
      }
      
      public static function get4DigitCode(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 > 0)
         {
            _loc2_ = param1.toString();
            while(_loc2_.length < 4)
            {
               _loc2_ = "0" + _loc2_;
            }
            return _loc2_ + " ";
         }
         return "0001 ";
      }
      
      public static function makeErrorMessage(param1:Object, param2:String = null) : String
      {
         var error:Error = null;
         var event:ErrorEvent = null;
         var e:Object = param1;
         var message:String = param2;
         var msg:String = "";
         try
         {
            if(e is Error)
            {
               error = e as Error;
               msg += get4DigitCode(error.errorID) + e.name + " | ";
            }
            else if(e is ErrorEvent)
            {
               event = e as ErrorEvent;
               msg += get4DigitCode(event.errorID) + event.type + " | ";
            }
            else
            {
               msg += "0000 [no error object] | ";
            }
            if(Boolean(message))
            {
               msg += message;
            }
         }
         catch(e:Error)
         {
            msg = "ErrorUtil FAILED!!!!!";
         }
         return msg;
      }
      
      public static function grabCodeFromString(param1:String) : String
      {
         var _loc2_:String = null;
         try
         {
            _loc2_ = param1.substr(param1.length - 4);
            return _loc2_ + " ";
         }
         catch(e:Error)
         {
         }
         return "9898 GRAB CODE FAILED ";
      }
   }
}

