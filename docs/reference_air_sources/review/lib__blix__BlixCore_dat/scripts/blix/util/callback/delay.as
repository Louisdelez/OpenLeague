package blix.util.callback
{
   public function delay(param1:Function, param2:Array = null, param3:int = 0, param4:Boolean = true, param5:Boolean = false) : Function
   {
      if(!param4 && !param5)
      {
         throw new ArgumentError("callBeforeDelay and callAfterDelay should not both be false.");
      }
      var _loc6_:FunctionLimiter = new FunctionLimiter();
      _loc6_.func = param1;
      _loc6_.args = param2;
      _loc6_.delay = param3;
      _loc6_.callBeforeDelay = param4;
      _loc6_.callAfterDelay = param5;
      return _loc6_.call;
   }
}

