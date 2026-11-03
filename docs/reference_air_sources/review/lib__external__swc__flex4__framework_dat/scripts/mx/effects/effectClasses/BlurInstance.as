package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class BlurInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var blurXFrom:Number;
      
      public var blurXTo:Number;
      
      public var blurYFrom:Number;
      
      public var blurYTo:Number;
      
      public function BlurInstance(target:Object)
      {
         super(target);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
      }
      
      override public function play() : void
      {
         super.play();
         tween = createTween(this,[this.blurXFrom,this.blurYFrom],[this.blurXTo,this.blurYTo],duration);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         this.setBlurFilter(value[0],value[1]);
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         this.setBlurFilter(value[0],value[1]);
         super.onTweenEnd(value);
      }
      
      private function setBlurFilter(blurX:Number, blurY:Number) : void
      {
         var filters:Array = target.filters;
         var n:int = int(filters.length);
         for(var i:int = 0; i < n; i++)
         {
            if(filters[i] is BlurFilter)
            {
               filters.splice(i,1);
            }
         }
         if(Boolean(blurX) || Boolean(blurY))
         {
            filters.push(new BlurFilter(blurX,blurY));
         }
         target.filters = filters;
      }
   }
}

