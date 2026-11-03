package com.riotgames.util.logging
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.ErrorEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class UncaughtErrorRelay
   {
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.util.logging.UncaughtErrorHandler");
      
      public static var isLogging:Boolean = false;
      
      public static var maxLifetimeErrors:int = 20;
      
      public static var errorCount:int = 0;
      
      private static var errors:Vector.<UncaughtErrorDto> = new Vector.<UncaughtErrorDto>();
      
      private static var uncaughtErrorReported:Signal = new Signal();
      
      public function UncaughtErrorRelay()
      {
         super();
      }
      
      public static function pushError(param1:String, param2:*) : void
      {
         logError(param1,param2);
         ++errorCount;
         var _loc3_:UncaughtErrorDto = new UncaughtErrorDto(param1,param2,errorCount);
         if(errorCount <= maxLifetimeErrors)
         {
            errors.push(_loc3_);
            uncaughtErrorReported.dispatch();
         }
      }
      
      private static function logError(param1:String, param2:*) : void
      {
         var _loc3_:Error = null;
         var _loc4_:String = null;
         var _loc5_:ErrorEvent = null;
         isLogging = true;
         if(param2 is Error)
         {
            _loc3_ = param2 as Error;
            _loc4_ = _loc3_.getStackTrace();
            logger.error(ErrorUtil.get4DigitCode(_loc3_.errorID) + "Uncaught error from " + param1 + ": " + _loc4_);
         }
         else if(param2 is ErrorEvent)
         {
            _loc5_ = param2 as ErrorEvent;
            logger.error(ErrorUtil.get4DigitCode(_loc5_.errorID) + "Uncaught error from " + param1 + ": " + _loc5_.text);
         }
         else
         {
            logger.error("Uncaught error from " + param1 + ": " + String(param2));
         }
         isLogging = false;
      }
      
      public static function getUncaughtErrorReported() : ISignal
      {
         return uncaughtErrorReported;
      }
      
      public static function consumeErrors() : Vector.<UncaughtErrorDto>
      {
         var _loc1_:Vector.<UncaughtErrorDto> = errors;
         errors = new Vector.<UncaughtErrorDto>();
         return _loc1_;
      }
   }
}

