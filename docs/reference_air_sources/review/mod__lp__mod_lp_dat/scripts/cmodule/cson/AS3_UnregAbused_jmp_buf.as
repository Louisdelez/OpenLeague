package cmodule.cson
{
   function AS3_UnregAbused_jmp_buf(param1:int) : void
   {
      cmodule.cson.log(4,"unregAbused: " + param1);
      cmodule.cson.log(1,"Can\'t UnregAbused -- abuse support disabled");
   }
}

