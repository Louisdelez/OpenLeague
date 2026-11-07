package blix.components.shape.fill
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class BitmapFill
   {
      
      public var smooth:Boolean;
      
      public var repeat:Boolean;
      
      public var matrix:Matrix;
      
      public var bitmap:BitmapData;
      
      public function BitmapFill(param1:BitmapData, param2:Matrix = null, param3:Boolean = true, param4:Boolean = false)
      {
         super();
         this.bitmap = param1;
         this.matrix = param2;
         this.repeat = param3;
         this.smooth = param4;
      }
   }
}

