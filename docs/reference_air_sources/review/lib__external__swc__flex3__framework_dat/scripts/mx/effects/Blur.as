package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.BlurInstance;
   
   use namespace mx_internal;
   
   public class Blur extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["filters"];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurXTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurXFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurYFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var blurYTo:Number;
      
      public function Blur(target:Object = null)
      {
         super(target);
         instanceClass = BlurInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var blurInstance:BlurInstance = null;
         super.initInstance(instance);
         blurInstance = BlurInstance(instance);
         blurInstance.blurXFrom = blurXFrom;
         blurInstance.blurXTo = blurXTo;
         blurInstance.blurYFrom = blurYFrom;
         blurInstance.blurYTo = blurYTo;
      }
   }
}

