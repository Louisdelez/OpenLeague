package mx.graphics
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class BitmapFill implements IFill
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var matrix:Matrix;
      
      [Inspectable(category="General")]
      public var scaleX:Number = 1;
      
      [Inspectable(category="General")]
      public var scaleY:Number = 1;
      
      [Inspectable(category="General")]
      public var originX:Number = 0;
      
      [Inspectable(category="General")]
      public var repeat:Boolean = true;
      
      [Inspectable(category="General")]
      public var offsetX:Number = 0;
      
      [Inspectable(category="General")]
      public var offsetY:Number = 0;
      
      [Inspectable(category="General")]
      public var smooth:Boolean = false;
      
      private var bitmapData:BitmapData;
      
      [Inspectable(category="General")]
      public var originY:Number = 0;
      
      [Inspectable(category="General")]
      public var rotation:Number = 0;
      
      public function BitmapFill()
      {
         super();
      }
      
      private function buildMatrix() : void
      {
         matrix = new Matrix();
         matrix.translate(-originX,-originY);
         matrix.scale(scaleX,scaleY);
         matrix.rotate(rotation);
         matrix.translate(offsetX,offsetY);
      }
      
      [Inspectable(category="General")]
      public function get source() : Object
      {
         return bitmapData;
      }
      
      public function begin(target:Graphics, rc:Rectangle) : void
      {
         buildMatrix();
         if(!bitmapData)
         {
            return;
         }
         target.beginBitmapFill(bitmapData,matrix,repeat,smooth);
      }
      
      public function end(target:Graphics) : void
      {
         target.endFill();
      }
      
      public function set source(value:Object) : void
      {
         var tmpSprite:DisplayObject = null;
         var cls:Class = null;
         var tmpClass:Class = null;
         if(value is BitmapData)
         {
            bitmapData = BitmapData(value);
            return;
         }
         if(value is Class)
         {
            cls = Class(value);
            tmpSprite = new cls();
         }
         else if(value is Bitmap)
         {
            bitmapData = value.bitmapData;
         }
         else if(value is DisplayObject)
         {
            tmpSprite = value as DisplayObject;
         }
         else
         {
            if(!(value is String))
            {
               return;
            }
            tmpClass = Class(getDefinitionByName(String(value)));
            tmpSprite = new tmpClass();
         }
         if(!bitmapData && Boolean(tmpSprite))
         {
            bitmapData = new BitmapData(tmpSprite.width,tmpSprite.height);
            bitmapData.draw(tmpSprite,new Matrix());
         }
      }
   }
}

