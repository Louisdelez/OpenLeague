package blix.layout.vo
{
   import blix.util.layout.MatrixUtils;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class SizeConstraints
   {
      
      public var width:MinMax;
      
      public var height:MinMax;
      
      public function SizeConstraints(param1:MinMax = null, param2:MinMax = null)
      {
         super();
         this.width = param1 || new MinMax(0,10000);
         this.height = param2 || new MinMax(0,10000);
      }
      
      public function reset() : void
      {
         this.width = new MinMax(0,10000);
         this.height = new MinMax(0,10000);
      }
      
      public function transform(param1:Matrix) : SizeConstraints
      {
         var _loc2_:Point = MatrixUtils.getSizeAfterTransformation(this.width.min,this.height.min,param1);
         var _loc3_:Point = MatrixUtils.getSizeAfterTransformation(this.width.max,this.height.max,param1);
         return new SizeConstraints(new MinMax(_loc2_.x,_loc3_.x),new MinMax(_loc2_.y,_loc3_.y));
      }
      
      public function bound(param1:SizeConstraints) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.width.bound(param1.width);
         this.height.bound(param1.height);
      }
      
      public function clone() : SizeConstraints
      {
         return new SizeConstraints(this.width.clone(),this.height.clone());
      }
      
      public function toString() : String
      {
         return "[SizeConstraints width=" + String(this.width) + ", height=" + String(this.height) + "]";
      }
   }
}

