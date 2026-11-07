package flash.events
{
   [API("661")]
   public class ScreenMouseEvent extends MouseEvent
   {
      
      public static const CLICK:String = MouseEvent.CLICK;
      
      public static const MOUSE_DOWN:String = MouseEvent.MOUSE_DOWN;
      
      public static const MOUSE_UP:String = MouseEvent.MOUSE_UP;
      
      public static const RIGHT_CLICK:String = MouseEvent.RIGHT_CLICK;
      
      public static const RIGHT_MOUSE_DOWN:String = MouseEvent.RIGHT_MOUSE_DOWN;
      
      public static const RIGHT_MOUSE_UP:String = MouseEvent.RIGHT_MOUSE_UP;
      
      private var m_screenX:Number;
      
      private var m_screenY:Number;
      
      public function ScreenMouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, screenX:Number = undefined, screenY:Number = undefined, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, commandKey:Boolean = false, controlKey:Boolean = false)
      {
         super(type,bubbles,cancelable,0,0,null,ctrlKey,altKey,shiftKey,buttonDown,0,commandKey,controlKey,0);
         this.m_screenX = screenX;
         this.m_screenY = screenY;
      }
      
      override public function clone() : Event
      {
         return new ScreenMouseEvent(type,bubbles,cancelable,this.screenX,this.screenY,ctrlKey,altKey,shiftKey,buttonDown,commandKey,controlKey);
      }
      
      override public function toString() : String
      {
         return formatToString("ScreenMouseEvent","type","bubbles","cancelable","screenX","screenY","ctrlKey","altKey","shiftKey","buttonDown","commandKey","controlKey");
      }
      
      public function get screenX() : Number
      {
         return this.m_screenX;
      }
      
      public function get screenY() : Number
      {
         return this.m_screenY;
      }
   }
}

