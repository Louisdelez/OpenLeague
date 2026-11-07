package mx.charts.effects.effectClasses
{
   import mx.charts.chartClasses.Series;
   import mx.effects.Tween;
   import mx.effects.effectClasses.TweenEffectInstance;
   
   public class SeriesEffectInstance extends TweenEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _playHeads:Array;
      
      [Inspectable]
      public var minimumElementDuration:Number = 0;
      
      private var _forward:Boolean = true;
      
      private var _elementCount:Number;
      
      [Inspectable]
      public var offset:Number = 0;
      
      protected var interpolationValues:Array;
      
      protected var targetSeries:Series;
      
      private var easingFunctionHolder:Function;
      
      private var _elementDuration:Number;
      
      [Inspectable]
      public var elementOffset:Number = 20;
      
      [Inspectable(environment="none")]
      public var type:String = "show";
      
      public function SeriesEffectInstance(target:Object = null)
      {
         targetSeries = Series(target);
         super(target);
      }
      
      private static function LinearEase(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return b + c * t / d;
      }
      
      private static function sinEase(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return b + c * (1 - Math.cos(Math.PI * t / d)) / 2;
      }
      
      protected function beginTween(elementCount:int) : void
      {
         easingFunctionHolder = findEasingEquation(target,easingFunction);
         _elementCount = elementCount;
         if(elementOffset < 0)
         {
            _forward = false;
            elementOffset *= -1;
         }
         if(elementCount > 0)
         {
            if(!isNaN(duration))
            {
               _elementDuration = duration - Math.abs(elementOffset) * (elementCount - 1);
            }
            if(isNaN(duration) || _elementDuration < minimumElementDuration)
            {
               _elementDuration = minimumElementDuration;
               duration = Math.abs(elementOffset) * (elementCount - 1) + _elementDuration;
            }
            duration += offset;
         }
         elementOffset /= duration;
         _elementDuration /= duration;
         offset /= duration;
         interpolationValues = [];
         _playHeads = [];
         tween = new Tween(this,0,1,duration);
         tween.easingFunction = LinearEase;
      }
      
      private function findEasingEquation(targetObj:Object, easing:Object) : Function
      {
         var easingFunc:Object = null;
         if(easing == null)
         {
            return sinEase;
         }
         if(easing is Function)
         {
            return easing as Function;
         }
         while(targetObj != null)
         {
            easingFunc = targetObj[easing];
            if(easingFunc != null && easingFunc is Function)
            {
               return easingFunc as Function;
            }
            targetObj = targetObj.parent;
         }
         return sinEase;
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         var i:int = 0;
         var playHead:Number = NaN;
         var curVal:Number = Number(value);
         var n:int = _elementCount;
         if(_forward)
         {
            for(i = 0; i < n; i++)
            {
               if(_playHeads[i] != 1)
               {
                  playHead = (curVal - offset - i * elementOffset) / _elementDuration;
                  if(playHead > 1)
                  {
                     interpolationValues[i] = 1;
                  }
                  else if(playHead >= 0)
                  {
                     interpolationValues[i] = easingFunctionHolder(playHead,0,1,1);
                  }
                  else
                  {
                     interpolationValues[i] = 0;
                  }
                  _playHeads[i] = playHead;
               }
            }
         }
         else
         {
            for(i = 0; i < n; i++)
            {
               if(_playHeads[i] != 1)
               {
                  playHead = (curVal - offset - (n - 1 - i) * elementOffset) / _elementDuration;
                  if(playHead > 1)
                  {
                     interpolationValues[i] = 1;
                  }
                  else if(playHead >= 0)
                  {
                     interpolationValues[i] = easingFunctionHolder(playHead,0,1,1);
                  }
                  else
                  {
                     interpolationValues[i] = 0;
                  }
                  _playHeads[i] = playHead;
               }
            }
         }
      }
   }
}

