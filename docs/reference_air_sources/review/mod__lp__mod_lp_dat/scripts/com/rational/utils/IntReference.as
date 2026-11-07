package com.rational.utils
{
   import flash.Boot;
   
   public class IntReference
   {
      
      public var referent:int;
      
      public function IntReference(param1:int = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         referent = param1;
      }
   }
}

