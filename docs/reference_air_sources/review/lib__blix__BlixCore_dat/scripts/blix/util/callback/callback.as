package blix.util.callback
{
   import blix.action.CallAction;
   
   public function callback(param1:Function, param2:Array = null) : Function
   {
      var _loc3_:CallAction = new CallAction(param1,param2);
      return _loc3_.invoke;
   }
}

