package com.blitzagency.xray.logger
{
   import com.blitzagency.xray.logger.util.ObjectTools;
   import com.blitzagency.xray.logger.util.PropertyTools;
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   public class XrayLogger extends EventDispatcher implements Logger
   {
      
      public static var DEBUG:Number = 0;
      
      public static var INFO:Number = 1;
      
      public static var WARN:Number = 2;
      
      public static var ERROR:Number = 3;
      
      public static var FATAL:Number = 4;
      
      public static var NONE:Number = 5;
      
      private static var _instance:XrayLogger = null;
      
      private var displayObjectRecursionDepth:Number = 3;
      
      private var level:Number = 0;
      
      private var indentation:Number = 0;
      
      private var objectRecursionDepth:Number = 254;
      
      private var filters:Array = [];
      
      public function XrayLogger()
      {
         super();
      }
      
      public static function getInstance() : XrayLogger
      {
         if(_instance == null)
         {
            _instance = new XrayLogger();
         }
         return _instance;
      }
      
      public static function resolveLevelAsName(p_level:Number) : String
      {
         switch(p_level)
         {
            case 0:
               return "debug";
            case 1:
               return "info";
            case 2:
               return "warn";
            case 3:
               return "error";
            case 4:
               return "fatal";
            default:
               return "debug";
         }
      }
      
      public function checkFilters() : Boolean
      {
         var i:uint = 0;
         if(filters.length == 0)
         {
            return true;
         }
         for(i = 0; i < filters.length; i++)
         {
         }
         return true;
      }
      
      public function debug(obj:Log) : void
      {
         if(obj.getLevel() == level)
         {
            log(obj.getMessage(),obj.getCaller(),obj.getClassPackage(),0,obj.getDump());
         }
      }
      
      public function setIndentation(p_indentation:Number = 0) : void
      {
         indentation = p_indentation;
      }
      
      public function error(obj:Log) : void
      {
         if(obj.getLevel() >= level)
         {
            log(obj.getMessage(),obj.getCaller(),obj.getClassPackage(),3,obj.getDump());
         }
      }
      
      public function setLevel(p_level:Number = 0) : void
      {
         level = p_level;
      }
      
      public function fatal(obj:Log) : void
      {
         if(obj.getLevel() >= level)
         {
            log(obj.getMessage(),obj.getCaller(),obj.getClassPackage(),4,obj.getDump());
         }
      }
      
      public function warn(obj:Log) : void
      {
         if(obj.getLevel() >= level)
         {
            log(obj.getMessage(),obj.getCaller(),obj.getClassPackage(),2,obj.getDump());
         }
      }
      
      public function setObjectRecursionDepth(p_recursionDepth:Number) : void
      {
         objectRecursionDepth = p_recursionDepth;
      }
      
      public function setDisplayClipRecursionDepth(p_recursionDepth:Number) : void
      {
         displayObjectRecursionDepth = p_recursionDepth;
      }
      
      public function info(obj:Log) : void
      {
         if(obj.getLevel() >= level)
         {
            log(obj.getMessage(),obj.getCaller(),obj.getClassPackage(),1,obj.getDump());
         }
      }
      
      public function log(message:String, caller:String, classPackage:String, level:Number, dump:Object = null) : void
      {
         var traceMessage:String = null;
         var type:String = null;
         var objType:String = null;
         var obj:Object = null;
         traceMessage = "(" + getTimer() + ") ";
         if(classPackage.length > 0)
         {
            traceMessage += caller + "\n";
         }
         traceMessage += message;
         if(message.length > 0)
         {
            Debug.trace(traceMessage,classPackage,level);
         }
         if(dump == null)
         {
            return;
         }
         type = typeof dump;
         if(type == "string" || type == "number" || type == "boolean" || type == "undefined" || type == "null")
         {
            Debug.trace(dump,classPackage,level);
         }
         else if(type == "xml")
         {
            Debug.trace(dump.toString(),classPackage,level);
         }
         else
         {
            objType = ObjectTools.getImmediateClassPath(dump);
            if(objType == "Object" || objType == "Object.Array")
            {
               Debug.traceObject(dump,objectRecursionDepth,indentation,classPackage,level);
            }
            else
            {
               obj = PropertyTools.getProperties(dump);
               Debug.traceObject(obj,displayObjectRecursionDepth,indentation,classPackage,level);
            }
         }
      }
      
      public function setFilters(p_filters:Array) : void
      {
         filters = p_filters;
      }
   }
}

