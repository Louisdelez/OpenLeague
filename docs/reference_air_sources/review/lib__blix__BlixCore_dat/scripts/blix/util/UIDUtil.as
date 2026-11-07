package blix.util
{
   public class UIDUtil
   {
      
      private static var counter:Number = 0;
      
      public function UIDUtil()
      {
         super();
      }
      
      public static function createUid() : String
      {
         var _loc1_:Date = new Date();
         return _loc1_.time.toString(36) + (Math.random() * uint.MAX_VALUE).toString(36);
      }
      
      public static function getNextId() : Number
      {
         return ++counter;
      }
   }
}

