package mx.effects
{
   import mx.effects.effectClasses.WipeRightInstance;
   
   [Alternative(replacement="spark.effects.Wipe",since="4.0")]
   public class WipeRight extends MaskEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function WipeRight(target:Object = null)
      {
         super(target);
         instanceClass = WipeRightInstance;
      }
   }
}

