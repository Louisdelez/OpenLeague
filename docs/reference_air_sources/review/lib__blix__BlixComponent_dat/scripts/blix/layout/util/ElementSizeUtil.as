package blix.layout.util
{
   import blix.layout.LayoutEntry;
   import blix.layout.data.ISizeLayoutData;
   import blix.layout.vo.ElementSize;
   import blix.layout.vo.Size;
   import blix.layout.vo.SizeConstraints;
   
   public class ElementSizeUtil
   {
      
      public function ElementSizeUtil()
      {
         super();
      }
      
      public static function getElementSize(param1:LayoutEntry, param2:Number, param3:Number) : ElementSize
      {
         var _loc4_:Size = null;
         var _loc5_:Size = null;
         var _loc6_:ISizeLayoutData = param1.data as ISizeLayoutData;
         if(Boolean(_loc6_))
         {
            _loc4_ = _loc6_.getWidthInfo(param2);
            _loc5_ = _loc6_.getHeightInfo(param3);
         }
         else
         {
            _loc4_ = new Size();
            _loc5_ = new Size();
         }
         var _loc7_:SizeConstraints = param1.element.setAvailableSize(param2,param3);
         if(Boolean(_loc7_))
         {
            _loc4_.bound(_loc7_.width);
            _loc5_.bound(_loc7_.height);
         }
         return new ElementSize(_loc4_,_loc5_);
      }
   }
}

