package flash.html
{
   import flash.events.*;
   import flash.utils.*;
   
   use namespace AS3;
   
   [native(cls="HTMLScriptArrayClass",instance="HTMLScriptProxy::HTMLScriptArrayObject",methods="auto",construct="native")]
   internal final dynamic class __HTMLScriptArray extends Array
   {
      
      private static var s_UpdateDirtyDocumentsTimer:Timer = null;
      
      public function __HTMLScriptArray()
      {
         super();
         this.nativeInit(this.throwJSError,this.throwJSOperationFailed,this.throwJSObjectDead,this.handleNSSetProperty,this.operationComplete);
      }
      
      private static native function nativeUpdateDirtyDocuments() : void;
      
      private static function onUpdateDirtyDocumentsTimer(ev:TimerEvent) : void
      {
         s_UpdateDirtyDocumentsTimer.stop();
         nativeUpdateDirtyDocuments();
      }
      
      private function operationComplete() : void
      {
         if(s_UpdateDirtyDocumentsTimer == null)
         {
            s_UpdateDirtyDocumentsTimer = new Timer(1,0);
            s_UpdateDirtyDocumentsTimer.addEventListener(TimerEvent.TIMER,onUpdateDirtyDocumentsTimer);
         }
         s_UpdateDirtyDocumentsTimer.start();
      }
      
      private native function nativeInit(param1:Function, param2:Function, param3:Function, param4:Function, param5:Function) : void;
      
      private function throwJSError(jsErrorObj:*) : void
      {
         throw jsErrorObj;
      }
      
      private function throwJSOperationFailed() : void
      {
         throw new Error("HTMLScript operation failed.");
      }
      
      private function throwJSObjectDead() : void
      {
         throw new Error(Error.getErrorMessage(3210),3210);
      }
      
      private function handleNSSetProperty() : void
      {
      }
      
      private function getProperty(propertyName:String) : *
      {
         return this[propertyName];
      }
      
      private native function nativeEnumProperties(param1:Function) : void;
      
      private native function nativeGetJSProperty(param1:String) : *;
      
      private native function nativeSetJSProperty(param1:String, param2:*) : void;
      
      private native function nativeCall(param1:__HTMLScriptFunction, param2:Object, param3:Array) : *;
      
      override public function get length() : uint
      {
         return int(this.nativeGetJSProperty("length"));
      }
      
      override public function set length(newLength:uint) : *
      {
         this.nativeSetJSProperty("length",newLength);
      }
      
      private function callJS(name:String, args:Array) : *
      {
         var fn:__HTMLScriptFunction = this.nativeGetJSProperty(name);
         return this.nativeCall(fn,this,args);
      }
      
      private function callJSV(name:String, ... args) : *
      {
         return this.callJS(name,args);
      }
      
      override AS3 function join(sep:* = undefined) : String
      {
         return this.callJSV("join",sep);
      }
      
      override AS3 function pop() : *
      {
         return this.callJSV("pop");
      }
      
      override AS3 function push(... args) : uint
      {
         return this.callJS("push",args);
      }
      
      override AS3 function reverse() : Array
      {
         return this.callJSV("reverse");
      }
      
      override AS3 function concat(... args) : Array
      {
         return this.callJS("concat",args);
      }
      
      override AS3 function shift() : *
      {
         return this.callJSV("shift");
      }
      
      override AS3 function slice(A:* = 0, B:* = 4294967295) : Array
      {
         return this.callJSV("slice",A,B);
      }
      
      override AS3 function unshift(... args) : uint
      {
         return this.callJS("unshift",args);
      }
      
      override AS3 function splice(... args) : *
      {
         return this.callJS("splice",args);
      }
      
      override AS3 function sort(... args) : *
      {
         return this.callJS("sort",args);
      }
      
      override AS3 function sortOn(names:*, options:* = 0, ... ignored) : *
      {
         return this.callJSV("sortOn",names,options);
      }
      
      override AS3 function indexOf(searchElement:*, fromIndex:* = 0) : int
      {
         return this.callJSV("indexOf",searchElement,fromIndex);
      }
      
      override AS3 function lastIndexOf(searchElement:*, fromIndex:* = 2147483647) : int
      {
         return this.callJSV("lastIndexOf",searchElement,fromIndex);
      }
      
      override AS3 function every(callback:Function, thisObject:* = null) : Boolean
      {
         return this.callJSV("every",callback,thisObject);
      }
      
      override AS3 function filter(callback:Function, thisObject:* = null) : Array
      {
         return this.callJSV("filter",callback,thisObject);
      }
      
      override AS3 function forEach(callback:Function, thisObject:* = null) : void
      {
         this.callJSV("forEach",callback,thisObject);
      }
      
      override AS3 function map(callback:Function, thisObject:* = null) : Array
      {
         return this.callJSV("map",callback,thisObject);
      }
      
      override AS3 function some(callback:Function, thisObject:* = null) : Boolean
      {
         return this.callJSV("some",callback,thisObject);
      }
   }
}

