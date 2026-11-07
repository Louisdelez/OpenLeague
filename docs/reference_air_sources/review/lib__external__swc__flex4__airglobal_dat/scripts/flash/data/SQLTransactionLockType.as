package flash.data
{
   [API("661")]
   public class SQLTransactionLockType
   {
      
      public static const DEFERRED:String = "deferred";
      
      public static const EXCLUSIVE:String = "exclusive";
      
      public static const IMMEDIATE:String = "immediate";
      
      public function SQLTransactionLockType()
      {
         super();
      }
   }
}

