package mx.effects
{
   import mx.effects.effectClasses.RemoveItemActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class RemoveItemAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent"];
      
      public function RemoveItemAction(target:Object = null)
      {
         super(target);
         duration = 0;
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

