package blix.util.string
{
   public function padNumber(param1:Number, param2:uint = 1, param3:uint = 0) : String
   {
      var _loc4_:String = param1.toString();
      var _loc5_:Array = _loc4_.split(".");
      var _loc6_:String = _loc5_[0];
      var _loc7_:int = param2 - _loc6_.length;
      while(_loc7_ > 0)
      {
         _loc6_ = "0" + _loc6_;
         _loc7_--;
      }
      var _loc8_:String = _loc5_.length > 1 ? _loc5_[1] : "";
      var _loc9_:int = param3 - _loc8_.length;
      while(_loc9_ > 0)
      {
         _loc8_ += "0";
         _loc9_--;
      }
      if(_loc8_.length > 0)
      {
         return _loc6_ + "." + _loc8_;
      }
      return _loc6_;
   }
}

