package org.papervision3d.core
{
   public class NumberUV
   {
      
      public var u:Number;
      
      public var v:Number;
      
      public function NumberUV(u:Number = 0, v:Number = 0)
      {
         super();
         this.u = u;
         this.v = v;
      }
      
      public static function get ZERO() : NumberUV
      {
         return new NumberUV(0,0);
      }
      
      public function toString() : String
      {
         return "u:" + u + " v:" + v;
      }
      
      public function clone() : NumberUV
      {
         return new NumberUV(this.u,this.v);
      }
   }
}

