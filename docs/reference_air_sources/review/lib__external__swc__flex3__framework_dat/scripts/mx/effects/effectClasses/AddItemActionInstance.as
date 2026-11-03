package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AddItemActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function AddItemActionInstance(target:Object)
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
         effectTargetHost.addDataEffectItem(target);
         finishRepeat();
      }
   }
}

