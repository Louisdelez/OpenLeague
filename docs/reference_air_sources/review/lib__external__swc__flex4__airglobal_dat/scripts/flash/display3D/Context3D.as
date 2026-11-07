package flash.display3D
{
   import flash.display.BitmapData;
   import flash.display3D.textures.*;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   [native(cls="Context3DClass",instance="Context3DObject",methods="auto",construct="native")]
   [API("674")]
   public final class Context3D extends EventDispatcher
   {
      
      public function Context3D()
      {
         super();
      }
      
      public native function get driverInfo() : String;
      
      public native function dispose() : void;
      
      public native function get enableErrorChecking() : Boolean;
      
      public native function set enableErrorChecking(param1:Boolean) : void;
      
      public native function configureBackBuffer(param1:int, param2:int, param3:int, param4:Boolean = true) : void;
      
      public native function clear(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1, param5:Number = 1, param6:uint = 0, param7:uint = 4294967295) : void;
      
      public native function drawTriangles(param1:IndexBuffer3D, param2:int = 0, param3:int = -1) : void;
      
      public native function present() : void;
      
      public native function setProgram(param1:Program3D) : void;
      
      public native function setProgramConstantsFromVector(param1:String, param2:int, param3:Vector.<Number>, param4:int = -1) : void;
      
      public native function setProgramConstantsFromMatrix(param1:String, param2:int, param3:Matrix3D, param4:Boolean = false) : void;
      
      [API("676")]
      public native function setProgramConstantsFromByteArray(param1:String, param2:int, param3:int, param4:ByteArray, param5:uint) : void;
      
      public native function setVertexBufferAt(param1:int, param2:VertexBuffer3D, param3:int = 0, param4:String = "float4") : void;
      
      public native function setBlendFactors(param1:String, param2:String) : void;
      
      public native function setColorMask(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : void;
      
      public native function setDepthTest(param1:Boolean, param2:String) : void;
      
      public function setTextureAt(sampler:int, texture:TextureBase) : void
      {
         if(texture == null)
         {
            this.setTextureInternal(sampler,null);
         }
         else if(texture is Texture)
         {
            this.setTextureInternal(sampler,texture as Texture);
         }
         else if(texture is CubeTexture)
         {
            this.setCubeTextureInternal(sampler,texture as CubeTexture);
         }
      }
      
      public function setRenderToTexture(texture:TextureBase, enableDepthAndStencil:Boolean = false, antiAlias:int = 0, surfaceSelector:int = 0) : void
      {
         var targetType:uint = 0;
         if(texture == null)
         {
            throw new ArgumentError("setRenderToTexture requires texture object.");
         }
         if(texture is Texture)
         {
            if(surfaceSelector != 0)
            {
               throw new ArgumentError("2D Textures need to have surfaceSelector=0");
            }
            targetType = 1;
         }
         else
         {
            if(!(texture is CubeTexture))
            {
               throw new ArgumentError("color argument not a recognized TextureBase (can be Texture or CubeTexture)");
            }
            if(surfaceSelector > 5)
            {
               throw new ArgumentError("Cube Textures need to have surfaceSelector [0..5]");
            }
            targetType = 2;
         }
         this.setRenderToTextureInternal(texture,targetType,enableDepthAndStencil,antiAlias,surfaceSelector);
      }
      
      public function setRenderToBackBuffer() : void
      {
         this.setRenderToTextureInternal(null,0,false,0,0);
      }
      
      private native function setRenderToTextureInternal(param1:TextureBase, param2:int, param3:Boolean, param4:int, param5:int) : void;
      
      public native function setCulling(param1:String) : void;
      
      public native function setStencilActions(param1:String = "frontAndBack", param2:String = "always", param3:String = "keep", param4:String = "keep", param5:String = "keep") : void;
      
      public native function setStencilReferenceValue(param1:uint, param2:uint = 255, param3:uint = 255) : void;
      
      public native function setScissorRectangle(param1:Rectangle) : void;
      
      public native function createVertexBuffer(param1:int, param2:int) : VertexBuffer3D;
      
      public native function createIndexBuffer(param1:int) : IndexBuffer3D;
      
      public native function createTexture(param1:int, param2:int, param3:String, param4:Boolean) : Texture;
      
      public native function createCubeTexture(param1:int, param2:String, param3:Boolean) : CubeTexture;
      
      public native function createProgram() : Program3D;
      
      public native function drawToBitmapData(param1:BitmapData) : void;
      
      private native function setTextureInternal(param1:int, param2:Texture) : void;
      
      private native function setCubeTextureInternal(param1:int, param2:CubeTexture) : void;
   }
}

