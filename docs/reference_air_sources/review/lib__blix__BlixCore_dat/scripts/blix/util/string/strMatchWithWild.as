package blix.util.string
{
   public function strMatchWithWild(param1:String, param2:String) : Boolean
   {
      var _loc5_:String = null;
      if(!param1)
      {
         return !param2;
      }
      var _loc3_:Array = param1.split("*");
      var _loc4_:int = 0;
      for each(_loc5_ in _loc3_)
      {
         _loc4_ = param2.indexOf(_loc5_,_loc4_);
         if(_loc4_ == -1)
         {
            return false;
         }
         _loc4_ += _loc5_.length;
      }
      return param1.charAt(param1.length - 1) == "*" || _loc4_ == param2.length;
   }
}

