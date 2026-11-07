package mx.events
{
   import flash.events.Event;
   
   public class AIREvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const APPLICATION_ACTIVATE:String = "applicationActivate";
      
      public static const APPLICATION_DEACTIVATE:String = "applicationDeactivate";
      
      public static const WINDOW_ACTIVATE:String = "windowActivate";
      
      public static const WINDOW_DEACTIVATE:String = "windowDeactivate";
      
      public static const WINDOW_COMPLETE:String = "windowComplete";
      
      public function AIREvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new AIREvent(type,bubbles,cancelable);
      }
   }
}

