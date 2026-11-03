package blix.util.geom
{
   import flash.geom.Rectangle;
   
   public function mergeRect(param1:Rectangle, param2:Rectangle) : Rectangle
   {
      var _loc3_:Number = Math.min(param1.left,param2.left);
      var _loc4_:Number = Math.min(param1.top,param2.top);
      var _loc5_:Number = Math.max(param1.right,param2.right);
      var _loc6_:Number = Math.max(param1.bottom,param2.bottom);
      return new Rectangle(_loc3_,_loc4_,_loc5_ - _loc3_,_loc6_ - _loc4_);
   }
}

