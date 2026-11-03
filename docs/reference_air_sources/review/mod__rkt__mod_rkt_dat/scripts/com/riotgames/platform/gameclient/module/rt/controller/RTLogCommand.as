package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTLogCommand extends RTSimpleCommand
   {
      
      public static const DEBUG:String = "DEBUG";
      
      public static const ERROR:String = "ERROR";
      
      public static const FATAL:String = "FATAL";
      
      public static const INFO:String = "INFO";
      
      public static const WARN:String = "WARN";
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function RTLogCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = param1.getBody() as String;
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case DEBUG:
               break;
            case ERROR:
               this.logger.error(_loc2_);
               break;
            case FATAL:
               this.logger.fatal(_loc2_);
               break;
            case INFO:
               break;
            case WARN:
               this.logger.warn(_loc2_);
         }
      }
   }
}

