package blix.util.object
{
   import flash.utils.ByteArray;
   
   public function clone(param1:Object) : *
   {
      var _loc2_:ByteArray = new ByteArray();
      _loc2_.writeObject(param1);
      _loc2_.position = 0;
      return _loc2_.readObject();
   }
}

