package mx.charts.effects
{
   import mx.charts.effects.effectClasses.SeriesSlideInstance;
   import mx.effects.IEffectInstance;
   
   public class SeriesSlide extends SeriesEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(category="General",enumeration="left,right,up,down",defaultValue="left")]
      public var direction:String = "left";
      
      public function SeriesSlide(target:Object = null)
      {
         super(target);
         instanceClass = SeriesSlideInstance;
      }
      
      override protected function initInstance(inst:IEffectInstance) : void
      {
         super.initInstance(inst);
         SeriesSlideInstance(inst).direction = direction;
      }
   }
}

