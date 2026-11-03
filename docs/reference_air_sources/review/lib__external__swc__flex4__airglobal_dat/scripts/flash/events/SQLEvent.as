package flash.events
{
   [API("661")]
   public class SQLEvent extends Event
   {
      
      public static const ANALYZE:String = "analyze";
      
      public static const ATTACH:String = "attach";
      
      public static const BEGIN:String = "begin";
      
      public static const CANCEL:String = "cancel";
      
      public static const COMPACT:String = "compact";
      
      public static const CLOSE:String = "close";
      
      public static const COMMIT:String = "commit";
      
      public static const DEANALYZE:String = "deanalyze";
      
      public static const DETACH:String = "detach";
      
      public static const OPEN:String = "open";
      
      public static const REENCRYPT:String = "reencrypt";
      
      public static const ROLLBACK:String = "rollback";
      
      public static const RESULT:String = "result";
      
      public static const RELEASE_SAVEPOINT:String = "releaseSavepoint";
      
      public static const ROLLBACK_TO_SAVEPOINT:String = "rollbackToSavepoint";
      
      public static const SCHEMA:String = "schema";
      
      public static const SET_SAVEPOINT:String = "setSavepoint";
      
      public function SQLEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new SQLEvent(type,bubbles,cancelable);
      }
   }
}

