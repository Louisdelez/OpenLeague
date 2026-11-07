package spark.effects.animation
{
   import spark.effects.interpolation.IInterpolator;
   import spark.effects.interpolation.NumberInterpolator;
   
   [DefaultProperty("keyframes")]
   public class MotionPath
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var property:String;
      
      public var interpolator:IInterpolator = NumberInterpolator.getInstance();
      
      public var keyframes:Vector.<Keyframe>;
      
      public function MotionPath(property:String = null)
      {
         super();
         this.property = property;
      }
      
      public function clone() : MotionPath
      {
         var i:int = 0;
         var mp:MotionPath = new MotionPath(this.property);
         mp.interpolator = this.interpolator;
         if(this.keyframes !== null)
         {
            mp.keyframes = new Vector.<Keyframe>();
            for(i = 0; i < this.keyframes.length; i++)
            {
               mp.keyframes[i] = this.keyframes[i].clone();
            }
         }
         return mp;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function scaleKeyframes(duration:Number) : void
      {
         var i:int = 0;
         var kf:Keyframe = null;
         for(var n:int = int(this.keyframes.length); i < n; )
         {
            kf = this.keyframes[i];
            kf.timeFraction = kf.time / duration;
            i++;
         }
      }
      
      public function getValue(fraction:Number) : Object
      {
         var easedF:Number = NaN;
         var kf:Keyframe = null;
         var t:Number = NaN;
         var easedT:Number = NaN;
         if(!this.keyframes)
         {
            return null;
         }
         var n:int = int(this.keyframes.length);
         if(n == 2 && this.keyframes[1].timeFraction == 1)
         {
            easedF = Boolean(this.keyframes[1].easer) ? this.keyframes[1].easer.ease(fraction) : fraction;
            return this.interpolator.interpolate(easedF,this.keyframes[0].value,this.keyframes[1].value);
         }
         if(isNaN(this.keyframes[0].timeFraction))
         {
            this.scaleKeyframes(this.keyframes[this.keyframes.length - 1].time);
         }
         var prevT:Number = 0;
         var prevValue:Object = this.keyframes[0].value;
         for(var i:int = 1; i < n; i++)
         {
            kf = this.keyframes[i];
            if(fraction >= prevT && fraction < kf.timeFraction)
            {
               t = (fraction - prevT) / (kf.timeFraction - prevT);
               easedT = Boolean(kf.easer) ? kf.easer.ease(t) : t;
               return this.interpolator.interpolate(easedT,prevValue,kf.value);
            }
            prevT = kf.timeFraction;
            prevValue = kf.value;
         }
         return this.keyframes[n - 1].value;
      }
   }
}

