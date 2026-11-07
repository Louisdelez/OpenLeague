package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class VideoLoaderVars
   {
      
      public static const version:Number = 1.23;
      
      protected var _vars:Object;
      
      public function VideoLoaderVars(vars:Object = null)
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
      
      public function container(value:DisplayObjectContainer) : VideoLoaderVars
      {
         return _set("container",value);
      }
      
      public function autoPlay(value:Boolean) : VideoLoaderVars
      {
         return _set("autoPlay",value);
      }
      
      public function rotation(value:Number) : VideoLoaderVars
      {
         return _set("rotation",value);
      }
      
      public function onSecurityError(value:Function) : VideoLoaderVars
      {
         return _set("onSecurityError",value);
      }
      
      public function bufferMode(value:Boolean) : VideoLoaderVars
      {
         return _set("bufferMode",value);
      }
      
      public function scaleMode(value:String) : VideoLoaderVars
      {
         return _set("scaleMode",value);
      }
      
      public function onInit(value:Function) : VideoLoaderVars
      {
         return _set("onInit",value);
      }
      
      public function crop(value:Boolean) : VideoLoaderVars
      {
         return _set("crop",value);
      }
      
      public function name(value:String) : VideoLoaderVars
      {
         return _set("name",value);
      }
      
      public function blendMode(value:String) : VideoLoaderVars
      {
         return _set("blendMode",value);
      }
      
      public function alternateURL(value:String) : VideoLoaderVars
      {
         return _set("alternateURL",value);
      }
      
      public function bgAlpha(value:Number) : VideoLoaderVars
      {
         return _set("bgAlpha",value);
      }
      
      public function rotationX(value:Number) : VideoLoaderVars
      {
         return _set("rotationX",value);
      }
      
      public function rotationY(value:Number) : VideoLoaderVars
      {
         return _set("rotationY",value);
      }
      
      public function rotationZ(value:Number) : VideoLoaderVars
      {
         return _set("rotationZ",value);
      }
      
      public function allowMalformedURL(value:Boolean) : VideoLoaderVars
      {
         return _set("allowMalformedURL",value);
      }
      
      public function bgColor(value:uint) : VideoLoaderVars
      {
         return _set("bgColor",value);
      }
      
      public function volume(value:Number) : VideoLoaderVars
      {
         return _set("volume",value);
      }
      
      public function repeat(value:int) : VideoLoaderVars
      {
         return _set("repeat",value);
      }
      
      protected function _set(property:String, value:*) : VideoLoaderVars
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
      
      public function onFail(value:Function) : VideoLoaderVars
      {
         return _set("onFail",value);
      }
      
      public function estimatedBytes(value:uint) : VideoLoaderVars
      {
         return _set("estimatedBytes",value);
      }
      
      public function onProgress(value:Function) : VideoLoaderVars
      {
         return _set("onProgress",value);
      }
      
      public function bufferTime(value:Number) : VideoLoaderVars
      {
         return _set("bufferTime",value);
      }
      
      public function centerRegistration(value:Boolean) : VideoLoaderVars
      {
         return _set("centerRegistration",value);
      }
      
      public function vAlign(value:String) : VideoLoaderVars
      {
         return _set("vAlign",value);
      }
      
      public function deblocking(value:int) : VideoLoaderVars
      {
         return _set("deblocking",value);
      }
      
      public function onComplete(value:Function) : VideoLoaderVars
      {
         return _set("onComplete",value);
      }
      
      public function onCancel(value:Function) : VideoLoaderVars
      {
         return _set("onCancel",value);
      }
      
      public function get vars() : Object
      {
         return _vars;
      }
      
      public function height(value:Number) : VideoLoaderVars
      {
         return _set("height",value);
      }
      
      public function onHTTPStatus(value:Function) : VideoLoaderVars
      {
         return _set("onHTTPStatus",value);
      }
      
      public function noCache(value:Boolean) : VideoLoaderVars
      {
         return _set("noCache",value);
      }
      
      public function onIOError(value:Function) : VideoLoaderVars
      {
         return _set("onIOError",value);
      }
      
      public function width(value:Number) : VideoLoaderVars
      {
         return _set("width",value);
      }
      
      public function onOpen(value:Function) : VideoLoaderVars
      {
         return _set("onOpen",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : VideoLoaderVars
      {
         return _set("requireWithRoot",value);
      }
      
      public function scaleX(value:Number) : VideoLoaderVars
      {
         return _set("scaleX",value);
      }
      
      public function scaleY(value:Number) : VideoLoaderVars
      {
         return _set("scaleY",value);
      }
      
      public function alpha(value:Number) : VideoLoaderVars
      {
         return _set("alpha",value);
      }
      
      public function get isGSVars() : Boolean
      {
         return true;
      }
      
      public function prop(property:String, value:*) : VideoLoaderVars
      {
         return _set(property,value);
      }
      
      public function onError(value:Function) : VideoLoaderVars
      {
         return _set("onError",value);
      }
      
      public function autoDispose(value:Boolean) : VideoLoaderVars
      {
         return _set("autoDispose",value);
      }
      
      public function visible(value:Boolean) : VideoLoaderVars
      {
         return _set("visible",value);
      }
      
      public function smoothing(value:Boolean) : VideoLoaderVars
      {
         return _set("smoothing",value);
      }
      
      public function checkPolicyFile(value:Boolean) : VideoLoaderVars
      {
         return _set("checkPolicyFile",value);
      }
      
      public function estimatedDuration(value:Number) : VideoLoaderVars
      {
         return _set("estimatedDuration",value);
      }
      
      public function x(value:Number) : VideoLoaderVars
      {
         return _set("x",value);
      }
      
      public function y(value:Number) : VideoLoaderVars
      {
         return _set("y",value);
      }
      
      public function z(value:Number) : VideoLoaderVars
      {
         return _set("z",value);
      }
      
      public function autoDetachNetStream(value:Boolean) : VideoLoaderVars
      {
         return _set("autoDetachNetStream",value);
      }
      
      public function hAlign(value:String) : VideoLoaderVars
      {
         return _set("hAlign",value);
      }
      
      public function autoAdjustBuffer(value:Boolean) : VideoLoaderVars
      {
         return _set("autoAdjustBuffer",value);
      }
   }
}

