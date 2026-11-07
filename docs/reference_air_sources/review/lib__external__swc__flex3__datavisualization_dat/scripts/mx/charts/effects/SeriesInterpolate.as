package mx.charts.effects
{
   import mx.charts.effects.effectClasses.SeriesInterpolateInstance;
   
   public class SeriesInterpolate extends SeriesEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public function SeriesInterpolate(target:Object = null)
      {
         super(target);
         instanceClass = SeriesInterpolateInstance;
      }
   }
}

