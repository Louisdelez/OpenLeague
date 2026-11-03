package flash.html
{
   import flash.events.*;
   import flash.utils.*;
   
   [native(cls="HTMLScriptObjectClass",instance="HTMLScriptProxy::HTMLScriptObjectObject",methods="auto",construct="native")]
   internal final dynamic class __HTMLScriptObject
   {
      
      private static var s_UpdateDirtyDocumentsTimer:Timer = null;
      
      public function __HTMLScriptObject()
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
   }
}

