package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.PauseInstance;
   
   use namespace mx_internal;
   
   public class Pause extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var eventName:String;
      
      public function Pause(target:Object = null)
      {
         if(!target)
         {
            target = new Object();
         }
         super(target);
         instanceClass = PauseInstance;
      }
      
      override public function get duration() : Number
      {
         return super.duration;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var pauseInstance:PauseInstance = PauseInstance(instance);
         pauseInstance.eventName = this.eventName;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         var newInstance:IEffectInstance = createInstance();
         return Boolean(newInstance) ? [newInstance] : [];
      }
   }
}

