package com.greensock.plugins
{
   import com.greensock.*;
   import flash.media.SoundTransform;
   
   public class SoundTransformPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _target:Object;
      
      protected var _st:SoundTransform;
      
      public function SoundTransformPlugin()
      {
         super();
         this.propName = "soundTransform";
         this.overwriteProps = ["soundTransform","volume"];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         var p:String = null;
         if(!target.hasOwnProperty("soundTransform"))
         {
            return false;
         }
         _target = target;
         _st = _target.soundTransform;
         for(p in value)
         {
            addTween(_st,p,_st[p],value[p],p);
         }
         return true;
      }
      
      override public function set changeFactor(n:Number) : void
      {
         updateTweens(n);
         _target.soundTransform = _st;
      }
   }
}

