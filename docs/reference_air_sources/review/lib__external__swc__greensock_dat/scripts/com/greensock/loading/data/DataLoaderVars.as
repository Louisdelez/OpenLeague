package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   
   public class DataLoaderVars
   {
      
      public static const version:Number = 1.2;
      
      protected var _vars:Object;
      
      public function DataLoaderVars(vars:Object = null)
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
      
      public function onHTTPStatus(value:Function) : DataLoaderVars
      {
         return _set("onHTTPStatus",value);
      }
      
      public function onOpen(value:Function) : DataLoaderVars
      {
         return _set("onOpen",value);
      }
      
      public function get isGSVars() : Boolean
      {
         return true;
      }
      
      protected function _set(property:String, value:*) : DataLoaderVars
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
      
      public function allowMalformedURL(value:Boolean) : DataLoaderVars
      {
         return _set("allowMalformedURL",value);
      }
      
      public function noCache(value:Boolean) : DataLoaderVars
      {
         return _set("noCache",value);
      }
      
      public function onError(value:Function) : DataLoaderVars
      {
         return _set("onError",value);
      }
      
      public function prop(property:String, value:*) : DataLoaderVars
      {
         return _set(property,value);
      }
      
      public function onProgress(value:Function) : DataLoaderVars
      {
         return _set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : DataLoaderVars
      {
         return _set("requireWithRoot",value);
      }
      
      public function get vars() : Object
      {
         return _vars;
      }
      
      public function estimatedBytes(value:uint) : DataLoaderVars
      {
         return _set("estimatedBytes",value);
      }
      
      public function autoDispose(value:Boolean) : DataLoaderVars
      {
         return _set("autoDispose",value);
      }
      
      public function name(value:String) : DataLoaderVars
      {
         return _set("name",value);
      }
      
      public function alternateURL(value:String) : DataLoaderVars
      {
         return _set("alternateURL",value);
      }
      
      public function format(value:String) : DataLoaderVars
      {
         return _set("format",value);
      }
      
      public function onComplete(value:Function) : DataLoaderVars
      {
         return _set("onComplete",value);
      }
      
      public function onCancel(value:Function) : DataLoaderVars
      {
         return _set("onCancel",value);
      }
      
      public function onIOError(value:Function) : DataLoaderVars
      {
         return _set("onIOError",value);
      }
      
      public function onFail(value:Function) : DataLoaderVars
      {
         return _set("onFail",value);
      }
   }
}

