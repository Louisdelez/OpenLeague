package spark.effects.supportClasses
{
   import mx.filters.IBitmapFilter;
   
   public class AnimateFilterInstance extends AnimateInstance
   {
      
      public var bitmapFilter:IBitmapFilter;
      
      public function AnimateFilterInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         var filters:Array = target.filters;
         filters.push(this.bitmapFilter);
         target.filters = filters;
         super.play();
      }
      
      override public function finishEffect() : void
      {
         var filters:Array = target.filters;
         for(var i:int = 0; i < filters.length; i++)
         {
            if(filters[i] == this.bitmapFilter)
            {
               filters.splice(i,1);
               break;
            }
         }
         target.filters = filters;
         super.finishEffect();
      }
      
      override protected function setValue(property:String, value:Object) : void
      {
         this.bitmapFilter[property] = value;
      }
      
      override protected function getCurrentValue(property:String) : *
      {
         return this.bitmapFilter[property];
      }
      
      override protected function setupStyleMapEntry(property:String) : void
      {
      }
   }
}

