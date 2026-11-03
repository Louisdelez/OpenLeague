package com.blitzagency.xray.logger
{
   public interface Logger
   {
      
      function setLevel(param1:Number = 0) : void;
      
      function debug(param1:Log) : void;
      
      function fatal(param1:Log) : void;
      
      function warn(param1:Log) : void;
      
      function error(param1:Log) : void;
      
      function log(param1:String, param2:String, param3:String, param4:Number, param5:Object = null) : void;
      
      function info(param1:Log) : void;
   }
}

