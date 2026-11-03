package com.riotgames.util.bytearray
{
   import flash.utils.ByteArray;
   
   public function getReverseByteArray(param1:ByteArray) : ByteArray
   {
      var _loc2_:ByteArray = new ByteArray();
      _loc2_.length = param1.length;
      param1.position = 0;
      var _loc3_:int = int(param1.length);
      var _loc4_:int = _loc3_ - 1;
      while(_loc4_ >= 0)
      {
         param1.readBytes(_loc2_,_loc4_,1);
         _loc4_--;
      }
      return _loc2_;
   }
}

