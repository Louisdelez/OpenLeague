package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   
   public class LoaderMaxVars
   {
      
      public static const version:Number = 1.1;
      
      protected var _vars:Object;
      
      public function LoaderMaxVars(vars:Object = null)
      {
         var p:String = null;
         super();
         _vars = {};
         if(vars != null)
         {
            for(p in vars)
            {
               _vars[p] = vars[p];
            }
         }
      }
      
      public function loaders(value:Array) : LoaderMaxVars
      {
         return _set("loaders",value);
      }
      
      public function onIOError(value:Function) : LoaderMaxVars
      {
         return _set("onIOError",value);
      }
      
      public function get vars() : Object
      {
         return _vars;
      }
      
      public function onCancel(value:Function) : LoaderMaxVars
      {
         return _set("onCancel",value);
      }
      
      public function onOpen(value:Function) : LoaderMaxVars
      {
         return _set("onOpen",value);
      }
      
      public function onChildProgress(value:Function) : LoaderMaxVars
      {
         return _set("onChildProgress",value);
      }
      
      public function skipPaused(value:Boolean) : LoaderMaxVars
      {
         return _set("skipPaused",value);
      }
      
      public function onScriptAccessDenied(value:Function) : LoaderMaxVars
      {
         return _set("onScriptAccessDenied",value);
      }
      
      public function maxConnections(value:uint) : LoaderMaxVars
      {
         return _set("maxConnections",value);
      }
      
      public function name(value:String) : LoaderMaxVars
      {
         return _set("name",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : LoaderMaxVars
      {
         return _set("requireWithRoot",value);
      }
      
      public function onChildComplete(value:Function) : LoaderMaxVars
      {
         return _set("onChildComplete",value);
      }
      
      public function onChildCancel(value:Function) : LoaderMaxVars
      {
         return _set("onChildCancel",value);
      }
      
      public function skipFailed(value:Boolean) : LoaderMaxVars
      {
         return _set("skipFailed",value);
      }
      
      public function get isGSVars() : Boolean
      {
         return true;
      }
      
      protected function _set(property:String, value:*) : LoaderMaxVars
      {
         if(value == null)
         {
            delete _vars[property];
         }
         else
         {
            _vars[property] = value;
         }
         return this;
      }
      
      public function onFail(value:Function) : LoaderMaxVars
      {
         return _set("onFail",value);
      }
      
      public function onChildOpen(value:Function) : LoaderMaxVars
      {
         return _set("onChildOpen",value);
      }
      
      public function onError(value:Function) : LoaderMaxVars
      {
         return _set("onError",value);
      }
      
      public function prop(property:String, value:*) : LoaderMaxVars
      {
         return _set(property,value);
      }
      
      public function onProgress(value:Function) : LoaderMaxVars
      {
         return _set("onProgress",value);
      }
      
      public function autoDispose(value:Boolean) : LoaderMaxVars
      {
         return _set("autoDispose",value);
      }
      
      public function autoLoad(value:Boolean) : LoaderMaxVars
      {
         return _set("autoLoad",value);
      }
      
      public function onComplete(value:Function) : LoaderMaxVars
      {
         return _set("onComplete",value);
      }
      
      public function onHTTPStatus(value:Function) : LoaderMaxVars
      {
         return _set("onHTTPStatus",value);
      }
      
      public function onChildFail(value:Function) : LoaderMaxVars
      {
         return _set("onChildFail",value);
      }
      
      public function auditSize(value:Boolean) : LoaderMaxVars
      {
         return _set("auditSize",value);
      }
   }
}

