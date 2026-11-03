package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SetStyleActionInstance;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class SetStyleAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      [Inspectable(category="General")]
      public var value:*;
      
      [Inspectable(category="General")]
      public var name:String;
      
      public function SetStyleAction(target:Object = null)
      {
         super(target);
         instanceClass = SetStyleActionInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:SetStyleActionInstance = SetStyleActionInstance(instance);
         actionInstance.name = name;
         actionInstance.value = value;
      }
      
      override public function get relevantStyles() : Array
      {
         return [name];
      }
   }
}

