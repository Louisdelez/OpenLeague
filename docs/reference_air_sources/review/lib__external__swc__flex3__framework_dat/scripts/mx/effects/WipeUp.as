package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.WipeUpInstance;
   
   use namespace mx_internal;
   
   public class WipeUp extends MaskEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function WipeUp(target:Object = null)
      {
         super(target);
         instanceClass = WipeUpInstance;
      }
   }
}

