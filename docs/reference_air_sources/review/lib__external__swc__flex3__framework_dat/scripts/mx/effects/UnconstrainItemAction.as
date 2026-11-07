package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.UnconstrainItemActionInstance;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class UnconstrainItemAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function UnconstrainItemAction(target:Object = null)
      {
         super(target);
         instanceClass = UnconstrainItemActionInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:UnconstrainItemActionInstance = UnconstrainItemActionInstance(instance);
      }
   }
}

