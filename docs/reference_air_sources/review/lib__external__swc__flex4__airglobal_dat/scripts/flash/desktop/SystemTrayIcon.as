package flash.desktop
{
   import flash.display.NativeMenu;
   
   [API("661")]
   [native(cls="SystemTrayIconClass",instance="SystemTrayIconObject",methods="auto",construct="native")]
   [Event(name="rightClick",type="flash.events.ScreenMouseEvent")]
   [Event(name="rightMouseUp",type="flash.events.ScreenMouseEvent")]
   [Event(name="rightMouseDown",type="flash.events.ScreenMouseEvent")]
   [Event(name="click",type="flash.events.ScreenMouseEvent")]
   [Event(name="mouseUp",type="flash.events.ScreenMouseEvent")]
   [Event(name="mouseDown",type="flash.events.ScreenMouseEvent")]
   public class SystemTrayIcon extends InteractiveIcon
   {
      
      public static const MAX_TIP_LENGTH:Number = 63;
      
      public function SystemTrayIcon()
      {
         super();
      }
      
      override public native function set bitmaps(param1:Array) : void;
      
      override public native function get bitmaps() : Array;
      
      override public native function get width() : int;
      
      override public native function get height() : int;
      
      public native function get tooltip() : String;
      
      public native function set tooltip(param1:String) : void;
      
      public native function get menu() : NativeMenu;
      
      public native function set menu(param1:NativeMenu) : void;
   }
}

