package flash.display3D.textures
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   [native(cls="Texture3DClass",instance="Texture3DObject",methods="auto",construct="native")]
   [API("674")]
   public final class Texture extends TextureBase
   {
      
      public function Texture()
      {
         super();
      }
      
      public native function uploadFromBitmapData(param1:BitmapData, param2:uint = 0) : void;
      
      public native function uploadFromByteArray(param1:ByteArray, param2:uint, param3:uint = 0) : void;
      
      public native function uploadCompressedTextureFromByteArray(param1:ByteArray, param2:uint, param3:Boolean = false) : void;
   }
}

