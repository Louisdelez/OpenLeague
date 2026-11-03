package spark.effects.animation
{
   import spark.effects.interpolation.MultiValueInterpolator;
   
   public class SimpleMotionPath extends MotionPath
   {
      
      private static var multiValueInterpolator:MultiValueInterpolator = null;
      
      public function SimpleMotionPath(property:String = null, valueFrom:Object = null, valueTo:Object = null, valueBy:Object = null)
      {
         super();
         this.property = property;
         keyframes = new <Keyframe>[new Keyframe(0,valueFrom),new Keyframe(NaN,valueTo,valueBy)];
         if(valueFrom !== null && valueTo !== null && (valueFrom is Array && valueTo is Array || valueFrom is Vector.<Number> && valueTo is Vector.<Number>))
         {
            if(!multiValueInterpolator)
            {
               multiValueInterpolator = new MultiValueInterpolator();
            }
            interpolator = multiValueInterpolator;
         }
      }
      
      public function get valueFrom() : Object
      {
         return keyframes[0].value;
      }
      
      public function set valueFrom(value:Object) : void
      {
         keyframes[0].value = value;
      }
      
      public function get valueTo() : Object
      {
         return keyframes[keyframes.length - 1].value;
      }
      
      public function set valueTo(value:Object) : void
      {
         keyframes[keyframes.length - 1].value = value;
      }
      
      public function get valueBy() : Object
      {
         return keyframes[keyframes.length - 1].valueBy;
      }
      
      public function set valueBy(value:Object) : void
      {
         keyframes[keyframes.length - 1].valueBy = value;
      }
   }
}

