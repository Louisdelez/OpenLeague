package flash.desktop
{
   import flash.display.NativeMenu;
   
   [API("661")]
   [native(cls="DockIconClass",instance="DockIconObject",methods="auto",construct="native")]
   public class DockIcon extends InteractiveIcon
   {
      
      public function DockIcon()
      {
         super();
      }
      
      override public native function set bitmaps(param1:Array) : void;
      
      override public native function get bitmaps() : Array;
      
      override public native function get width() : int;
      
      override public native function get height() : int;
      
      public native function get menu() : NativeMenu;
      
      public native function set menu(param1:NativeMenu) : void;
      
      public native function bounce(param1:String = "informational") : void;
   }
}

