package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.controls.listClasses.ListBase;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class UnconstrainItemActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var effectHost:ListBase = null;
      
      public function UnconstrainItemActionInstance(target:Object)
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
         effectTargetHost.unconstrainRenderer(target);
         finishRepeat();
      }
   }
}

