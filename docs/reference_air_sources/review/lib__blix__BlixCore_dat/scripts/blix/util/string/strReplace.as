package blix.util.string
{
   public function strReplace(param1:String, param2:String, param3:String) : String
   {
      var _loc4_:Array = param1.split(param2);
      return _loc4_.join(param3);
   }
}

