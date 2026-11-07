package blix.components.shape.fill
{
   import flash.display.Shader;
   import flash.geom.Matrix;
   
   public class ShaderFill
   {
      
      public var shader:Shader;
      
      public var matrix:Matrix;
      
      public function ShaderFill(param1:Shader, param2:Matrix = null)
      {
         super();
         this.shader = param1;
         this.matrix = param2;
      }
   }
}

