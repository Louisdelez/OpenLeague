package mx.effects.effectClasses
{
   import flash.events.Event;
   
   public class AddItemActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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

