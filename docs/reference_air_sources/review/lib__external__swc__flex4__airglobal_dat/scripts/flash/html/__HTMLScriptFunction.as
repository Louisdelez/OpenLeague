package flash.html
{
   import flash.events.*;
   import flash.utils.*;
   
   use namespace AS3;
   
   [native(cls="HTMLScriptFunctionClass",instance="HTMLScriptProxy::HTMLScriptFunctionObject",methods="auto",instancebase="HTMLScriptProxy::HTMLScriptFunctionObjectBase",construct="native")]
   internal final dynamic class __HTMLScriptFunction extends Function
   {
      
      private static var s_UpdateDirtyDocumentsTimer:Timer = null;
      
      public function __HTMLScriptFunction()
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
      
      private native function nativeEnumProperties(param1:Function) : void;
      
      private native function nativeGetJSProperty(param1:String) : *;
      
      private native function nativeApply(param1:__HTMLScriptFunction, param2:* = undefined, param3:* = undefined) : *;
      
      override public function get prototype() : *
      {
         return this.nativeGetJSProperty("prototype");
      }
      
      override public function set prototype(p:*) : *
      {
         throw new Error("You cannot set the prototype of a __HTMLScriptFunction from ActionScript");
      }
      
      override public function get length() : int
      {
         return int(this.nativeGetJSProperty("length"));
      }
      
      override AS3 function call(thisArg:* = undefined, ... args) : *
      {
         var thisRef:__HTMLScriptFunction = this;
         return thisRef.apply(thisArg,args);
      }
      
      override AS3 function apply(thisArg:* = undefined, argArray:* = undefined) : *
      {
         var jsApply:__HTMLScriptFunction = this.nativeGetJSProperty("apply");
         return this.nativeApply(jsApply,thisArg,argArray);
      }
   }
}

