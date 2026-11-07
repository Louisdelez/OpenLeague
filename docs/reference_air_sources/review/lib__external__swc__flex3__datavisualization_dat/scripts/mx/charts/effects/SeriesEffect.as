package mx.charts.effects
{
   import mx.charts.effects.effectClasses.SeriesEffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.TweenEffect;
   
   public class SeriesEffect extends TweenEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var type:String = "show";
      
      [Inspectable(category="General",defaultValue="0")]
      public var minimumElementDuration:Number = 0;
      
      [Inspectable(category="General",defaultValue="0")]
      public var offset:Number = 0;
      
      [Inspectable(category="General",defaultValue="20")]
      public var elementOffset:Number = 20;
      
      public function SeriesEffect(target:Object)
      {
         super(target);
         instanceClass = SeriesEffectInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var seriesEffectInstance:SeriesEffectInstance = SeriesEffectInstance(instance);
         seriesEffectInstance.offset = offset;
         seriesEffectInstance.elementOffset = elementOffset;
         seriesEffectInstance.minimumElementDuration = minimumElementDuration;
         seriesEffectInstance.type = type;
      }
   }
}

