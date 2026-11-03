package cmodule.cson
{
   public function establishEnv() : void
   {
      var ns:Namespace = null;
      try
      {
         ns = new Namespace("avmplus");
         cmodule.cson.gdomainClass = ns::["Domain"];
         cmodule.cson.gshell = true;
      }
      catch(e:*)
      {
      }
      if(!cmodule.cson.gdomainClass)
      {
         ns = new Namespace("flash.system");
         cmodule.cson.gdomainClass = ns::["ApplicationDomain"];
      }
   }
}

