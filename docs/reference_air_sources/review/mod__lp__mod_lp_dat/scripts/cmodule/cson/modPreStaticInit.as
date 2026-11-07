package cmodule.cson
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public function modPreStaticInit() : void
   {
      var _loc1_:int = 0;
      if(cmodule.cson.gpreStaticInits)
      {
         _loc1_ = 0;
         while(_loc1_ < cmodule.cson.gpreStaticInits.length)
         {
            cmodule.cson.gpreStaticInits[_loc1_]();
            _loc1_++;
         }
      }
   }
}

