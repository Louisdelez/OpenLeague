package mx.effects
{
   import mx.effects.effectClasses.UnconstrainItemActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class UnconstrainItemAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function UnconstrainItemAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = UnconstrainItemActionInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:UnconstrainItemActionInstance = UnconstrainItemActionInstance(instance);
      }
   }
}

