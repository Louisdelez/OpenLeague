package cmodule.cson
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public function importSym(param1:String) : int
   {
      var s:String = param1;
      var res:int = int(cmodule.cson.gstate.syms[s]);
      if(!res)
      {
         cmodule.cson.log(3,"Undefined sym: " + s);
         return cmodule.cson.exportSym(s,cmodule.cson.regFunc(function():*
         {
            throw "Undefined sym: " + s;
         }));
      }
      return res;
   }
}

