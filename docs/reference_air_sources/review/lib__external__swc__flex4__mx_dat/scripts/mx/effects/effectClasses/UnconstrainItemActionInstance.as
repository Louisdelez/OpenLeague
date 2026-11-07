package mx.effects.effectClasses
{
   import flash.events.Event;
   import mx.controls.listClasses.ListBase;
   
   public class UnconstrainItemActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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

