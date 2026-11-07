package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.PauseInstance;
   
   use namespace mx_internal;
   
   public class Pause extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Pause(target:Object = null)
      {
         super(target);
         instanceClass = PauseInstance;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         var newInstance:IEffectInstance = createInstance();
         return Boolean(newInstance) ? [newInstance] : [];
      }
   }
}

