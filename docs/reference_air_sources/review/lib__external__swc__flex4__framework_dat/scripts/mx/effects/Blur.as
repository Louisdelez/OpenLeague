package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.BlurInstance;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.effects.AnimateFilter",since="4.0")]
   public class Blur extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["filters"];
      
      [Inspectable(category="General",defaultValue="4")]
      public var blurXFrom:Number = 4;
      
      [Inspectable(category="General",defaultValue="0")]
      public var blurXTo:Number = 0;
      
      [Inspectable(category="General",defaultValue="4")]
      public var blurYFrom:Number = 4;
      
      [Inspectable(category="General",defaultValue="0")]
      public var blurYTo:Number = 0;
      
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
         super.initInstance(instance);
         var blurInstance:BlurInstance = BlurInstance(instance);
         blurInstance.blurXFrom = this.blurXFrom;
         blurInstance.blurXTo = this.blurXTo;
         blurInstance.blurYFrom = this.blurYFrom;
         blurInstance.blurYTo = this.blurYTo;
      }
   }
}

