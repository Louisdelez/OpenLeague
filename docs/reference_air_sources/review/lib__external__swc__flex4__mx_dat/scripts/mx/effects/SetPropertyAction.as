package mx.effects
{
   import mx.effects.effectClasses.SetPropertyActionInstance;
   
   [Alternative(replacement="spark.effects.SetAction",since="4.0")]
   [Exclude(name="duration",kind="property")]
   public class SetPropertyAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var value:*;
      
      public function SetPropertyAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = SetPropertyActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return [this.name];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:SetPropertyActionInstance = SetPropertyActionInstance(instance);
         actionInstance.name = this.name;
         actionInstance.value = this.value;
      }
   }
}

