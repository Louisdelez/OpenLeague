package flash.errors
{
   [API("661")]
   public class SQLError extends Error
   {
      
      private var _details:String;
      
      private var _detailID:int;
      
      private var _detailArgs:Array;
      
      private var _operation:String;
      
      public function SQLError(operation:String, details:String = "", message:String = "", id:int = 0, detailID:int = -1, detailArgs:Array = null)
      {
         super(message,id);
         this._details = Boolean(details) ? details : "";
         this._detailID = detailID;
         this._detailArgs = Boolean(detailArgs) ? detailArgs : [];
         this._operation = operation;
      }
      
      public function get details() : String
      {
         return this._details;
      }
      
      public function get detailID() : int
      {
         return this._detailID;
      }
      
      public function get detailArguments() : Array
      {
         return this._detailArgs;
      }
      
      public function get operation() : String
      {
         return this._operation;
      }
      
      public function toString() : String
      {
         var str:String = "SQLError: \'" + message + "\', details:\'" + this._details + "\', operation:\'" + this._operation + "\'";
         if(this._detailID != -1)
         {
            str += ", detailID:\'" + this._detailID.toString() + "\'";
         }
         return str;
      }
   }
}

