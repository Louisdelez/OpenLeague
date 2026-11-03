package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.WipeDownInstance;
   
   use namespace mx_internal;
   
   public class WipeDown extends MaskEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function WipeDown(target:Object = null)
      {
         super(target);
         instanceClass = WipeDownInstance;
      }
   }
}

