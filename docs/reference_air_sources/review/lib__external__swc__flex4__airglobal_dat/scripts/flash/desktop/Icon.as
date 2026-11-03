package flash.desktop
{
   import flash.events.*;
   
   [API("661")]
   [native(cls="IconClass",instance="IconObject",methods="auto")]
   public class Icon extends EventDispatcher
   {
      
      private var _bitmaps:Array;
      
      public function Icon()
      {
         super();
      }
      
      public function get bitmaps() : Array
      {
         return this._bitmaps;
      }
      
      public function set bitmaps(ba:Array) : void
      {
         this._bitmaps = ba;
      }
   }
}

