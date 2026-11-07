package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AnimatePropertyInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var roundValue:Boolean = false;
      
      public var isStyle:Boolean = false;
      
      public var property:String;
      
      public var toValue:Number;
      
      public var fromValue:Number;
      
      public function AnimatePropertyInstance(target:Object)
      {
         super(target);
      }
      
      private function getCurrentValue() : Number
      {
         var currentValue:Number = NaN;
         if(!isStyle)
         {
            currentValue = Number(target[property]);
         }
         else
         {
            currentValue = Number(target.getStyle(property));
         }
         return roundValue ? Math.round(currentValue) : currentValue;
      }
      
      override public function play() : void
      {
         super.play();
         if(isNaN(fromValue))
         {
            fromValue = getCurrentValue();
         }
         if(isNaN(toValue))
         {
            if(Boolean(propertyChanges) && propertyChanges.end[property] !== undefined)
            {
               toValue = propertyChanges.end[property];
            }
            else
            {
               toValue = getCurrentValue();
            }
         }
         tween = createTween(this,fromValue,toValue,duration);
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
         mx_internal::applyTweenStartValues();
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         if(!isStyle)
         {
            target[property] = roundValue ? Math.round(Number(value)) : value;
         }
         else
         {
            target.setStyle(property,value);
         }
      }
   }
}

