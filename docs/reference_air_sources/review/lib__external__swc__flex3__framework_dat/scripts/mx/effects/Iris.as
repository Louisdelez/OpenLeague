package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.IrisInstance;
   
   use namespace mx_internal;
   
   public class Iris extends MaskEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Iris(target:Object = null)
      {
         super(target);
         instanceClass = IrisInstance;
      }
   }
}

