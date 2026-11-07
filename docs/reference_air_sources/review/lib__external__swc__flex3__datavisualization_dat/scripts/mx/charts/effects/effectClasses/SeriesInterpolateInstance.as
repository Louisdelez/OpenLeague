package mx.charts.effects.effectClasses
{
   import mx.events.FlexEvent;
   
   public class SeriesInterpolateInstance extends SeriesEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _destRenderData:Object;
      
      private var _customIData:Object;
      
      private var _len:Number;
      
      private var seriesRenderData:Object;
      
      private var _sourceRenderData:Object;
      
      public function SeriesInterpolateInstance(target:Object)
      {
         super(target);
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         super.onTweenEnd(value);
         if(Boolean(_sourceRenderData) && Boolean(_destRenderData))
         {
            targetSeries.endInterpolation(_customIData);
         }
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         super.onTweenUpdate(value);
         if(Boolean(_sourceRenderData) && Boolean(_destRenderData))
         {
            targetSeries.interpolate(interpolationValues,_customIData);
            targetSeries.invalidateDisplayList();
         }
      }
      
      override public function play() : void
      {
         if(type == FlexEvent.HIDE)
         {
            end();
            return;
         }
         _sourceRenderData = targetSeries.getRenderDataForTransition("hide");
         _destRenderData = targetSeries.getRenderDataForTransition("show");
         _len = Math.max(_sourceRenderData.length,_destRenderData.length);
         if(Boolean(_sourceRenderData) && Boolean(_destRenderData))
         {
            _customIData = targetSeries.beginInterpolation(_sourceRenderData,_destRenderData);
         }
         beginTween(_len);
      }
   }
}

