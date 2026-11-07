package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SequenceInstance;
   
   use namespace mx_internal;
   
   public class Sequence extends CompositeEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function Sequence(target:Object = null)
      {
         super(target);
         instanceClass = SequenceInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
      }
      
      override public function get compositeDuration() : Number
      {
         var childDuration:Number = NaN;
         var child:Effect = null;
         var sequenceDuration:Number = 0;
         for(var i:int = 0; i < children.length; i++)
         {
            child = Effect(children[i]);
            if(child is CompositeEffect)
            {
               childDuration = CompositeEffect(child).compositeDuration;
            }
            else
            {
               childDuration = child.duration;
            }
            childDuration = childDuration * child.repeatCount + child.repeatDelay * (child.repeatCount - 1) + child.startDelay;
            sequenceDuration += childDuration;
         }
         return sequenceDuration;
      }
   }
}

