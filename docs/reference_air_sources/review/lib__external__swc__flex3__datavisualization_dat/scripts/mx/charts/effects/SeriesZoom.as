package mx.charts.effects
{
   import mx.charts.effects.effectClasses.SeriesZoomInstance;
   import mx.effects.IEffectInstance;
   
   public class SeriesZoom extends SeriesEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(category="General",enumeration="top,center,bottom")]
      public var verticalFocus:String;
      
      [Inspectable(category="General",enumeration="left,center,right")]
      public var horizontalFocus:String;
      
      [Inspectable(category="General",enumeration="series,chart",defaultValue="series")]
      public var relativeTo:String = "series";
      
      public function SeriesZoom(target:Object = null)
      {
         super(target);
         instanceClass = SeriesZoomInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var seriesZoomInstance:SeriesZoomInstance = SeriesZoomInstance(instance);
         seriesZoomInstance.horizontalFocus = horizontalFocus;
         seriesZoomInstance.verticalFocus = verticalFocus;
         seriesZoomInstance.relativeTo = relativeTo;
      }
   }
}

