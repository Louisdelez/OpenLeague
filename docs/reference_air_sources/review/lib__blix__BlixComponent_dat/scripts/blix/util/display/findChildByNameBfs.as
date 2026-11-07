package blix.util.display
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public function findChildByNameBfs(param1:DisplayObjectContainer, param2:String) : DisplayObject
   {
      var _loc4_:DisplayObjectContainer = null;
      var _loc5_:DisplayObject = null;
      var _loc6_:uint = 0;
      var _loc7_:uint = 0;
      var _loc8_:DisplayObject = null;
      var _loc3_:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
      _loc3_[0] = param1;
      while(_loc3_.length != 0)
      {
         _loc4_ = _loc3_.shift();
         _loc5_ = _loc4_.getChildByName(param2);
         if(_loc5_ != null)
         {
            return _loc5_;
         }
         _loc6_ = uint(_loc4_.numChildren);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc4_.getChildAt(_loc7_);
            if(_loc8_ is DisplayObjectContainer)
            {
               _loc3_[_loc3_.length] = _loc8_ as DisplayObjectContainer;
            }
            _loc7_++;
         }
      }
      return null;
   }
}

