package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class FrameForwardPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _backward:Boolean;
      
      protected var _start:int;
      
      protected var _max:uint;
      
      protected var _change:int;
      
      protected var _target:MovieClip;
      
      public function FrameForwardPlugin()
      {
         super();
         this.propName = "frameForward";
         this.overwriteProps = ["frame","frameLabel","frameForward","frameBackward"];
         this.round = true;
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var frame:Number = (_start + _change * n) % _max;
         if(frame < 0.5 && frame >= -0.5)
         {
            frame = _max;
         }
         else if(frame < 0)
         {
            frame += _max;
         }
         _target.gotoAndStop(int(frame + 0.5));
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!(target is MovieClip) || isNaN(value))
         {
            return false;
         }
         _target = target as MovieClip;
         _start = _target.currentFrame;
         _max = _target.totalFrames;
         _change = typeof value == "number" ? int(Number(value) - _start) : int(Number(value));
         if(!_backward && _change < 0)
         {
            _change += _max;
         }
         else if(_backward && _change > 0)
         {
            _change -= _max;
         }
         return true;
      }
   }
}

