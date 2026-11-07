package cmodule.cson
{
   public function unregFunc(param1:int) : void
   {
      if(param1 + 1 == cmodule.cson.gstate.funcs.length)
      {
         cmodule.cson.gstate.funcs.pop();
      }
   }
}

