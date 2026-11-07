package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class PauseInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function PauseInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         super.play();
         tween = createTween(this,0,0,duration);
      }
   }
}

