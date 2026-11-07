package cmodule.cson
{
   function AS3_RegAbused_jmp_buf(param1:int) : void
   {
      cmodule.cson.log(4,"regAbused: " + param1);
      cmodule.cson.log(1,"Can\'t RegAbused -- abuse support disabled");
   }
}

