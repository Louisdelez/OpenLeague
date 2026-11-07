package spark.effects
{
   import mx.effects.IEffectInstance;
   import mx.filters.IBitmapFilter;
   import spark.effects.supportClasses.AnimateFilterInstance;
   
   public class AnimateFilter extends Animate
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var bitmapFilter:IBitmapFilter;
      
      public function AnimateFilter(target:Object = null, filter:IBitmapFilter = null)
      {
         super(target);
         instanceClass = AnimateFilterInstance;
         this.bitmapFilter = filter;
      }
      
      override public function getAffectedProperties() : Array
      {
         return [];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var animateInstance:AnimateFilterInstance = instance as AnimateFilterInstance;
         animateInstance.bitmapFilter = this.bitmapFilter;
      }
   }
}

