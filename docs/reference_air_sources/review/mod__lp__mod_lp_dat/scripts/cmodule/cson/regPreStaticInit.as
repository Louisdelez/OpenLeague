package cmodule.cson
{
   public function regPreStaticInit(param1:Function) : void
   {
      if(!cmodule.cson.gpreStaticInits)
      {
         cmodule.cson.gpreStaticInits = [];
      }
      cmodule.cson.gpreStaticInits.push(param1);
   }
}

