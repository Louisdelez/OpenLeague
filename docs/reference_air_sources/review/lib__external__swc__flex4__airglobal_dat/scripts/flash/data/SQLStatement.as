package flash.data
{
   import flash.errors.*;
   import flash.events.EventDispatcher;
   import flash.net.Responder;
   import flash.system.*;
   
   [API("661")]
   [native(cls="SQLStatementClass",instance="SQLStatementObject",methods="auto")]
   [Event(name="error",type="flash.events.SQLErrorEvent")]
   [Event(name="result",type="flash.events.SQLEvent")]
   public class SQLStatement extends EventDispatcher
   {
      
      private var _sql:String = "";
      
      private var _params:Object = {};
      
      private var _finalize:Boolean = false;
      
      public function SQLStatement()
      {
         super();
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,3205);
         }
      }
      
      public function get executing() : Boolean
      {
         return this.isExecuting();
      }
      
      public native function get sqlConnection() : SQLConnection;
      
      public native function set sqlConnection(param1:SQLConnection) : void;
      
      public native function get itemClass() : Class;
      
      public native function set itemClass(param1:Class) : void;
      
      public function get parameters() : Object
      {
         return this._params;
      }
      
      public function get text() : String
      {
         return this._sql;
      }
      
      public function set text(value:String) : void
      {
         if(this._sql != value)
         {
            if(this.executing)
            {
               Error.throwError(IllegalOperationError,3106);
            }
            this._finalize = this.prepared;
            this._sql = value.replace(/[\r]/g,"\n");
         }
      }
      
      public function cancel() : void
      {
         if(this.executing)
         {
            this.internalCancel();
         }
      }
      
      public function clearParameters() : void
      {
         this._params = {};
      }
      
      public function execute(prefetch:int = -1, responder:Responder = null) : void
      {
         this.checkReady();
         if(this._finalize)
         {
            this.checkComplete();
         }
         this.internalExecute(this._sql,this._params,this._finalize,prefetch,responder);
         this._finalize = false;
      }
      
      public native function getResult() : SQLResult;
      
      public function next(prefetch:int = -1, responder:Responder = null) : void
      {
         if(!this.executing)
         {
            Error.throwError(IllegalOperationError,3107,"SQLStatement.next");
         }
         this.internalNext(prefetch,responder);
      }
      
      private function checkAllowed() : void
      {
         if(this._sql == null || this._sql.length == 0)
         {
            Error.throwError(IllegalOperationError,3108);
         }
         if(this.sqlConnection == null)
         {
            Error.throwError(IllegalOperationError,3109);
         }
         if(!this.sqlConnection.connected)
         {
            Error.throwError(IllegalOperationError,3104);
         }
      }
      
      private function checkComplete() : void
      {
         if(!this.isSQLComplete(this._sql))
         {
            this._sql += ";";
         }
      }
      
      private function checkReady() : void
      {
         if(this.executing)
         {
            Error.throwError(IllegalOperationError,3110);
         }
         this.checkAllowed();
      }
      
      private native function get prepared() : Boolean;
      
      private native function internalCancel() : void;
      
      private native function internalExecute(param1:String, param2:Object, param3:Boolean, param4:int, param5:Responder) : void;
      
      private native function internalNext(param1:int, param2:Responder) : void;
      
      private native function isSQLComplete(param1:String) : Boolean;
      
      private native function isExecuting() : Boolean;
   }
}

