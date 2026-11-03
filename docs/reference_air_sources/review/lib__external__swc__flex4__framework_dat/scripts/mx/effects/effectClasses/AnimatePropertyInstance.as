package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AnimatePropertyInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var toValue:Number;
      
      public var isStyle:Boolean = false;
      
      public var property:String;
      
      public var roundValue:Boolean = false;
      
      public var fromValue:Number;
      
      public function AnimatePropertyInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         super.play();
         if(isNaN(this.fromValue))
         {
            this.fromValue = this.getCurrentValue();
         }
         if(isNaN(this.toValue))
         {
            if(Boolean(propertyChanges) && propertyChanges.end[this.property] !== undefined)
            {
               this.toValue = propertyChanges.end[this.property];
            }
            else
            {
               this.toValue = this.getCurrentValue();
            }
         }
         tween = createTween(this,this.fromValue,this.toValue,duration);
         if(easingFunction != null)
         {
            tween.easingFunction = easingFunction;
         }
         applyTweenStartValues();
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         if(!this.isStyle)
         {
            target[this.property] = this.roundValue ? Math.round(Number(value)) : value;
         }
         else
         {
            target.setStyle(this.property,value);
         }
      }
      
      private function getCurrentValue() : Number
      {
         var currentValue:Number = NaN;
         if(!this.isStyle)
         {
            currentValue = Number(target[this.property]);
         }
         else
         {
            currentValue = Number(target.getStyle(this.property));
         }
         return this.roundValue ? Math.round(currentValue) : currentValue;
      }
   }
}

