package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.AnimatePropertyInstance;
   
   use namespace mx_internal;
   
   public class AnimateProperty extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      [Inspectable(category="General",defaultValue="0")]
      public var toValue:Number;
      
      [Inspectable(category="General",defaultValue="false")]
      public var isStyle:Boolean = false;
      
      [Inspectable(category="General",defaultValue="")]
      public var property:String;
      
      [Inspectable(category="General",defaultValue="false")]
      public var roundValue:Boolean = false;
      
      [Inspectable(category="General",defaultValue="0")]
      public var fromValue:Number;
      
      public function AnimateProperty(target:Object = null)
      {
         super(target);
         instanceClass = AnimatePropertyInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return [this.property];
      }
      
      override public function get relevantStyles() : Array
      {
         return this.isStyle ? [this.property] : [];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var animatePropertyInstance:AnimatePropertyInstance = null;
         super.initInstance(instance);
         animatePropertyInstance = AnimatePropertyInstance(instance);
         animatePropertyInstance.fromValue = this.fromValue;
         animatePropertyInstance.toValue = this.toValue;
         animatePropertyInstance.property = this.property;
         animatePropertyInstance.isStyle = this.isStyle;
         animatePropertyInstance.roundValue = this.roundValue;
      }
   }
}

