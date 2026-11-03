package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.RemoveItemActionInstance;
   
   use namespace mx_internal;
   
   [Exclude(name="duration",kind="property")]
   public class RemoveItemAction extends Effect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent"];
      
      public function RemoveItemAction(target:Object = null)
      {
         super(target);
         instanceClass = RemoveItemActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:RemoveItemActionInstance = RemoveItemActionInstance(instance);
      }
   }
}

