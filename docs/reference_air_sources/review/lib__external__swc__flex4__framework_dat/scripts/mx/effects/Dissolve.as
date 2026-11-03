package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.DissolveInstance;
   import mx.geom.RoundedRectangle;
   
   use namespace mx_internal;
   
   public class Dissolve extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["visible"];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var alphaTo:Number;
      
      [Inspectable(category="General",format="Color",defaultValue="0xFFFFFFFF")]
      public var color:uint = 4294967295;
      
      [Inspectable(category="General",format="Boolean",defaultValue="false")]
      mx_internal var persistAfterEnd:Boolean = false;
      
      public var targetArea:RoundedRectangle;
      
      public function Dissolve(target:Object = null)
      {
         super(target);
         instanceClass = DissolveInstance;
         relevantProperties = ["visible","alpha"];
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var dissolveInstance:DissolveInstance = null;
         super.initInstance(instance);
         dissolveInstance = DissolveInstance(instance);
         dissolveInstance.alphaFrom = this.alphaFrom;
         dissolveInstance.alphaTo = this.alphaTo;
         dissolveInstance.color = this.color;
         dissolveInstance.persistAfterEnd = this.persistAfterEnd;
         dissolveInstance.targetArea = this.targetArea;
      }
   }
}

