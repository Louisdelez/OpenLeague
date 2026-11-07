package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   
   use namespace mx_internal;
   
   public class ActionEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      protected var playedAction:Boolean = false;
      
      private var _startValue:*;
      
      public function ActionEffectInstance(target:Object)
      {
         super(target);
      }
      
      protected function saveStartValue() : *
      {
      }
      
      protected function getStartValue() : *
      {
         return this._startValue;
      }
      
      override public function play() : void
      {
         super.play();
         if(!playReversed)
         {
            this._startValue = this.saveStartValue();
         }
         this.playedAction = true;
      }
      
      override public function end() : void
      {
         if(!this.playedAction)
         {
            this.play();
         }
         super.end();
      }
   }
}

