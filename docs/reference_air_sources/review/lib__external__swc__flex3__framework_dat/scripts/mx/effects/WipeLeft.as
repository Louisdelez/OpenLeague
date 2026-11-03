package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.WipeLeftInstance;
   
   use namespace mx_internal;
   
   public class WipeLeft extends MaskEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function WipeLeft(target:Object = null)
      {
         super(target);
         instanceClass = WipeLeftInstance;
      }
   }
}

