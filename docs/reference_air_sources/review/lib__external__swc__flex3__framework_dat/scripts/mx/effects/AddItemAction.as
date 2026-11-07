package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.AddItemActionInstance;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class AddItemAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent"];
      
      public function AddItemAction(target:Object = null)
      {
         super(target);
         instanceClass = AddItemActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:AddItemActionInstance = AddItemActionInstance(instance);
      }
   }
}

