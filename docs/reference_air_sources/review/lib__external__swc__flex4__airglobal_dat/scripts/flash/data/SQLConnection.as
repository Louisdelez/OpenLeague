package flash.data
{
   import flash.errors.*;
   import flash.events.*;
   import flash.net.Responder;
   import flash.system.*;
   import flash.utils.ByteArray;
   
   [API("661")]
   [native(cls="SQLConnectionClass",instance="SQLConnectionObject",methods="auto")]
   [Event(name="update",type="flash.events.SQLUpdateEvent")]
   [Event(name="setSavepoint",type="flash.events.SQLEvent")]
   [Event(name="schema",type="flash.events.SQLEvent")]
   [Event(name="rollbackToSavepoint",type="flash.events.SQLEvent")]
   [Event(name="rollback",type="flash.events.SQLEvent")]
   [Event(name="releaseSavepoint",type="flash.events.SQLEvent")]
   [Event(name="reencrypt",type="flash.events.SQLEvent")]
   [Event(name="open",type="flash.events.SQLEvent")]
   [Event(name="insert",type="flash.events.SQLUpdateEvent")]
   [Event(name="error",type="flash.events.SQLErrorEvent")]
   [Event(name="detach",type="flash.events.SQLEvent")]
   [Event(name="delete",type="flash.events.SQLUpdateEvent")]
   [Event(name="deanalyze",type="flash.events.SQLEvent")]
   [Event(name="commit",type="flash.events.SQLEvent")]
   [Event(name="close",type="flash.events.SQLEvent")]
   [Event(name="compact",type="flash.events.SQLEvent")]
   [Event(name="cancel",type="flash.events.SQLEvent")]
   [Event(name="begin",type="flash.events.SQLEvent")]
   [Event(name="attach",type="flash.events.SQLEvent")]
   [Event(name="analyze",type="flash.events.SQLEvent")]
   public class SQLConnection extends EventDispatcher
   {
      
      private static const SAVEPOINT_PREFIX:String = "$air_sp$";
      
      private var _allowCommitRollback:Boolean = false;
      
      private var _savepoints:Array;
      
      public function SQLConnection()
      {
         super();
         if(Security.sandboxType != Security.APPLICATION)
         {
            Error.throwError(SecurityError,3205);
         }
      }
      
      public native function get autoCompact() : Boolean;
      
      public native function get connected() : Boolean;
      
      public native function get cacheSize() : uint;
      
      public function set cacheSize(value:uint) : void
      {
         this.checkConnected();
         this.checkNotInTransaction();
         this.internalSetCacheSize(value);
      }
      
      public function get columnNameStyle() : String
      {
         if(this.connected)
         {
            return this.internalGetColumnNameStyle();
         }
         return SQLColumnNameStyle.DEFAULT;
      }
      
      public function set columnNameStyle(value:String) : void
      {
         this.checkConnected();
         this.internalSetColumnNameStyle(value);
      }
      
      public native function get inTransaction() : Boolean;
      
      public function get lastInsertRowID() : Number
      {
         if(this.connected)
         {
            return this.internalGetLastInsertRowID();
         }
         return 0;
      }
      
      public native function get pageSize() : uint;
      
      public native function get totalChanges() : Number;
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         if(type == SQLUpdateEvent.UPDATE && hasEventListener(SQLUpdateEvent.UPDATE) || type == SQLUpdateEvent.INSERT && hasEventListener(SQLUpdateEvent.INSERT) || type == SQLUpdateEvent.DELETE && hasEventListener(SQLUpdateEvent.DELETE))
         {
            this.registerUpdateNotification();
         }
      }
      
      public function analyze(resourceName:String = null, responder:Responder = null) : void
      {
         this.checkConnected();
         this.internalAnalyze(resourceName,responder);
      }
      
      public function attach(name:String, reference:Object = null, responder:Responder = null, encryptionKey:ByteArray = null) : void
      {
         if(name == null || name.length == 0)
         {
            Error.throwError(ArgumentError,3102);
         }
         this.checkConnected();
         this.checkNotInTransaction();
         this.checkKey(encryptionKey,reference);
         this.internalAttach(name,reference,responder,encryptionKey);
      }
      
      public function begin(option:String = null, responder:Responder = null) : void
      {
         var sql:String = null;
         this.checkConnected();
         if(!this.inTransaction)
         {
            if(option == SQLTransactionLockType.DEFERRED || option == SQLTransactionLockType.EXCLUSIVE || option == SQLTransactionLockType.IMMEDIATE || option == null)
            {
               sql = "begin " + (Boolean(option) ? option : "") + ";";
               this.internalBegin(sql,responder);
            }
            else
            {
               Error.throwError(ArgumentError,3112);
            }
         }
         this._allowCommitRollback = true;
      }
      
      public function cancel(responder:Responder = null) : void
      {
         this.checkConnected();
         this.internalCancel(responder);
      }
      
      public function commit(responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkTransactionActive();
         this._allowCommitRollback = false;
         this.internalCommit(responder);
      }
      
      public function compact(responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkNotInTransaction();
         this.internalClean(responder);
      }
      
      public function close(responder:Responder = null) : void
      {
         this._allowCommitRollback = false;
         this.internalClose(responder);
      }
      
      public function deanalyze(responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkNotInTransaction();
         this.internalDeanalyze(responder);
      }
      
      public function detach(name:String, responder:Responder = null) : void
      {
         if(name == null || name.length == 0)
         {
            Error.throwError(ArgumentError,3102);
         }
         this.checkConnected();
         this.checkNotInTransaction();
         this.internalDetach(name,responder);
      }
      
      public native function getSchemaResult() : SQLSchemaResult;
      
      public function loadSchema(type:Class = null, name:String = null, database:String = "main", includeColumnSchema:Boolean = true, responder:Responder = null) : void
      {
         this.checkConnected();
         var schemaType:String = null;
         if(type == SQLIndexSchema)
         {
            schemaType = "index";
         }
         else if(type == SQLTableSchema)
         {
            schemaType = "table";
         }
         else if(type == SQLTriggerSchema)
         {
            schemaType = "trigger";
         }
         else if(type == SQLViewSchema)
         {
            schemaType = "view";
         }
         else if(type != null)
         {
            Error.throwError(ArgumentError,3111);
         }
         this.internalLoadSchema(schemaType,name,database,includeColumnSchema,responder);
      }
      
      public function open(reference:Object = null, openMode:String = "create", autoCompact:Boolean = false, pageSize:int = 1024, encryptionKey:ByteArray = null) : void
      {
         if(this.connected)
         {
            Error.throwError(IllegalOperationError,3101);
         }
         this.checkKey(encryptionKey,reference);
         this.internalOpen(reference,openMode,autoCompact,pageSize,encryptionKey);
      }
      
      public function openAsync(reference:Object = null, openMode:String = "create", responder:Responder = null, autoCompact:Boolean = false, pageSize:int = 1024, encryptionKey:ByteArray = null) : void
      {
         if(this.connected)
         {
            Error.throwError(IllegalOperationError,3101);
         }
         this.checkKey(encryptionKey,reference);
         this.internalOpenAsync(reference,openMode,responder,autoCompact,pageSize,encryptionKey);
      }
      
      [API("663")]
      public function reencrypt(newEncryptionKey:ByteArray, responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkNotInTransaction();
         this.checkKey(newEncryptionKey,{});
         if(newEncryptionKey == null)
         {
            Error.throwError(ArgumentError,2007,"newEncryptionKey");
         }
         this.internalRekey(newEncryptionKey,responder);
      }
      
      [Version("air2.0")]
      public function releaseSavepoint(name:String = null, responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkTransactionActive();
         var sql:String = "release savepoint " + this.getSavepointName(name,false) + ";";
         this.internalReleaseSavepoint(sql,responder);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(type == SQLUpdateEvent.UPDATE && hasEventListener(SQLUpdateEvent.UPDATE) || type == SQLUpdateEvent.INSERT && hasEventListener(SQLUpdateEvent.INSERT) || type == SQLUpdateEvent.DELETE && hasEventListener(SQLUpdateEvent.DELETE))
         {
            this.unregisterUpdateNotification();
         }
         super.removeEventListener(type,listener,useCapture);
      }
      
      public function rollback(responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkTransactionActive();
         this._allowCommitRollback = false;
         this.internalRollback(responder);
      }
      
      [Version("air2.0")]
      public function rollbackToSavepoint(name:String = null, responder:Responder = null) : void
      {
         this.checkConnected();
         this.checkTransactionActive();
         var sql:String = "rollback to " + this.getSavepointName(name,false) + ";";
         this.internalRollbackSavepoint(sql,responder);
      }
      
      [Version("air2.0")]
      public function setSavepoint(name:String = null, responder:Responder = null) : void
      {
         this.checkConnected();
         var sql:String = "savepoint " + this.getSavepointName(name) + ";";
         this.internalSetSavepoint(sql,responder);
         this._allowCommitRollback = true;
      }
      
      private function checkConnected() : void
      {
         if(!this.connected)
         {
            Error.throwError(IllegalOperationError,3104);
         }
      }
      
      private function checkKey(key:ByteArray, reference:Object) : void
      {
         if(Boolean(key) && key.length != 16)
         {
            Error.throwError(ArgumentError,3140);
         }
         if(Boolean(key) && reference == null)
         {
            Error.throwError(ArgumentError,3141);
         }
      }
      
      private function checkNotInTransaction() : void
      {
         if(this.inTransaction)
         {
            Error.throwError(IllegalOperationError,3103);
         }
      }
      
      private function checkTransactionActive() : void
      {
         if(!this._allowCommitRollback && !this.inTransaction)
         {
            Error.throwError(IllegalOperationError,3105);
         }
      }
      
      private function getSavepointName(value:String, create:Boolean = true) : String
      {
         if(value == null)
         {
            if(this._savepoints == null)
            {
               this._savepoints = [];
            }
            if(create)
            {
               value = SAVEPOINT_PREFIX + this._savepoints.length.toString();
               this._savepoints.push(value);
            }
            else if(this._savepoints.length == 0)
            {
               value = "";
            }
            else
            {
               value = this._savepoints.pop();
            }
         }
         else if(value.length == 0)
         {
            Error.throwError(ArgumentError,3141);
         }
         return "\"" + value + "\"";
      }
      
      private native function internalAnalyze(param1:String, param2:Responder) : void;
      
      private native function internalAttach(param1:String, param2:Object, param3:Responder, param4:ByteArray) : void;
      
      private native function internalBegin(param1:String, param2:Responder) : void;
      
      private native function internalCancel(param1:Responder) : void;
      
      private native function internalClean(param1:Responder) : void;
      
      private native function internalClose(param1:Responder) : void;
      
      private native function internalCommit(param1:Responder) : void;
      
      private native function internalDeanalyze(param1:Responder) : void;
      
      private native function internalDetach(param1:String, param2:Responder) : void;
      
      private native function internalSetSavepoint(param1:String, param2:Responder) : void;
      
      private native function internalReleaseSavepoint(param1:String, param2:Responder) : void;
      
      private native function internalRollbackSavepoint(param1:String, param2:Responder) : void;
      
      private native function internalGetColumnNameStyle() : String;
      
      private native function internalGetLastInsertRowID() : Number;
      
      private native function internalLoadSchema(param1:String, param2:String, param3:String, param4:Boolean, param5:Responder) : void;
      
      private native function internalOpen(param1:Object, param2:String, param3:Boolean, param4:int, param5:ByteArray) : void;
      
      private native function internalOpenAsync(param1:Object, param2:String, param3:Responder, param4:Boolean, param5:int, param6:ByteArray) : void;
      
      private native function internalRekey(param1:ByteArray, param2:Responder) : void;
      
      private native function internalRollback(param1:Responder) : void;
      
      private native function internalSetCacheSize(param1:uint) : void;
      
      private native function internalSetColumnNameStyle(param1:String) : void;
      
      private native function registerUpdateNotification() : void;
      
      private native function unregisterUpdateNotification() : void;
   }
}

