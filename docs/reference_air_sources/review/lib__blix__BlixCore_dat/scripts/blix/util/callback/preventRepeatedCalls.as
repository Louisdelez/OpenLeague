package blix.util.callback
{
   import flash.utils.setTimeout;
   
   public function preventRepeatedCalls(param1:Function, param2:Array = null, param3:int = 0) : Boolean
   {
      if(!(param1 in funcCooldownDict))
      {
         funcCooldownDict[param1] = true;
         setTimeout(timeoutHandler,param3,param1);
         return false;
      }
      return true;
   }
}

import flash.utils.Dictionary;

function timeoutHandler(param1:Function):void
{
   delete funcCooldownDict[param1];
}
const funcCooldownDict:Dictionary = new Dictionary();

