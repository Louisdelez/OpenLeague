package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.FadeInstance;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.effects.Fade",since="4.0")]
   public class Fade extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["alpha","visible"];
      
      [Inspectable(category="General",defaultValue="undefined")]
      public var alphaFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaTo:Number;
      
      public function Fade(target:Object = null)
      {
         super(target);
         instanceClass = FadeInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var fadeInstance:FadeInstance = FadeInstance(instance);
         fadeInstance.alphaFrom = this.alphaFrom;
         fadeInstance.alphaTo = this.alphaTo;
      }
   }
}

