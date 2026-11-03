package flash.desktop
{
   [API("661")]
   [native(cls="WindowIconClass",instance="WindowIconObject",methods="auto")]
   public class NativeWindowIcon extends InteractiveIcon
   {
      
      public function NativeWindowIcon()
      {
         super();
      }
      
      override public native function set bitmaps(param1:Array) : void;
      
      override public native function get bitmaps() : Array;
      
      override public native function get width() : int;
      
      override public native function get height() : int;
   }
}

