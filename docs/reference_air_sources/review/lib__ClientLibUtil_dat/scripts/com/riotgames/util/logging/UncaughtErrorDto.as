package com.riotgames.util.logging
{
   public class UncaughtErrorDto
   {
      
      public var caughtBy:String;
      
      public var errorObject:*;
      
      public var sessionErrorNumber:int;
      
      public function UncaughtErrorDto(param1:String, param2:*, param3:int)
      {
         super();
         this.caughtBy = param1;
         this.errorObject = param2;
         this.sessionErrorNumber = param3;
      }
   }
}

