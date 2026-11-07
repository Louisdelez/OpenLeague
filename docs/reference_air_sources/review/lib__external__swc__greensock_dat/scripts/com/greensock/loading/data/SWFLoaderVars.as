package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.LoaderContext;
   
   public class SWFLoaderVars
   {
      
      public static const version:Number = 1.23;
      
      protected var _vars:Object;
      
      public function SWFLoaderVars(vars:Object = null)
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
      
      public function container(value:DisplayObjectContainer) : SWFLoaderVars
      {
         return _set("container",value);
      }
      
      public function autoPlay(value:Boolean) : SWFLoaderVars
      {
         return _set("autoPlay",value);
      }
      
      public function rotation(value:Number) : SWFLoaderVars
      {
         return _set("rotation",value);
      }
      
      public function onSecurityError(value:Function) : SWFLoaderVars
      {
         return _set("onSecurityError",value);
      }
      
      public function scaleMode(value:String) : SWFLoaderVars
      {
         return _set("scaleMode",value);
      }
      
      public function estimatedBytes(value:uint) : SWFLoaderVars
      {
         return _set("estimatedBytes",value);
      }
      
      public function crop(value:Boolean) : SWFLoaderVars
      {
         return _set("crop",value);
      }
      
      public function name(value:String) : SWFLoaderVars
      {
         return _set("name",value);
      }
      
      public function blendMode(value:String) : SWFLoaderVars
      {
         return _set("blendMode",value);
      }
      
      public function alternateURL(value:String) : SWFLoaderVars
      {
         return _set("alternateURL",value);
      }
      
      public function bgAlpha(value:Number) : SWFLoaderVars
      {
         return _set("bgAlpha",value);
      }
      
      public function rotationX(value:Number) : SWFLoaderVars
      {
         return _set("rotationX",value);
      }
      
      public function rotationY(value:Number) : SWFLoaderVars
      {
         return _set("rotationY",value);
      }
      
      public function rotationZ(value:Number) : SWFLoaderVars
      {
         return _set("rotationZ",value);
      }
      
      public function allowMalformedURL(value:Boolean) : SWFLoaderVars
      {
         return _set("allowMalformedURL",value);
      }
      
      public function bgColor(value:uint) : SWFLoaderVars
      {
         return _set("bgColor",value);
      }
      
      protected function _set(property:String, value:*) : SWFLoaderVars
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
      
      public function onFail(value:Function) : SWFLoaderVars
      {
         return _set("onFail",value);
      }
      
      public function height(value:Number) : SWFLoaderVars
      {
         return _set("height",value);
      }
      
      public function onProgress(value:Function) : SWFLoaderVars
      {
         return _set("onProgress",value);
      }
      
      public function centerRegistration(value:Boolean) : SWFLoaderVars
      {
         return _set("centerRegistration",value);
      }
      
      public function context(value:LoaderContext) : SWFLoaderVars
      {
         return _set("context",value);
      }
      
      public function onInit(value:Function) : SWFLoaderVars
      {
         return _set("onInit",value);
      }
      
      public function suppressUncaughtErrors(value:Boolean) : SWFLoaderVars
      {
         return _set("suppressUncaughtErrors",value);
      }
      
      public function vAlign(value:String) : SWFLoaderVars
      {
         return _set("vAlign",value);
      }
      
      public function onComplete(value:Function) : SWFLoaderVars
      {
         return _set("onComplete",value);
      }
      
      public function onCancel(value:Function) : SWFLoaderVars
      {
         return _set("onCancel",value);
      }
      
      public function onChildFail(value:Function) : SWFLoaderVars
      {
         return _set("onChildFail",value);
      }
      
      public function onHTTPStatus(value:Function) : SWFLoaderVars
      {
         return _set("onHTTPStatus",value);
      }
      
      public function noCache(value:Boolean) : SWFLoaderVars
      {
         return _set("noCache",value);
      }
      
      public function onIOError(value:Function) : SWFLoaderVars
      {
         return _set("onIOError",value);
      }
      
      public function get vars() : Object
      {
         return _vars;
      }
      
      public function width(value:Number) : SWFLoaderVars
      {
         return _set("width",value);
      }
      
      public function onOpen(value:Function) : SWFLoaderVars
      {
         return _set("onOpen",value);
      }
      
      public function onChildProgress(value:Function) : SWFLoaderVars
      {
         return _set("onChildProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : SWFLoaderVars
      {
         return _set("requireWithRoot",value);
      }
      
      public function scaleX(value:Number) : SWFLoaderVars
      {
         return _set("scaleX",value);
      }
      
      public function scaleY(value:Number) : SWFLoaderVars
      {
         return _set("scaleY",value);
      }
      
      public function onChildComplete(value:Function) : SWFLoaderVars
      {
         return _set("onChildComplete",value);
      }
      
      public function onChildCancel(value:Function) : SWFLoaderVars
      {
         return _set("onChildCancel",value);
      }
      
      public function onUncaughtError(value:Function) : SWFLoaderVars
      {
         return _set("onUncaughtError",value);
      }
      
      public function suppressInitReparentEvents(value:Boolean) : SWFLoaderVars
      {
         return _set("suppressInitReparentEvents",value);
      }
      
      public function alpha(value:Number) : SWFLoaderVars
      {
         return _set("alpha",value);
      }
      
      public function get isGSVars() : Boolean
      {
         return true;
      }
      
      public function prop(property:String, value:*) : SWFLoaderVars
      {
         return _set(property,value);
      }
      
      public function onChildOpen(value:Function) : SWFLoaderVars
      {
         return _set("onChildOpen",value);
      }
      
      public function onError(value:Function) : SWFLoaderVars
      {
         return _set("onError",value);
      }
      
      public function autoDispose(value:Boolean) : SWFLoaderVars
      {
         return _set("autoDispose",value);
      }
      
      public function visible(value:Boolean) : SWFLoaderVars
      {
         return _set("visible",value);
      }
      
      public function x(value:Number) : SWFLoaderVars
      {
         return _set("x",value);
      }
      
      public function y(value:Number) : SWFLoaderVars
      {
         return _set("y",value);
      }
      
      public function z(value:Number) : SWFLoaderVars
      {
         return _set("z",value);
      }
      
      public function hAlign(value:String) : SWFLoaderVars
      {
         return _set("hAlign",value);
      }
      
      public function integrateProgress(value:Boolean) : SWFLoaderVars
      {
         return _set("integrateProgress",value);
      }
   }
}

