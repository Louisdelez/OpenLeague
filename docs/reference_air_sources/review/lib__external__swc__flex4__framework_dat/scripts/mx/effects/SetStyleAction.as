package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SetStyleActionInstance;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class SetStyleAction extends Effect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var value:*;
      
      public function SetStyleAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = SetStyleActionInstance;
      }
      
      override public function get relevantStyles() : Array
      {
         return [this.name];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:SetStyleActionInstance = SetStyleActionInstance(instance);
         actionInstance.name = this.name;
         actionInstance.value = this.value;
      }
   }
}

