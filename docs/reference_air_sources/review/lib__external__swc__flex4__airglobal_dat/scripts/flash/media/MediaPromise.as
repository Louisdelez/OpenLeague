package flash.media
{
   import flash.desktop.*;
   import flash.events.*;
   import flash.filesystem.*;
   import flash.utils.*;
   
   [API("669")]
   [native(cls="MediaPromiseClass",instance="MediaPromiseObject",methods="auto",construct="native")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="close",type="flash.events.Event")]
   public class MediaPromise extends EventDispatcher implements IFilePromise
   {
      
      private var _stream:IDataInput;
      
      public function MediaPromise()
      {
         super();
      }
      
      public function get isAsync() : Boolean
      {
         return true;
      }
      
      public function open() : IDataInput
      {
         var _inputMediaStream:InputMediaStream = null;
         var _fileuri:String = this.getURI();
         if(Boolean(_fileuri))
         {
            this._stream = new FileStream() as IDataInput;
            this.registerEventHandlers();
            (this._stream as FileStream).openAsync(new File(_fileuri),FileMode.READ);
            return this._stream;
         }
         _inputMediaStream = this.getMediaStreamObject();
         if(Boolean(_inputMediaStream))
         {
            this._stream = _inputMediaStream;
            this.registerEventHandlers();
            _inputMediaStream.open();
            return this._stream;
         }
         return null;
      }
      
      public function close() : void
      {
         if(this._stream is InputMediaStream)
         {
            (this._stream as InputMediaStream).close();
         }
         else if(this._stream is FileStream)
         {
            (this._stream as FileStream).close();
         }
      }
      
      public function reportError(e:ErrorEvent) : void
      {
         dispatchEvent(e);
      }
      
      public function get file() : File
      {
         var _fileuri:String = this.getURI();
         if(Boolean(_fileuri))
         {
            return new File(_fileuri);
         }
         return null;
      }
      
      private function registerEventHandlers() : void
      {
         var _iED:IEventDispatcher = null;
         if(Boolean(this._stream))
         {
            _iED = this._stream as IEventDispatcher;
            _iED.addEventListener(Event.COMPLETE,this.reflectURLStreamEvent);
            _iED.addEventListener(ProgressEvent.PROGRESS,this.reflectURLStreamEvent);
            _iED.addEventListener(IOErrorEvent.IO_ERROR,this.reflectURLStreamEvent);
            _iED.addEventListener(Event.CLOSE,this.reflectURLStreamEvent);
         }
      }
      
      private function unregisterEventHandlers() : void
      {
         var _iED:IEventDispatcher = null;
         if(Boolean(this._stream))
         {
            _iED = this._stream as IEventDispatcher;
            _iED.removeEventListener(Event.COMPLETE,this.reflectURLStreamEvent);
            _iED.removeEventListener(ProgressEvent.PROGRESS,this.reflectURLStreamEvent);
            _iED.removeEventListener(IOErrorEvent.IO_ERROR,this.reflectURLStreamEvent);
            _iED.removeEventListener(Event.CLOSE,this.reflectURLStreamEvent);
         }
      }
      
      private function reflectURLStreamEvent(e:Event) : void
      {
         if(!(e is IOErrorEvent))
         {
            dispatchEvent(e);
            if(e.type == Event.CLOSE)
            {
               this.unregisterEventHandlers();
            }
         }
         else
         {
            this.reportError(e as IOErrorEvent);
         }
      }
      
      private native function getURI() : String;
      
      public native function get mediaType() : String;
      
      public native function get relativePath() : String;
      
      private native function getMediaStreamObject() : InputMediaStream;
   }
}

