package flash.desktop
{
   import flash.events.*;
   import flash.filesystem.*;
   import flash.utils.*;
   
   internal class MacFilePromiseWrapper extends EventDispatcher
   {
      
      private static const LOGGING:Boolean = false;
      
      private var _file:File;
      
      private var _stream:FileStream;
      
      private var _baseDirectory:File;
      
      private var _promise:IFilePromise;
      
      private var _data:IDataInput;
      
      private var _isOpen:Boolean = false;
      
      private var _timeout:Timer = new Timer(FilePromiseManager.DATA_EVENT_TIMEOUT);
      
      private var _buffer:ByteArray = new ByteArray();
      
      public function MacFilePromiseWrapper(promise:IFilePromise, dropDirectory:File)
      {
         super();
         this._promise = promise;
         this._baseDirectory = dropDirectory;
      }
      
      private static function resolvePath(baseDirectory:File, relativePath:String) : File
      {
         if(relativePath.charAt(0) == "/")
         {
            relativePath = "." + relativePath;
         }
         var file:File = baseDirectory.resolvePath(relativePath);
         if(!file.exists)
         {
            return file;
         }
         var prefix:String = relativePath;
         var extension:String = "";
         var lastDot:int = relativePath.lastIndexOf(".");
         if(lastDot != -1)
         {
            extension = relativePath.substr(lastDot,relativePath.length);
            prefix = relativePath.substr(0,lastDot);
         }
         for(var i:int = 2; true; i++)
         {
            file = baseDirectory.resolvePath(prefix + "(" + i + ")" + extension);
            if(!file.exists)
            {
               return file;
            }
         }
         return null;
      }
      
      private static function log(msg:String) : void
      {
         if(LOGGING)
         {
            trace(msg);
         }
      }
      
      public function open() : Boolean
      {
         try
         {
            this._file = resolvePath(this._baseDirectory,this._promise.relativePath);
            log(" OPEN promise: " + this._promise.relativePath + " [" + this._file.nativePath + "]");
            this._stream = new FileStream();
            this._stream.open(this._file,FileMode.WRITE);
            this._data = this._promise.open();
            if(this._data == null)
            {
               throw FilePromiseManager.newFilePromiseErrorEvent(FilePromiseManager.FILE_PROMISE_ERR_OPEN);
            }
            if(this._promise.isAsync)
            {
               this.registerEventHandlers(IEventDispatcher(this._data));
               this._timeout.addEventListener(TimerEvent.TIMER,this.onTimeout);
               this._timeout.start();
            }
            else
            {
               this.writeAvailableDataToOutputStream();
               this.close();
            }
         }
         catch(e:Error)
         {
            log(e.toString());
            reportError(new IOErrorEvent(e.name,false,false,e.message,e.errorID));
            abort();
            return false;
         }
         catch(e:ErrorEvent)
         {
            log(e.toString());
            reportError(e);
            abort();
            return false;
         }
         this._isOpen = true;
         return true;
      }
      
      private function close() : void
      {
         log(" CLOSE promise: " + this._promise.relativePath);
         try
         {
            this._promise.close();
            if(this._stream != null)
            {
               this._stream.close();
            }
         }
         catch(e:Error)
         {
            log(e.toString());
         }
         if(this._promise.isAsync)
         {
            this._timeout.stop();
            this._timeout.removeEventListener(TimerEvent.TIMER,this.onTimeout);
            this.unregisterEventHandlers(this._data as IEventDispatcher);
            if(this._isOpen)
            {
               dispatchEvent(new Event(FilePromiseManager.ASYNC_FILE_PROMISE_DONE_EVENT));
            }
         }
      }
      
      private function abort() : void
      {
         log("ABORT promise " + this._promise.relativePath + ". Delete " + this._file.nativePath);
         this.close();
         try
         {
            if(this._file.exists)
            {
               this._file.deleteFile();
            }
         }
         catch(e:Error)
         {
            log(e.toString());
         }
      }
      
      private function reportError(e:ErrorEvent) : void
      {
         try
         {
            this._promise.reportError(e);
         }
         catch(e:Error)
         {
            log(e.toString());
         }
      }
      
      private function onDataSourceEvent(e:Event) : void
      {
         if(e.type == Event.CLOSE || e.type == Event.COMPLETE)
         {
            this.close();
         }
      }
      
      private function onDataSourceProgress(e:ProgressEvent) : void
      {
         this._timeout.reset();
         if(e.type == ProgressEvent.PROGRESS || e.type == ProgressEvent.SOCKET_DATA)
         {
            try
            {
               this.writeAvailableDataToOutputStream();
            }
            catch(e:Error)
            {
               log(e.toString());
               abort();
            }
         }
         this._timeout.start();
      }
      
      private function onErrorEvent(e:ErrorEvent) : void
      {
         log(e + " " + this._promise.relativePath);
         this.reportError(e);
         this.abort();
      }
      
      private function onHttpStatus(e:HTTPStatusEvent) : void
      {
         if(e.status >= 400 && e.status < 600)
         {
            log(e + " " + this._promise.relativePath);
            this.abort();
         }
      }
      
      private function onTimeout(e:Event) : void
      {
         log("TIME OUT " + this._promise.relativePath);
         this.reportError(FilePromiseManager.newFilePromiseErrorEvent(FilePromiseManager.FILE_PROMISE_ERR_TIMEOUT) as ErrorEvent);
         this.abort();
      }
      
      private function registerEventHandlers(obj:IEventDispatcher) : void
      {
         if(Boolean(obj))
         {
            obj.addEventListener(Event.OPEN,this.onDataSourceEvent);
            obj.addEventListener(Event.CLOSE,this.onDataSourceEvent);
            obj.addEventListener(Event.COMPLETE,this.onDataSourceEvent);
            obj.addEventListener(ProgressEvent.PROGRESS,this.onDataSourceProgress);
            obj.addEventListener(ProgressEvent.SOCKET_DATA,this.onDataSourceProgress);
            obj.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
            obj.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
            obj.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            obj.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHttpStatus);
         }
      }
      
      private function unregisterEventHandlers(obj:IEventDispatcher) : void
      {
         if(Boolean(obj))
         {
            obj.removeEventListener(Event.OPEN,this.onDataSourceEvent);
            obj.removeEventListener(Event.CLOSE,this.onDataSourceEvent);
            obj.removeEventListener(Event.COMPLETE,this.onDataSourceEvent);
            obj.removeEventListener(ProgressEvent.PROGRESS,this.onDataSourceProgress);
            obj.removeEventListener(ProgressEvent.SOCKET_DATA,this.onDataSourceProgress);
            obj.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorEvent);
            obj.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorEvent);
            obj.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            obj.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHttpStatus);
         }
      }
      
      private function writeAvailableDataToOutputStream() : void
      {
         while(Boolean(this._data.bytesAvailable))
         {
            this._buffer.length = 0;
            this._data.readBytes(this._buffer,0,this._data.bytesAvailable);
            this._stream.writeBytes(this._buffer,0,this._buffer.bytesAvailable);
         }
      }
   }
}

