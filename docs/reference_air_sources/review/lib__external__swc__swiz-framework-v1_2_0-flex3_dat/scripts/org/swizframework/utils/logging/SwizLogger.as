package org.swizframework.utils.logging
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SwizLogger extends EventDispatcher
   {
      
      protected static var loggers:Dictionary;
      
      protected static var loggingTargets:Array;
      
      protected var _category:String;
      
      public function SwizLogger(className:String)
      {
         super();
         this._category = className;
      }
      
      public static function getLogger(target:Object) : SwizLogger
      {
         var logTarget:AbstractSwizLoggingTarget = null;
         loggers = loggers || new Dictionary();
         var className:String = getQualifiedClassName(target);
         var logger:SwizLogger = loggers[className];
         if(logger == null)
         {
            logger = new SwizLogger(className);
            loggers[className] = logger;
         }
         if(loggingTargets != null)
         {
            for each(logTarget in loggingTargets)
            {
               if(categoryMatchInFilterList(logger.category,logTarget.filters))
               {
                  logTarget.addLogger(logger);
               }
            }
         }
         return logger;
      }
      
      public static function categoryMatchInFilterList(category:String, filters:Array) : Boolean
      {
         var filter:String = null;
         var result:Boolean = false;
         var index:int = -1;
         for(var i:uint = 0; i < filters.length; i++)
         {
            filter = filters[i];
            index = filter.indexOf("*");
            if(index == 0)
            {
               return true;
            }
            index = category.length;
            index = index < 0 ? (index) : int(index - 1);
            if(category.substring(0,index) == filter.substring(0,index))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function addLoggingTarget(loggingTarget:AbstractSwizLoggingTarget) : void
      {
         var logger:SwizLogger = null;
         loggingTargets = loggingTargets || [];
         if(loggingTargets.indexOf(loggingTarget) < 0)
         {
            loggingTargets.push(loggingTarget);
         }
         if(loggers != null)
         {
            for each(logger in loggers)
            {
               if(categoryMatchInFilterList(logger.category,loggingTarget.filters))
               {
                  loggingTarget.addLogger(logger);
               }
            }
         }
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      protected function constructMessage(msg:String, params:Array) : String
      {
         for(var i:int = 0; i < params.length; i++)
         {
            msg = msg.replace(new RegExp("\\{" + i + "\\}","g"),params[i]);
         }
         return msg;
      }
      
      public function log(level:int, msg:String, ... rest) : void
      {
         if(hasEventListener(SwizLogEvent.LOG_EVENT))
         {
            dispatchEvent(new SwizLogEvent(this.constructMessage(msg,rest),level));
         }
      }
      
      public function debug(msg:String, ... rest) : void
      {
         if(hasEventListener(SwizLogEvent.LOG_EVENT))
         {
            dispatchEvent(new SwizLogEvent(this.constructMessage(msg,rest),SwizLogEventLevel.DEBUG));
         }
      }
      
      public function info(msg:String, ... rest) : void
      {
         if(hasEventListener(SwizLogEvent.LOG_EVENT))
         {
            dispatchEvent(new SwizLogEvent(this.constructMessage(msg,rest),SwizLogEventLevel.INFO));
         }
      }
      
      public function warn(msg:String, ... rest) : void
      {
         if(hasEventListener(SwizLogEvent.LOG_EVENT))
         {
            dispatchEvent(new SwizLogEvent(this.constructMessage(msg,rest),SwizLogEventLevel.WARN));
         }
      }
      
      public function error(msg:String, ... rest) : void
      {
         if(hasEventListener(SwizLogEvent.LOG_EVENT))
         {
            dispatchEvent(new SwizLogEvent(this.constructMessage(msg,rest),SwizLogEventLevel.ERROR));
         }
      }
      
      public function fatal(msg:String, ... rest) : void
      {
         if(hasEventListener(SwizLogEvent.LOG_EVENT))
         {
            dispatchEvent(new SwizLogEvent(this.constructMessage(msg,rest),SwizLogEventLevel.FATAL));
         }
      }
   }
}

