package com.blitzagency.xray.logger
{
   public class XrayLog
   {
      
      private var logger:XrayLogger;
      
      public function XrayLog()
      {
         super();
         logger = XrayLogger.getInstance();
      }
      
      public function debug(message:String, ... rest) : void
      {
         var i:Number = NaN;
         if(rest.length == 0)
         {
            logger.debug(new Log(message,null,XrayLogger.DEBUG));
         }
         for(i = 0; i < rest.length; i++)
         {
            if(i > 0)
            {
               message = "";
            }
            logger.debug(new Log(message,rest[i],XrayLogger.DEBUG));
         }
      }
      
      public function fatal(message:String, ... rest) : void
      {
         var i:Number = NaN;
         if(rest.length == 0)
         {
            logger.fatal(new Log(message,null,XrayLogger.FATAL));
         }
         for(i = 0; i < rest.length; i++)
         {
            if(i > 0)
            {
               message = "";
            }
            logger.fatal(new Log(message,rest[i],XrayLogger.FATAL));
         }
      }
      
      public function info(message:String, ... rest) : void
      {
         var i:Number = NaN;
         if(rest.length == 0)
         {
            logger.info(new Log(message,null,XrayLogger.INFO));
         }
         for(i = 0; i < rest.length; i++)
         {
            if(i > 0)
            {
               message = "";
            }
            logger.info(new Log(message,rest[i],XrayLogger.INFO));
         }
      }
      
      public function warn(message:String, ... rest) : void
      {
         var i:Number = NaN;
         if(rest.length == 0)
         {
            logger.warn(new Log(message,null,XrayLogger.WARN));
         }
         for(i = 0; i < rest.length; i++)
         {
            if(i > 0)
            {
               message = "";
            }
            logger.warn(new Log(message,rest[i],XrayLogger.WARN));
         }
      }
      
      public function error(message:String, ... rest) : void
      {
         var i:Number = NaN;
         if(rest.length == 0)
         {
            logger.error(new Log(message,null,XrayLogger.ERROR));
         }
         for(i = 0; i < rest.length; i++)
         {
            if(i > 0)
            {
               message = "";
            }
            logger.error(new Log(message,rest[i],XrayLogger.ERROR));
         }
      }
   }
}

