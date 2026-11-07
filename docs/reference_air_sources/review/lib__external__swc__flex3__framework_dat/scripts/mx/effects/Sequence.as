package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SequenceInstance;
   
   use namespace mx_internal;
   
   public class Sequence extends CompositeEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Sequence(target:Object = null)
      {
         super(target);
         instanceClass = SequenceInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
      }
   }
}

