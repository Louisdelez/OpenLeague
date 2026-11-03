package mx.effects
{
   import mx.effects.effectClasses.WipeDownInstance;
   
   [Alternative(replacement="spark.effects.Wipe",since="4.0")]
   public class WipeDown extends MaskEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function WipeDown(target:Object = null)
      {
         super(target);
         instanceClass = WipeDownInstance;
      }
   }
}

