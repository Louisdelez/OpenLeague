package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.ParallelInstance;
   
   use namespace mx_internal;
   
   public class Parallel extends CompositeEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Parallel(target:Object = null)
      {
         super(target);
         instanceClass = ParallelInstance;
      }
   }
}

