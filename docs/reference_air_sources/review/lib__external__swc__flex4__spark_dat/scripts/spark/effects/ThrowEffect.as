package spark.effects
{
   import flash.geom.Point;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Power;
   import spark.effects.easing.Sine;
   
   [ExcludeClass]
   public class ThrowEffect extends Animate
   {
      
      private static const THROW_OVERSHOOT_TIME:int = 200;
      
      private static const THROW_SETTLE_TIME:int = 600;
      
      private static const THROW_CURVE_EXPONENT:Number = 3;
      
      private static const OVERSHOOT_CURVE_EXPONENT:Number = 2;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var propertyNameX:String = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var propertyNameY:String = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var startingVelocityX:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var startingVelocityY:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var startingPositionX:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var startingPositionY:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var minPositionX:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var minPositionY:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var maxPositionX:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var maxPositionY:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var decelerationFactor:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var finalPosition:Point;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var finalPositionFilterFunction:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isSnapping:Boolean = false;
      
      private var horizontalMP:SimpleMotionPath = null;
      
      private var verticalMP:SimpleMotionPath = null;
      
      public function ThrowEffect()
      {
         super();
      }
      
      private function calculateThrowEffectTime(velocityX:Number, velocityY:Number) : int
      {
         var throwTimeX:int = velocityX == 0 ? 0 : int(Math.log(0.01 / Math.abs(velocityX)) / Math.log(this.decelerationFactor));
         var throwTimeY:int = velocityY == 0 ? 0 : int(Math.log(0.01 / Math.abs(velocityY)) / Math.log(this.decelerationFactor));
         return Math.max(throwTimeX,throwTimeY);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setup() : Boolean
      {
         var throwEaser:IEaser = new Power(0,THROW_CURVE_EXPONENT);
         this.easer = throwEaser;
         var effectTime:int = this.calculateThrowEffectTime(this.startingVelocityX,this.startingVelocityY);
         var throwEffectMotionPaths:Vector.<MotionPath> = new Vector.<MotionPath>();
         this.isSnapping = false;
         var horizontalTime:Number = 0;
         var horizontalFinalPosition:Number = 0;
         this.horizontalMP = null;
         if(Boolean(this.propertyNameX))
         {
            this.horizontalMP = this.createThrowMotionPath(this.propertyNameX,this.startingVelocityX,this.startingPositionX,this.minPositionX,this.maxPositionX,effectTime);
            if(Boolean(this.horizontalMP))
            {
               throwEffectMotionPaths.push(this.horizontalMP);
               horizontalTime = this.horizontalMP.keyframes[this.horizontalMP.keyframes.length - 1].time;
               horizontalFinalPosition = Number(this.horizontalMP.keyframes[this.horizontalMP.keyframes.length - 1].value);
            }
         }
         var verticalTime:Number = 0;
         var verticalFinalPosition:Number = 0;
         this.verticalMP = null;
         if(Boolean(this.propertyNameY))
         {
            this.verticalMP = this.createThrowMotionPath(this.propertyNameY,this.startingVelocityY,this.startingPositionY,this.minPositionY,this.maxPositionY,effectTime);
            if(Boolean(this.verticalMP))
            {
               throwEffectMotionPaths.push(this.verticalMP);
               verticalTime = this.verticalMP.keyframes[this.verticalMP.keyframes.length - 1].time;
               verticalFinalPosition = Number(this.verticalMP.keyframes[this.verticalMP.keyframes.length - 1].value);
            }
         }
         if(throwEffectMotionPaths.length != 0)
         {
            this.duration = Math.max(horizontalTime,verticalTime);
            this.motionPaths = throwEffectMotionPaths;
            this.finalPosition = new Point(horizontalFinalPosition,verticalFinalPosition);
            return true;
         }
         return false;
      }
      
      private function getMotionPathCurrentVelocity(mp:MotionPath, currentTime:Number, totalTime:Number) : Number
      {
         var fraction:Number = currentTime / totalTime;
         var TINY_DELTA_TIME:Number = 0.00001;
         var value1:Number = Number(mp.getValue(fraction));
         var value2:Number = Number(mp.getValue(fraction + TINY_DELTA_TIME / totalTime));
         return (value2 - value1) / TINY_DELTA_TIME;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCurrentVelocity() : Point
      {
         var effectTime:Number = Number(this.playheadTime);
         if(isNaN(effectTime))
         {
            effectTime = 0;
         }
         var effectDuration:Number = Number(this.duration);
         var velX:Number = Boolean(this.horizontalMP) ? this.getMotionPathCurrentVelocity(this.horizontalMP,effectTime,effectDuration) : 0;
         var velY:Number = Boolean(this.verticalMP) ? this.getMotionPathCurrentVelocity(this.verticalMP,effectTime,effectDuration) : 0;
         return new Point(velX,velY);
      }
      
      private function addKeyframe(motionPath:SimpleMotionPath, time:Number, position:Number, easer:IEaser) : Number
      {
         var keyframe:Keyframe = new Keyframe(time,position);
         keyframe.easer = easer;
         motionPath.keyframes.push(keyframe);
         return time;
      }
      
      private function createThrowMotionPath(propertyName:String, velocity:Number, position:Number, minPosition:Number, maxPosition:Number, throwEffectTime:Number) : SimpleMotionPath
      {
         var alignedPosition:Number = NaN;
         var settlePosition:Number = NaN;
         var overshootPosition:Number = NaN;
         var effectTime:Number = NaN;
         var minVelocity:Number = NaN;
         var finalPosition:Number = NaN;
         var endPosition:Number = NaN;
         var partialTime:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var CURVE_PORTION:Number = NaN;
         var motionPath:SimpleMotionPath = new SimpleMotionPath(propertyName);
         motionPath.keyframes = Vector.<Keyframe>([new Keyframe(0,position)]);
         var keyframe:Keyframe = null;
         var nowTime:Number = 0;
         if(velocity == 0)
         {
            if(position < minPosition || position > maxPosition)
            {
               position = position < minPosition ? minPosition : maxPosition;
               if(this.finalPositionFilterFunction != null)
               {
                  position = this.finalPositionFilterFunction(position,propertyName);
               }
               nowTime = this.addKeyframe(motionPath,nowTime + THROW_SETTLE_TIME,position,new Power(0,THROW_CURVE_EXPONENT));
            }
            else
            {
               alignedPosition = position;
               if(this.finalPositionFilterFunction != null)
               {
                  alignedPosition = this.finalPositionFilterFunction(position,propertyName);
               }
               if(alignedPosition == position)
               {
                  return null;
               }
               this.isSnapping = true;
               nowTime = this.addKeyframe(motionPath,nowTime + THROW_SETTLE_TIME,alignedPosition,new Power(0,THROW_CURVE_EXPONENT));
            }
         }
         while(velocity != 0)
         {
            if(position < minPosition && velocity > 0 || position > maxPosition && velocity < 0)
            {
               settlePosition = position < minPosition ? minPosition : maxPosition;
               if(this.finalPositionFilterFunction != null)
               {
                  settlePosition = this.finalPositionFilterFunction(settlePosition,propertyName);
               }
               overshootPosition = Math.round(position - velocity / OVERSHOOT_CURVE_EXPONENT * THROW_OVERSHOOT_TIME);
               nowTime = this.addKeyframe(motionPath,nowTime + THROW_OVERSHOOT_TIME,overshootPosition,new Power(0,OVERSHOOT_CURVE_EXPONENT));
               nowTime = this.addKeyframe(motionPath,nowTime + THROW_SETTLE_TIME,settlePosition,new Sine(0.25));
               velocity = 0;
               position = settlePosition;
            }
            else
            {
               effectTime = throwEffectTime;
               if(position < minPosition || position > maxPosition)
               {
                  minVelocity = (position - (position < minPosition ? minPosition : maxPosition)) / THROW_SETTLE_TIME * THROW_CURVE_EXPONENT;
                  if(Math.abs(velocity) < Math.abs(minVelocity))
                  {
                     velocity = minVelocity;
                     effectTime = THROW_SETTLE_TIME;
                  }
               }
               finalPosition = Math.round(position - velocity / THROW_CURVE_EXPONENT * effectTime);
               if(finalPosition < minPosition || finalPosition > maxPosition)
               {
                  endPosition = finalPosition < minPosition ? minPosition : maxPosition;
                  partialTime = effectTime * (1 - Math.pow(1 - (endPosition - position) / (finalPosition - position),1 / THROW_CURVE_EXPONENT));
                  nowTime = this.addKeyframe(motionPath,nowTime + partialTime,endPosition,new PartialExponentialCurve(THROW_CURVE_EXPONENT,partialTime / effectTime));
                  if(finalPosition < minPosition)
                  {
                     position = minPosition - 1;
                  }
                  if(finalPosition > maxPosition)
                  {
                     position = maxPosition + 1;
                  }
                  x = partialTime / effectTime;
                  y = 3 * Math.pow(x,2) - 6 * x + 3;
                  velocity = -y * (finalPosition - position) / effectTime;
               }
               else
               {
                  if(this.finalPositionFilterFunction != null)
                  {
                     finalPosition = this.finalPositionFilterFunction(finalPosition,propertyName);
                  }
                  CURVE_PORTION = 0.62;
                  nowTime = this.addKeyframe(motionPath,nowTime + effectTime * CURVE_PORTION,finalPosition,new PartialExponentialCurve(THROW_CURVE_EXPONENT,CURVE_PORTION));
                  velocity = 0;
               }
            }
         }
         return motionPath;
      }
   }
}

import spark.effects.easing.EaseInOutBase;

class PartialExponentialCurve extends EaseInOutBase
{
   
   private var _xscale:Number;
   
   private var _ymult:Number;
   
   private var _exponent:Number;
   
   public function PartialExponentialCurve(exponent:Number, xscale:Number)
   {
      super(0);
      this._exponent = exponent;
      this._xscale = xscale;
      this._ymult = 1 / (1 - Math.pow(1 - this._xscale,this._exponent));
   }
   
   override protected function easeOut(fraction:Number) : Number
   {
      return this._ymult * (1 - Math.pow(1 - fraction * this._xscale,this._exponent));
   }
}
