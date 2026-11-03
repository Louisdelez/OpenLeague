package cmodule.cson
{
   public function vgl_keych() : int
   {
      if(cmodule.cson.vglKeys.length)
      {
         return cmodule.cson.vglKeys.shift();
      }
      return 0;
   }
}

