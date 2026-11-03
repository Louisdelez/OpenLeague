package blix.action.sql
{
   import blix.signals.Signal;
   import flash.data.SQLConnection;
   import flash.events.SQLEvent;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class SQLConnectionHelper
   {
      
      private static const CLOSE_DELAY:Number = 2000;
      
      public var reference:Object;
      
      public var openMode:String;
      
      public var autoCompact:Boolean;
      
      public var pageSize:int;
      
      public var encryptionKey:ByteArray;
      
      private var activeConnections:int = 0;
      
      private var _connection:SQLConnection = new SQLConnection();
      
      private var _isOpeningChanged:Signal = new Signal();
      
      private var _isOpening:Boolean;
      
      private var _isOpenChanged:Signal = new Signal();
      
      private var _isOpen:Boolean = false;
      
      private var _isClosingChanged:Signal = new Signal();
      
      private var _isClosing:Boolean = false;
      
      private var _isClosedChanged:Signal = new Signal();
      
      private var _isClosed:Boolean = true;
      
      private var _hasErredChanged:Signal = new Signal();
      
      private var _hasErred:Boolean = false;
      
      public function SQLConnectionHelper(param1:Object = null, param2:String = "create", param3:Boolean = false, param4:int = 1024, param5:ByteArray = null)
      {
         super();
         this.reference = param1;
         this.openMode = param2;
         this.autoCompact = param3;
         this.pageSize = param4;
         this.encryptionKey = param5;
      }
      
      public function getConnection() : SQLConnection
      {
         return this._connection;
      }
      
      public function open(param1:Function, param2:Function = null) : void
      {
         var successHandler:Function = param1;
         var failHandler:Function = param2;
         if(this.activeConnections == 0)
         {
            this.setIsOpening(true);
            this.setHasErred(false);
            this._connection.openAsync(this.reference,this.openMode,null,this.autoCompact,this.pageSize,this.encryptionKey);
            this._connection.addEventListener(SQLEvent.OPEN,this.sqlOpenedHandler);
            this._connection.addEventListener(SQLEvent.CLOSE,this.sqlClosedHandler);
         }
         if(this._isOpen)
         {
            successHandler();
         }
         else
         {
            this._connection.addEventListener(SQLEvent.OPEN,function(param1:SQLEvent):void
            {
               successHandler();
            });
         }
         ++this.activeConnections;
      }
      
      private function sqlOpenedHandler(param1:SQLEvent) : void
      {
         this.setIsOpen(true);
         this.setIsOpening(false);
      }
      
      private function sqlClosedHandler(param1:SQLEvent) : void
      {
         this.setIsClosing(false);
         this.setIsClosed(true);
         this.setIsOpen(false);
         this.setIsOpening(false);
      }
      
      public function close() : void
      {
         --this.activeConnections;
         if(this.activeConnections == 0)
         {
            setTimeout(this.doClose,CLOSE_DELAY);
            return;
         }
      }
      
      private function doClose() : void
      {
         if(this._isOpen && !this._isClosing && this.activeConnections == 0)
         {
            this.setIsClosing(true);
            this.setIsOpen(false);
            this._connection.close();
         }
      }
      
      public function getIsOpening() : Boolean
      {
         return this._isOpening;
      }
      
      protected function setIsOpening(param1:Boolean) : void
      {
         if(this._isOpening == param1)
         {
            return;
         }
         this._isOpening = param1;
         this._isOpeningChanged.dispatch();
      }
      
      public function getIsOpen() : Boolean
      {
         return this._isOpen;
      }
      
      protected function setIsOpen(param1:Boolean) : void
      {
         if(this._isOpen == param1)
         {
            return;
         }
         this._isOpen = param1;
         this._isOpenChanged.dispatch();
      }
      
      public function getIsClosing() : Boolean
      {
         return this._isClosing;
      }
      
      protected function setIsClosing(param1:Boolean) : void
      {
         if(this._isClosing == param1)
         {
            return;
         }
         this._isClosing = param1;
         this._isClosingChanged.dispatch();
      }
      
      public function getIsClosed() : Boolean
      {
         return this._isClosed;
      }
      
      protected function setIsClosed(param1:Boolean) : void
      {
         if(this._isClosed == param1)
         {
            return;
         }
         this._isClosed = param1;
         this._isClosedChanged.dispatch();
      }
      
      public function getHasErred() : Boolean
      {
         return this._hasErred;
      }
      
      protected function setHasErred(param1:Boolean) : void
      {
         if(this._hasErred == param1)
         {
            return;
         }
         this._hasErred = param1;
         this._hasErredChanged.dispatch();
      }
   }
}

