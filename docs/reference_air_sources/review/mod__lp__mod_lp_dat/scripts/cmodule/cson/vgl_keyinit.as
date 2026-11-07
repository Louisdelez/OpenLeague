package cmodule.cson
{
   public function vgl_keyinit(param1:int) : int
   {
      trace("vgl_keymode: " + param1);
      cmodule.cson.vglKeyMode = param1;
      return 0;
   }
}

