package mx.effects
{
   import mx.effects.effectClasses.AddItemActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class AddItemAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent"];
      
      public function AddItemAction(target:Object = null)
      {
         super(target);
         duration = 0;
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

