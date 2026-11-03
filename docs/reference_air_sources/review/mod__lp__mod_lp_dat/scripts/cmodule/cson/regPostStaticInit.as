package cmodule.cson
{
   public function regPostStaticInit(param1:Function) : void
   {
      if(!cmodule.cson.gpostStaticInits)
      {
         cmodule.cson.gpostStaticInits = [];
      }
      cmodule.cson.gpostStaticInits.push(param1);
   }
}

