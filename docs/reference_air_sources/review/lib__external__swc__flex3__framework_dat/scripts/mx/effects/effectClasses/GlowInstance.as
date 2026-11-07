package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import mx.core.Application;
   import mx.core.mx_internal;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class GlowInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var strength:Number;
      
      public var inner:Boolean;
      
      public var blurXFrom:Number;
      
      public var blurYFrom:Number;
      
      public var color:uint = 4294967295;
      
      public var alphaFrom:Number;
      
      public var blurYTo:Number;
      
      public var blurXTo:Number;
      
      public var alphaTo:Number;
      
      public var knockout:Boolean;
      
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
         if(isNaN(alphaFrom))
         {
            alphaFrom = 1;
         }
         if(isNaN(alphaTo))
         {
            alphaTo = 0;
         }
         if(isNaN(blurXFrom))
         {
            blurXFrom = 5;
         }
         if(isNaN(blurXTo))
         {
            blurXTo = 0;
         }
         if(isNaN(blurYFrom))
         {
            blurYFrom = 5;
         }
         if(isNaN(blurYTo))
         {
            blurYTo = 0;
         }
         if(color == StyleManager.NOT_A_COLOR)
         {
            color = Application.application.getStyle("themeColor");
         }
         if(isNaN(strength))
         {
            strength = 2;
         }
         tween = createTween(this,[color,alphaFrom,blurXFrom,blurYFrom],[color,alphaTo,blurXTo,blurYTo],duration);
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
            filters.push(new GlowFilter(color,alpha,blurX,blurY,strength,1,inner,knockout));
         }
         target.filters = filters;
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         setGlowFilter(value[0],value[1],value[2],value[3]);
         super.onTweenEnd(value);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         setGlowFilter(value[0],value[1],value[2],value[3]);
      }
   }
}

