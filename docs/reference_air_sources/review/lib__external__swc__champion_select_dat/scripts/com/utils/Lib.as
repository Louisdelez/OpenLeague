package com.utils
{
   public class Lib
   {
      
      public static var isDebug:Boolean = false;
      
      public function Lib()
      {
         super();
      }
      
      public static function output(... args) : void
      {
         if(isDebug)
         {
            trace(args);
         }
      }
   }
}

