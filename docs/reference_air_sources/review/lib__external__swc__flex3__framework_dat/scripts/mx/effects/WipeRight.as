package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.WipeRightInstance;
   
   use namespace mx_internal;
   
   public class WipeRight extends MaskEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function WipeRight(target:Object = null)
      {
         super(target);
         instanceClass = WipeRightInstance;
      }
   }
}

