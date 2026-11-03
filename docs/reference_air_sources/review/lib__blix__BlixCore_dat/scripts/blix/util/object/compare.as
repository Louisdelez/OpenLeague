package blix.util.object
{
   import flash.utils.ByteArray;
   
   public function compare(param1:Object, param2:Object) : Boolean
   {
      if(param1 == null && param2 == null)
      {
         return true;
      }
      if(param1 == null || param2 == null)
      {
         return false;
      }
      var _loc3_:ByteArray = new ByteArray();
      _loc3_.writeObject(param1);
      _loc3_.position = 0;
      var _loc4_:ByteArray = new ByteArray();
      _loc4_.writeObject(param2);
      _loc4_.position = 0;
      if(_loc3_.bytesAvailable != _loc4_.bytesAvailable)
      {
         return false;
      }
      return _loc3_.readUTFBytes(_loc3_.bytesAvailable) == _loc4_.readUTFBytes(_loc4_.bytesAvailable);
   }
}

