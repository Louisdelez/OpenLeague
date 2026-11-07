package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.DissolveInstance;
   import mx.graphics.RoundedRectangle;
   
   use namespace mx_internal;
   
   public class Dissolve extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["visible"];
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFFFF")]
      public var color:uint = 4294967295;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaTo:Number;
      
      [Inspectable(category="General",format="Boolean",defaultValue="false")]
      mx_internal var persistAfterEnd:Boolean = false;
      
      public var targetArea:RoundedRectangle;
      
      public function Dissolve(target:Object = null)
      {
         super(target);
         instanceClass = DissolveInstance;
         relevantProperties = ["visible","alpha"];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var dissolveInstance:DissolveInstance = null;
         super.initInstance(instance);
         dissolveInstance = DissolveInstance(instance);
         dissolveInstance.alphaFrom = alphaFrom;
         dissolveInstance.alphaTo = alphaTo;
         dissolveInstance.color = color;
         dissolveInstance.mx_internal::persistAfterEnd = mx_internal::persistAfterEnd;
         dissolveInstance.targetArea = targetArea;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}

