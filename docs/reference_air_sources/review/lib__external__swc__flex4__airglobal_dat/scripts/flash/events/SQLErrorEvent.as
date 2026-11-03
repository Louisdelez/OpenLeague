package flash.events
{
   import flash.errors.SQLError;
   
   [API("661")]
   public class SQLErrorEvent extends ErrorEvent
   {
      
      public static const ERROR:String = "error";
      
      private var _error:SQLError;
      
      public function SQLErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, error:SQLError = null)
      {
         super(type,bubbles,cancelable,Boolean(error) ? error.message : "",Boolean(error) ? error.errorID : 0);
         this._error = error;
      }
      
      public function get error() : SQLError
      {
         return this._error;
      }
      
      override public function clone() : Event
      {
         return new SQLErrorEvent(type,bubbles,cancelable,this.error);
      }
      
      override public function toString() : String
      {
         return formatToString("SQLErrorEvent","type","bubbles","cancelable","error");
      }
   }
}

