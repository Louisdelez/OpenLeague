package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class PauseInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var eventSource:IEventDispatcher;
      
      public var eventName:String;
      
      public function PauseInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         super.play();
         if(Boolean(this.eventName) && target is IEventDispatcher)
         {
            this.eventSource = IEventDispatcher(target);
            this.eventSource.addEventListener(this.eventName,this.eventHandler);
         }
         if(duration >= 0)
         {
            tween = createTween(this,0,0,duration);
         }
      }
      
      private function eventHandler(event:Event) : void
      {
         if(duration >= 0)
         {
            end();
         }
         else
         {
            if(Boolean(this.eventSource))
            {
               this.eventSource.removeEventListener(this.eventName,this.eventHandler);
            }
            finishRepeat();
         }
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         if(Boolean(this.eventSource))
         {
            this.eventSource.removeEventListener(this.eventName,this.eventHandler);
         }
         super.onTweenEnd(value);
      }
   }
}

