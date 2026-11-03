package cmodule.cson
{
   public function regFunc(param1:Function) : int
   {
      return cmodule.cson.gstate.funcs.push(param1) - 1;
   }
}

