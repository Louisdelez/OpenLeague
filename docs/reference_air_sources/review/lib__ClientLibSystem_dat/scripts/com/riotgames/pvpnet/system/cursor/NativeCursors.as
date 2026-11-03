package com.riotgames.pvpnet.system.cursor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.ui.MouseCursorData;
   
   public class NativeCursors
   {
      
      public static const BUSY:String = "busy";
      
      public static const RESIZE_W:String = "resize_w";
      
      public static const RESIZE_NW:String = "resize_nw";
      
      public static const RESIZE_N:String = "resize_n";
      
      public static const RESIZE_NE:String = "resize_ne";
      
      public static const AUTO_PRIORITY:Number = -1000;
      
      public static const BUSY_PRIORITY:Number = 1;
      
      public static const RESIZE_PRIORITY:Number = 2;
      
      private static const RESIZE_W_BMP:Class = NativeCursors_RESIZE_W_BMP;
      
      private static const RESIZE_NW_BMP:Class = NativeCursors_RESIZE_NW_BMP;
      
      private static const RESIZE_N_BMP:Class = NativeCursors_RESIZE_N_BMP;
      
      private static const RESIZE_NE_BMP:Class = NativeCursors_RESIZE_NE_BMP;
      
      public function NativeCursors()
      {
         super();
      }
      
      public static function initialize() : void
      {
         createCursor(NativeCursors.RESIZE_W,RESIZE_W_BMP,new Point(11,11));
         createCursor(NativeCursors.RESIZE_NW,RESIZE_NW_BMP,new Point(11,11));
         createCursor(NativeCursors.RESIZE_N,RESIZE_N_BMP,new Point(11,11));
         createCursor(NativeCursors.RESIZE_NE,RESIZE_NE_BMP,new Point(11,11));
      }
      
      private static function createCursor(param1:String, param2:Class, param3:Point) : void
      {
         var _loc4_:MouseCursorData = new MouseCursorData();
         var _loc5_:Vector.<BitmapData> = new Vector.<BitmapData>();
         _loc5_[0] = Bitmap(new param2()).bitmapData;
         _loc4_.data = _loc5_;
         _loc4_.hotSpot = param3;
         Mouse.registerCursor(param1,_loc4_);
      }
   }
}

