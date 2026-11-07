package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.LoaderContext;
   
   public class ImageLoaderVars
   {
      
      public static const version:Number = 1.22;
      
      protected var _vars:Object;
      
      public function ImageLoaderVars(vars:Object = null)
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
      
      public function onCancel(value:Function) : ImageLoaderVars
      {
         return _set("onCancel",value);
      }
      
      public function noCache(value:Boolean) : ImageLoaderVars
      {
         return _set("noCache",value);
      }
      
      public function onIOError(value:Function) : ImageLoaderVars
      {
         return _set("onIOError",value);
      }
      
      public function width(value:Number) : ImageLoaderVars
      {
         return _set("width",value);
      }
      
      public function container(value:DisplayObjectContainer) : ImageLoaderVars
      {
         return _set("container",value);
      }
      
      public function onOpen(value:Function) : ImageLoaderVars
      {
         return _set("onOpen",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : ImageLoaderVars
      {
         return _set("requireWithRoot",value);
      }
      
      public function scaleX(value:Number) : ImageLoaderVars
      {
         return _set("scaleX",value);
      }
      
      public function estimatedBytes(value:uint) : ImageLoaderVars
      {
         return _set("estimatedBytes",value);
      }
      
      public function crop(value:Boolean) : ImageLoaderVars
      {
         return _set("crop",value);
      }
      
      public function y(value:Number) : ImageLoaderVars
      {
         return _set("y",value);
      }
      
      public function name(value:String) : ImageLoaderVars
      {
         return _set("name",value);
      }
      
      public function blendMode(value:String) : ImageLoaderVars
      {
         return _set("blendMode",value);
      }
      
      public function alternateURL(value:String) : ImageLoaderVars
      {
         return _set("alternateURL",value);
      }
      
      public function onSecurityError(value:Function) : ImageLoaderVars
      {
         return _set("onSecurityError",value);
      }
      
      public function bgAlpha(value:Number) : ImageLoaderVars
      {
         return _set("bgAlpha",value);
      }
      
      public function rotationX(value:Number) : ImageLoaderVars
      {
         return _set("rotationX",value);
      }
      
      public function rotationY(value:Number) : ImageLoaderVars
      {
         return _set("rotationY",value);
      }
      
      public function rotationZ(value:Number) : ImageLoaderVars
      {
         return _set("rotationZ",value);
      }
      
      public function allowMalformedURL(value:Boolean) : ImageLoaderVars
      {
         return _set("allowMalformedURL",value);
      }
      
      public function bgColor(value:uint) : ImageLoaderVars
      {
         return _set("bgColor",value);
      }
      
      public function get isGSVars() : Boolean
      {
         return true;
      }
      
      protected function _set(property:String, value:*) : ImageLoaderVars
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
      
      public function onFail(value:Function) : ImageLoaderVars
      {
         return _set("onFail",value);
      }
      
      public function alpha(value:Number) : ImageLoaderVars
      {
         return _set("alpha",value);
      }
      
      public function height(value:Number) : ImageLoaderVars
      {
         return _set("height",value);
      }
      
      public function onError(value:Function) : ImageLoaderVars
      {
         return _set("onError",value);
      }
      
      public function prop(property:String, value:*) : ImageLoaderVars
      {
         return _set(property,value);
      }
      
      public function onProgress(value:Function) : ImageLoaderVars
      {
         return _set("onProgress",value);
      }
      
      public function z(value:Number) : ImageLoaderVars
      {
         return _set("z",value);
      }
      
      public function centerRegistration(value:Boolean) : ImageLoaderVars
      {
         return _set("centerRegistration",value);
      }
      
      public function context(value:LoaderContext) : ImageLoaderVars
      {
         return _set("context",value);
      }
      
      public function autoDispose(value:Boolean) : ImageLoaderVars
      {
         return _set("autoDispose",value);
      }
      
      public function scaleY(value:Number) : ImageLoaderVars
      {
         return _set("scaleY",value);
      }
      
      public function visible(value:Boolean) : ImageLoaderVars
      {
         return _set("visible",value);
      }
      
      public function smoothing(value:Boolean) : ImageLoaderVars
      {
         return _set("smoothing",value);
      }
      
      public function vAlign(value:String) : ImageLoaderVars
      {
         return _set("vAlign",value);
      }
      
      public function onComplete(value:Function) : ImageLoaderVars
      {
         return _set("onComplete",value);
      }
      
      public function onHTTPStatus(value:Function) : ImageLoaderVars
      {
         return _set("onHTTPStatus",value);
      }
      
      public function scaleMode(value:String) : ImageLoaderVars
      {
         return _set("scaleMode",value);
      }
      
      public function get vars() : Object
      {
         return _vars;
      }
      
      public function hAlign(value:String) : ImageLoaderVars
      {
         return _set("hAlign",value);
      }
      
      public function rotation(value:Number) : ImageLoaderVars
      {
         return _set("rotation",value);
      }
      
      public function x(value:Number) : ImageLoaderVars
      {
         return _set("x",value);
      }
   }
}

