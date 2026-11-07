package cmodule.cson
{
   import flash.utils.ByteArray;
   
   function AS3_ByteArray_readBytes(param1:int, param2:ByteArray, param3:int) : int
   {
      if(param3 > 0)
      {
         if(param2.bytesAvailable < param3)
         {
            param3 = int(param2.bytesAvailable);
         }
         param2.readBytes(cmodule.cson.gstate.ds,param1,param3);
         return param3;
      }
      return 0;
   }
}

