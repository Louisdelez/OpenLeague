package mx.events
{
   import flash.events.Event;
   import mx.core.IWindow;
   
   [ExcludeClass]
   public class WindowExistenceEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const WINDOW_CREATE:String = "globalNotifyWindowCreate";
      
      public static const WINDOW_CREATING:String = "globalNotifyWindowCreating";
      
      public static const WINDOW_CLOSE:String = "globalNotifyWindowClose";
      
      public var window:IWindow;
      
      public function WindowExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, window:IWindow = null)
      {
         super(type,bubbles,cancelable);
         this.window = window;
      }
      
      override public function clone() : Event
      {
         return new WindowExistenceEvent(type,bubbles,cancelable,this.window);
      }
   }
}

