package spark.effects.animation
{
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Linear;
   
   public class Keyframe
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var linearEaser:IEaser = new Linear();
      
      public var value:Object;
      
      [Inspectable(minValue="0.0")]
      public var time:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var timeFraction:Number;
      
      public var easer:IEaser = linearEaser;
      
      public var valueBy:Object;
      
      public function Keyframe(time:Number = NaN, value:Object = null, valueBy:Object = null)
      {
         super();
         this.value = value;
         this.time = time;
         this.valueBy = valueBy;
      }
      
      public function clone() : Keyframe
      {
         var kf:Keyframe = new Keyframe(this.time,this.value,this.valueBy);
         kf.easer = this.easer;
         kf.timeFraction = this.timeFraction;
         return kf;
      }
   }
}

