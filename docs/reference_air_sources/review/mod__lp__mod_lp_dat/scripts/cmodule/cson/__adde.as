package cmodule.cson
{
   public function __adde(param1:uint, param2:uint) : uint
   {
      var _loc3_:uint = param1 + param2 + cmodule.cson.gstate.cf;
      cmodule.cson.gstate.cf = uint(_loc3_ < param1);
      return _loc3_;
   }
}

