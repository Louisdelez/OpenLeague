package flash.desktop
{
   import flash.errors.*;
   
   [API("661")]
   [native(cls="InteractiveIconClass",instance="InteractiveIconObject",methods="auto",construct="native")]
   public class InteractiveIcon extends Icon
   {
      
      public function InteractiveIcon()
      {
         super();
      }
      
      override public function get bitmaps() : Array
      {
         Error.throwError(IllegalOperationError,2071);
         return null;
      }
      
      override public function set bitmaps(value:Array) : void
      {
         Error.throwError(IllegalOperationError,2071);
      }
      
      public function get width() : int
      {
         Error.throwError(IllegalOperationError,2071);
         return -1;
      }
      
      public function get height() : int
      {
         Error.throwError(IllegalOperationError,2071);
         return -1;
      }
   }
}

