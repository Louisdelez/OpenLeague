package cmodule.cson
{
   public function vgl_unlock() : void
   {
      if(Boolean(cmodule.cson.gvglbmd) && Boolean(cmodule.cson.gvglpixels))
      {
         cmodule.cson.gstate.ds.position = cmodule.cson.gvglpixels;
         cmodule.cson.gvglbmd.setPixels(cmodule.cson.gvglbmd.rect,cmodule.cson.gstate.ds);
      }
   }
}

