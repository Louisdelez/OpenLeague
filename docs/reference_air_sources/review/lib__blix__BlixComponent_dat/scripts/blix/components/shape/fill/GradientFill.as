package blix.components.shape.fill
{
   import flash.geom.Matrix;
   
   public class GradientFill
   {
      
      public var type:String;
      
      public var colors:Array;
      
      public var alphas:Array;
      
      public var ratios:Array;
      
      public var matrix:Matrix;
      
      public var spreadMethod:String;
      
      public var interpolationMethod:String;
      
      public var focalPointRatio:Number;
      
      public function GradientFill(param1:String, param2:Array, param3:Array, param4:Array, param5:Matrix = null, param6:String = "pad", param7:String = "rgb", param8:Number = 0)
      {
         super();
         this.type = param1;
         this.colors = param2;
         this.alphas = param3;
         this.ratios = param4;
         this.matrix = param5;
         this.spreadMethod = param6;
         this.interpolationMethod = param7;
         this.focalPointRatio = param8;
      }
   }
}

