package flash.desktop
{
   import flash.events.*;
   import flash.utils.IDataInput;
   
   [native(cls="FilePromiseWrapperClass",instance="FilePromiseWrapperObject",methods="auto")]
   internal class FilePromiseWrapper
   {
      
      private var _filePromise:IFilePromise;
      
      private var _dataSource:IDataInput;
      
      public function FilePromiseWrapper(fp:IFilePromise)
      {
         super();
         this._filePromise = fp;
         this.nativeInitMethodClosures(this.open,this.close,this.reportError,this.relativePath,this.isAsync);
      }
      
      private native function nativeInitMethodClosures(param1:Function, param2:Function, param3:Function, param4:Function, param5:Function) : void;
      
      private native function nativeOnDataSourceEvent(param1:String) : void;
      
      private native function nativeOnDataSourceProgress(param1:int, param2:int) : void;
      
      private native function nativeOnDataSourceIOError(param1:String, param2:int, param3:Event) : void;
      
      private native function nativeOnDataSourceSecurityError(param1:String, param2:int, param3:Event) : void;
      
      private native function nativeOnHTTPStatus(param1:int, param2:Event) : void;
      
      private function registerEventHandlers(obj:IEventDispatcher) : void
      {
         if(Boolean(obj))
         {
            obj.addEventListener(Event.OPEN,this.onDataSourceEvent);
            obj.addEventListener(Event.CLOSE,this.onDataSourceEvent);
            obj.addEventListener(Event.COMPLETE,this.onDataSourceEvent);
            obj.addEventListener(ProgressEvent.PROGRESS,this.onDataSourceProgress);
            obj.addEventListener(ProgressEvent.SOCKET_DATA,this.onDataSourceProgress);
            obj.addEventListener(IOErrorEvent.IO_ERROR,this.onDataSourceIOError);
            obj.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDataSourceSecurityError);
            obj.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHTTPStatus);
            obj.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHTTPStatus);
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
            obj.removeEventListener(IOErrorEvent.IO_ERROR,this.onDataSourceIOError);
            obj.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDataSourceSecurityError);
            obj.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHTTPStatus);
            obj.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHTTPStatus);
         }
      }
      
      private function onDataSourceEvent(e:Event) : void
      {
         this.nativeOnDataSourceEvent(e.type);
      }
      
      private function onDataSourceProgress(e:ProgressEvent) : void
      {
         this.nativeOnDataSourceProgress(e.bytesLoaded,e.bytesTotal);
      }
      
      private function onDataSourceIOError(e:IOErrorEvent) : void
      {
         this.nativeOnDataSourceIOError(e.text,e.errorID,e);
      }
      
      private function onDataSourceSecurityError(e:SecurityErrorEvent) : void
      {
         this.nativeOnDataSourceSecurityError(e.text,e.errorID,e);
      }
      
      private function onHTTPStatus(e:HTTPStatusEvent) : void
      {
         this.nativeOnHTTPStatus(e.status,e);
      }
      
      private function open() : IDataInput
      {
         this._dataSource = this._filePromise.open();
         if(this._filePromise.isAsync)
         {
            this.registerEventHandlers(IEventDispatcher(this._dataSource));
         }
         return this._dataSource;
      }
      
      private function close() : void
      {
         if(this._filePromise.isAsync)
         {
            this.unregisterEventHandlers(this._dataSource as IEventDispatcher);
         }
         this._filePromise.close();
      }
      
      private function reportError(e:ErrorEvent) : void
      {
         this._filePromise.reportError(e);
      }
      
      private function relativePath() : String
      {
         return this._filePromise.relativePath;
      }
      
      private function isAsync() : Boolean
      {
         return this._filePromise.isAsync;
      }
      
      public function get filePromise() : IFilePromise
      {
         return this._filePromise;
      }
   }
}

