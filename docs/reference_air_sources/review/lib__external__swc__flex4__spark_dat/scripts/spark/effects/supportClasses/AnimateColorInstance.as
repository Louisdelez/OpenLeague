package spark.effects.supportClasses
{
   import mx.styles.StyleManager;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.interpolation.RGBInterpolator;
   
   public class AnimateColorInstance extends AnimateInstance
   {
      
      public var colorFrom:uint;
      
      public var colorTo:uint;
      
      public var colorPropertyName:String;
      
      public function AnimateColorInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         if(this.colorFrom == StyleManager.NOT_A_COLOR)
         {
            if(Boolean(propertyChanges) && propertyChanges.start[this.colorPropertyName] !== undefined)
            {
               this.colorFrom = propertyChanges.start[this.colorPropertyName];
            }
            else
            {
               this.colorFrom = getCurrentValue(this.colorPropertyName);
            }
         }
         if(this.colorTo == StyleManager.NOT_A_COLOR)
         {
            if(Boolean(propertyChanges) && propertyChanges.end[this.colorPropertyName] !== undefined)
            {
               this.colorTo = propertyChanges.end[this.colorPropertyName];
            }
            else
            {
               this.colorTo = getCurrentValue(this.colorPropertyName);
            }
         }
         motionPaths = new <MotionPath>[new MotionPath(this.colorPropertyName)];
         motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,this.colorFrom),new Keyframe(duration,this.colorTo)];
         if(!interpolator)
         {
            interpolator = RGBInterpolator.getInstance();
         }
         super.play();
      }
   }
}

