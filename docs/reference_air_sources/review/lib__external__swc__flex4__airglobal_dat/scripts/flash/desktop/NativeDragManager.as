package flash.desktop
{
   import flash.display.BitmapData;
   import flash.display.InteractiveObject;
   import flash.geom.Point;
   
   [API("661")]
   [native(cls="DragManagerClass",methods="auto",construct="none")]
   public class NativeDragManager
   {
      
      public function NativeDragManager()
      {
         super();
      }
      
      public static native function get dropAction() : String;
      
      public static native function set dropAction(param1:String) : void;
      
      public static native function acceptDragDrop(param1:InteractiveObject) : void;
      
      public static native function get isDragging() : Boolean;
      
      public static native function get dragInitiator() : InteractiveObject;
      
      public static native function doDrag(param1:InteractiveObject, param2:Clipboard, param3:BitmapData = null, param4:Point = null, param5:NativeDragOptions = null) : void;
      
      [Version("air2.0")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
   }
}

