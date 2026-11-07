package com.blitzagency.xray.logger
{
   import com.blitzagency.xray.logger.util.ObjectTools;
   
   public class Log
   {
      
      private var level:Number;
      
      private var caller:String = "";
      
      private var classPackage:String;
      
      private var dump:Object;
      
      private var message:String;
      
      public function Log(p_message:String, p_dump:Object, p_level:Number, ... rest)
      {
         var err:LogError = null;
         var nullArray:Array = null;
         var str:String = null;
         caller = "";
         super();
         try
         {
            nullArray.push("bogus");
         }
         catch(e:Error)
         {
            err = new LogError("log");
         }
         finally
         {
            if(err.hasOwnProperty("getStackTrace"))
            {
               str = err.getStackTrace();
               setCaller(resolveCaller(str));
            }
            else
            {
               setCaller("");
            }
            setMessage(p_message);
            setDump(p_dump);
            setLevel(p_level);
            setClassPackage(p_dump);
         }
      }
      
      public function setLevel(p_level:Number) : void
      {
         level = p_level;
      }
      
      public function getCaller() : String
      {
         return caller;
      }
      
      public function setMessage(p_message:String) : void
      {
         message = p_message;
      }
      
      public function getLevel() : Number
      {
         return level;
      }
      
      public function getDump() : Object
      {
         return dump;
      }
      
      public function setCaller(p_caller:String) : void
      {
         caller = p_caller;
      }
      
      public function setClassPackage(obj:Object) : void
      {
         classPackage = ObjectTools.getImmediateClassPath(obj);
      }
      
      public function getMessage() : String
      {
         return message;
      }
      
      public function getClassPackage() : String
      {
         return classPackage;
      }
      
      public function setDump(p_dump:Object) : void
      {
         dump = p_dump;
      }
      
      private function resolveCaller(str:String) : String
      {
         var ary:Array = null;
         ary = [];
         try
         {
            str = str.split("\n").join("");
            ary = str.split("\tat ");
            str = ary[3];
         }
         catch(e:Error)
         {
         }
         finally
         {
            str = "";
         }
         return str;
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
