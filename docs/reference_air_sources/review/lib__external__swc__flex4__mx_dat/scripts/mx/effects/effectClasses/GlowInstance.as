package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class GlowInstance extends TweenEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var alphaFrom:Number;
      
      public var alphaTo:Number;
      
      public var blurXFrom:Number;
      
      public var blurXTo:Number;
      
      public var blurYFrom:Number;
      
      public var blurYTo:Number;
      
      public var color:uint = 4294967295;
      
      public var inner:Boolean;
      
      public var knockout:Boolean;
      
      public var strength:Number;
      
      public function GlowInstance(target:Object)
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
         tween = createTween(this,[this.color,this.alphaFrom,this.blurXFrom,this.blurYFrom],[this.color,this.alphaTo,this.blurXTo,this.blurYTo],duration);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         this.setGlowFilter(value[0],value[1],value[2],value[3]);
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         this.setGlowFilter(value[0],value[1],value[2],value[3]);
         super.onTweenEnd(value);
      }
      
      private function setGlowFilter(color:uint, alpha:Number, blurX:Number, blurY:Number) : void
      {
         var filters:Array = target.filters;
         var n:int = int(filters.length);
         for(var i:int = 0; i < n; i++)
         {
            if(filters[i] is GlowFilter)
            {
               filters.splice(i,1);
            }
         }
         if(Boolean(blurX) || Boolean(blurY) || Boolean(alpha))
         {
            filters.push(new GlowFilter(color,alpha,blurX,blurY,this.strength,1,this.inner,this.knockout));
         }
         target.filters = filters;
      }
   }
}

