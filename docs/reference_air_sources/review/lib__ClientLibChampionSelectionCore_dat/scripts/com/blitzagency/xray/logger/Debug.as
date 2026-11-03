package com.blitzagency.xray.logger
{
   import com.blitzagency.xray.logger.events.DebugDispatcher;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   import flash.utils.*;
   
   public class Debug
   {
      
      private static var xrayLC:LocalConnection;
      
      private static var connected:Boolean = false;
      
      private static var ed:DebugDispatcher = new DebugDispatcher();
      
      public function Debug()
      {
         super();
      }
      
      public static function traceObject(o:Object, pRecurseDepth:Number = 254, pIndent:Number = 0, pPackage:String = "", pLevel:Number = 0) : void
      {
         var recurseDepth:Number = NaN;
         var indent:Number = NaN;
         var prop:String = null;
         var lead:String = null;
         var i:Number = NaN;
         var obj:String = null;
         try
         {
            recurseDepth = pRecurseDepth;
            indent = pIndent;
            for(prop in o)
            {
               lead = "";
               for(i = 0; i < indent; i++)
               {
                  lead += "    ";
               }
               obj = o[prop].toString();
               if(o[prop] is Array)
               {
                  obj = "[Array]";
               }
               if(obj == "[object Object]")
               {
                  obj = "[Object]";
               }
               Debug.trace(lead + prop + ": " + obj,pPackage,pLevel);
               if(recurseDepth > 0)
               {
                  Debug.traceObject(o[prop],recurseDepth - 1,indent + 1,pPackage,pLevel);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function trace(pMsg:Object, pPackage:String = "", pLevel:Number = 0) : void
      {
         var msg:String = null;
         ed.sendEvent(DebugDispatcher.TRACE,{
            "message":pMsg,
            "classPackage":pPackage
         });
         if(!connected)
         {
            makeConnection();
         }
         if(connected)
         {
            try
            {
               msg = String(pMsg).length >= 39995 ? String(pMsg).substr(0,39995) + "..." : String(pMsg);
               xrayLC.send("_xray_view_conn","setTrace",msg,pLevel,pPackage);
            }
            catch(e:LogError)
            {
               LogError("No Xray Interface running");
            }
         }
      }
      
      private static function makeConnection() : void
      {
         var err:LogError = null;
         xrayLC = new LocalConnection();
         xrayLC.addEventListener("status",statusHandler);
         xrayLC.allowDomain("*");
         try
         {
            xrayLC.connect("_xray_standAlone_debug" + getTimer());
            connected = true;
         }
         catch(e:Error)
         {
            err = new LogError("log");
            setTimeout(makeConnection,1000);
         }
      }
      
      public static function addEventListener(type:String, listener:Function) : void
      {
         ed.addEventListener(type,listener);
      }
      
      private static function initialize() : Boolean
      {
         ed = new DebugDispatcher();
         return true;
      }
      
      private static function statusHandler(event:StatusEvent) : void
      {
         if(event.code == null && event.level == "error" && connected)
         {
            connected = false;
         }
         else if(event.level == "status" && event.code == null)
         {
            connected = true;
         }
      }
   }
}

class LogError extends Error
{
   
   public function LogError(message:String)
   {
      super(message);
   }
}
