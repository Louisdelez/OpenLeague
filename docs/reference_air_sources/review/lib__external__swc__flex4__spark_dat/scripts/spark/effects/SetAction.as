package spark.effects
{
   import mx.effects.Effect;
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.SetActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class SetAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      [Inspectable(category="General")]
      public var property:String;
      
      [Inspectable(category="General")]
      public var value:*;
      
      public function SetAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = SetActionInstance;
      }
      
      override public function get relevantStyles() : Array
      {
         return [this.property];
      }
      
      override public function getAffectedProperties() : Array
      {
         return [this.property];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:SetActionInstance = SetActionInstance(instance);
         actionInstance.property = this.property;
         actionInstance.value = this.value;
      }
   }
}

