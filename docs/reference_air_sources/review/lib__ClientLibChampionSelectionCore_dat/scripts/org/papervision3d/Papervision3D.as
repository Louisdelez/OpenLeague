package org.papervision3d
{
   public class Papervision3D
   {
      
      public static var useDEGREES:Boolean = true;
      
      public static var usePERCENT:Boolean = false;
      
      public static var NAME:String = "Papervision3D";
      
      public static var VERSION:String = "Beta 1.9 - PHUNKY";
      
      public static var DATE:String = "20.09.07";
      
      public static var AUTHOR:String = "(c) 2006-2007 Copyright by Carlos Ulloa | papervision3d.org | carlos@papervision3d.org";
      
      public static var VERBOSE:Boolean = true;
      
      public function Papervision3D()
      {
         super();
      }
      
      public static function log(message:String) : void
      {
         if(Papervision3D.VERBOSE)
         {
            trace(message);
         }
      }
   }
}

