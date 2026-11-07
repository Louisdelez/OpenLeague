package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.AnimateColorInstance;
   
   public class AnimateColor extends Animate
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["color"];
      
      private static var RELEVANT_STYLES:Array = ["color"];
      
      [Inspectable(category="General",format="Color")]
      public var colorFrom:uint = 4294967295;
      
      [Inspectable(category="General",format="Color")]
      public var colorTo:uint = 4294967295;
      
      public var colorPropertyName:String = "color";
      
      public function AnimateColor(target:Object = null)
      {
         super(target);
         instanceClass = AnimateColorInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return this.colorPropertyName == "color" ? AFFECTED_PROPERTIES : [this.colorPropertyName];
      }
      
      override public function get relevantStyles() : Array
      {
         return this.colorPropertyName == "color" ? RELEVANT_STYLES : [this.colorPropertyName];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var animateColorInstance:AnimateColorInstance = AnimateColorInstance(instance);
         animateColorInstance.colorFrom = this.colorFrom;
         animateColorInstance.colorTo = this.colorTo;
         animateColorInstance.colorPropertyName = this.colorPropertyName;
      }
   }
}

