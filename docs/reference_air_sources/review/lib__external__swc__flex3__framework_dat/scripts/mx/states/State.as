package mx.states
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   [DefaultProperty("overrides")]
   [Event(name="exitState",type="mx.events.FlexEvent")]
   [Event(name="enterState",type="mx.events.FlexEvent")]
   public class State extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      [Inspectable(category="General")]
      public var basedOn:String;
      
      private var initialized:Boolean = false;
      
      [Inspectable(category="General")]
      [ArrayElementType("mx.states.IOverride")]
      public var overrides:Array = [];
      
      [Inspectable(category="General")]
      public var name:String;
      
      public function State()
      {
         super();
      }
      
      mx_internal function initialize() : void
      {
         var i:int = 0;
         if(!initialized)
         {
            initialized = true;
            for(i = 0; i < overrides.length; i++)
            {
               IOverride(overrides[i]).initialize();
            }
         }
      }
      
      mx_internal function dispatchExitState() : void
      {
         dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
      }
      
      mx_internal function dispatchEnterState() : void
      {
         dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
      }
   }
}

