package flash.display.shaders
{
   import flash.display.BitmapData;
   import flash.display.Shader;
   import flash.display.ShaderInput;
   import flash.display.ShaderParameter;
   import flash.utils.ByteArray;
   
   public class AbstractBlendMode extends Shader
   {
      
      private var _multiply:ShaderParameter;
      
      private var _src2:ShaderInput;
      
      private var _src1:ShaderInput;
      
      private var _alpha:ShaderParameter;
      
      public function AbstractBlendMode(param1:ByteArray = null)
      {
         super(param1);
         this._src1 = data.src1;
         this._src2 = data.src2;
         this._alpha = data.alpha;
         this._multiply = data.multiply;
      }
      
      public function get multiply() : Number
      {
         return this._multiply.value[0];
      }
      
      public function get alpha() : Number
      {
         return this._alpha.value[0];
      }
      
      public function get version() : String
      {
         return data.version;
      }
      
      public function set multiply(param1:Number) : void
      {
         this._multiply.value[0] = param1;
      }
      
      public function get description() : String
      {
         return data.description;
      }
      
      public function set source1(param1:BitmapData) : void
      {
         this._src1.input = param1;
      }
      
      public function set source2(param1:BitmapData) : void
      {
         this._src2.input = param1;
      }
      
      public function get vendor() : String
      {
         return data.vendor;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha.value[0] = param1;
      }
   }
}

