package cmodule.cson
{
   public function log(param1:int, param2:String) : void
   {
      if(param1 < cmodule.cson.glogLvl)
      {
         trace(param2);
      }
   }
}

