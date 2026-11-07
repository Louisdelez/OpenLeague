package flash.display
{
   import flash.desktop.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.system.*;
   import flash.utils.*;
   
   [native(cls="LoaderClass",gc="exact",instance="LoaderObject",methods="auto")]
   public class Loader extends DisplayObjectContainer
   {
      
      private static const kStreamError:uint = 2032;
      
      private static const kNullPointerError:uint = 2007;
      
      private var _stream:IDataInput;
      
      private var _iED:IEventDispatcher;
      
      private var _ba:ByteArray;
      
      private var _isPromiseLoading:Boolean;
      
      public function Loader()
      {
         super();
      }
      
      private static function cloneParams(lc:LoaderContext) : void
      {
         var k:String = null;
         var args:Object = lc.parameters;
         var rtn:Object = {};
         for(k in args)
         {
            rtn[k] = args[k];
         }
         lc.parameters = rtn;
      }
      
      public function load(request:URLRequest, context:LoaderContext = null) : void
      {
         var _context:LoaderContext = this._buildLoaderContext(context);
         var deblockingFilter:Number = 0;
         if(_context.imageDecodingPolicy == null)
         {
            throw new ArgumentError();
         }
         deblockingFilter = Number(this._getJPEGLoaderContextdeblockingfilter(_context));
         if(_context.parameters != null)
         {
            cloneParams(_context);
         }
         this._load(request,_context.checkPolicyFile,_context.applicationDomain,_context.securityDomain,_context.requestedContentParent,_context.parameters,deblockingFilter,_context.allowCodeImport,_context.imageDecodingPolicy);
      }
      
      private native function _getJPEGLoaderContextdeblockingfilter(param1:Object) : Number;
      
      private function _buildLoaderContext(context:LoaderContext) : LoaderContext
      {
         if(context == null)
         {
            context = new LoaderContext();
         }
         if(context.applicationDomain == null)
         {
            context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         }
         return context;
      }
      
      public function loadBytes(bytes:ByteArray, context:LoaderContext = null) : void
      {
         var _context:LoaderContext = this._buildLoaderContext(context);
         var deblockingFilter:Number = 0;
         deblockingFilter = Number(this._getJPEGLoaderContextdeblockingfilter(_context));
         if(_context.parameters != null)
         {
            cloneParams(_context);
         }
         this._loadBytes(bytes,_context.checkPolicyFile,_context.applicationDomain,_context.securityDomain,_context.requestedContentParent,_context.parameters,deblockingFilter,_context.allowCodeImport,_context.imageDecodingPolicy);
      }
      
      private native function _loadBytes(param1:ByteArray, param2:Boolean, param3:ApplicationDomain, param4:SecurityDomain, param5:DisplayObjectContainer, param6:Object, param7:Number, param8:Boolean, param9:String) : void;
      
      public function close() : void
      {
         var _promise:IFilePromise = null;
         if(Boolean(this._iED))
         {
            if(!this._isPromiseLoading)
            {
               Error.throwError(IOError,2029);
               return;
            }
            _promise = this._iED as IFilePromise;
            this.unregisterPromiseStreamListeners();
            _promise.close();
         }
         this._isPromiseLoading = false;
         this._close();
      }
      
      public function unload() : void
      {
         var _promise:IFilePromise = null;
         this._isPromiseLoading = false;
         if(Boolean(this._iED))
         {
            _promise = this._iED as IFilePromise;
            this.unregisterPromiseStreamListeners();
            _promise.close();
         }
         this._unload(false,false);
      }
      
      [Version("10")]
      public function unloadAndStop(gc:Boolean = true) : void
      {
         this._unload(true,gc);
      }
      
      private native function _unload(param1:Boolean, param2:Boolean) : void;
      
      private native function _close() : void;
      
      public native function get content() : DisplayObject;
      
      public native function get contentLoaderInfo() : LoaderInfo;
      
      [Inspectable(environment="none")]
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         Error.throwError(IllegalOperationError,2069);
         return null;
      }
      
      [Inspectable(environment="none")]
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         Error.throwError(IllegalOperationError,2069);
         return null;
      }
      
      [Inspectable(environment="none")]
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         Error.throwError(IllegalOperationError,2069);
         return null;
      }
      
      [Inspectable(environment="none")]
      override public function removeChildAt(index:int) : DisplayObject
      {
         Error.throwError(IllegalOperationError,2069);
         return null;
      }
      
      [Inspectable(environment="none")]
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         Error.throwError(IllegalOperationError,2069);
      }
      
      [Version("10.1")]
      public function get uncaughtErrorEvents() : UncaughtErrorEvents
      {
         var _uncaughtErrorEvents:UncaughtErrorEvents = this._getUncaughtErrorEvents();
         if(!_uncaughtErrorEvents)
         {
            _uncaughtErrorEvents = new UncaughtErrorEvents();
            this._setUncaughtErrorEvents(_uncaughtErrorEvents);
         }
         return _uncaughtErrorEvents;
      }
      
      private native function _getUncaughtErrorEvents() : UncaughtErrorEvents;
      
      private native function _setUncaughtErrorEvents(param1:UncaughtErrorEvents) : void;
      
      private native function _load(param1:URLRequest, param2:Boolean, param3:ApplicationDomain, param4:SecurityDomain, param5:DisplayObjectContainer, param6:Object, param7:Number, param8:Boolean, param9:String) : void;
      
      [API("669")]
      public function loadFilePromise(promise:IFilePromise, context:LoaderContext = null) : void
      {
         var _promiseContext:LoaderContext = this._buildLoaderContext(context);
         var deblockingFilter:Number = 0;
         deblockingFilter = Number(this._getJPEGLoaderContextdeblockingfilter(_promiseContext));
         if(promise == null)
         {
            Error.throwError(ArgumentError,kNullPointerError,"promise");
         }
         if(_promiseContext.parameters != null)
         {
            cloneParams(_promiseContext);
         }
         this._loadFilePromiseStart(_promiseContext.checkPolicyFile,_promiseContext.applicationDomain,_promiseContext.securityDomain,_promiseContext.requestedContentParent,_promiseContext.parameters,deblockingFilter,_promiseContext.allowCodeImport);
         this._ba = new ByteArray();
         if(promise.isAsync)
         {
            this._iED = promise as IEventDispatcher;
            this._iED.addEventListener(Event.COMPLETE,this.onPromiseComplete);
            this._iED.addEventListener(ProgressEvent.PROGRESS,this.onPromiseProgress);
            this._iED.addEventListener(ProgressEvent.SOCKET_DATA,this.onPromiseProgress);
            this._iED.addEventListener(Event.CLOSE,this.onPromiseClose);
            this._iED.addEventListener(IOErrorEvent.IO_ERROR,this.onPromiseIOError);
         }
         this._stream = promise.open();
         if(!this._stream)
         {
            this.unregisterPromiseStreamListeners();
            this._dispatchIOErrorEvent(kStreamError);
            return;
         }
         this._isPromiseLoading = true;
         if(!promise.isAsync)
         {
            this.promiseReadBytes();
            if(this._isPromiseLoading)
            {
               this._promiseLoadCompleted();
            }
         }
      }
      
      private function unregisterPromiseStreamListeners() : void
      {
         if(Boolean(this._iED))
         {
            this._iED.removeEventListener(Event.COMPLETE,this.onPromiseComplete);
            this._iED.removeEventListener(ProgressEvent.PROGRESS,this.onPromiseProgress);
            this._iED.removeEventListener(ProgressEvent.SOCKET_DATA,this.onPromiseProgress);
            this._iED.removeEventListener(Event.CLOSE,this.onPromiseClose);
            this._iED.removeEventListener(IOErrorEvent.IO_ERROR,this.onPromiseIOError);
         }
      }
      
      private function onPromiseComplete(e:Event) : void
      {
         this.unregisterPromiseStreamListeners();
         if(this._isPromiseLoading)
         {
            this.promiseReadBytes();
            this._promiseLoadCompleted();
         }
         this._isPromiseLoading = false;
      }
      
      private function promiseReadBytes() : void
      {
         var _bytes:Number = 200000;
         if(!this._stream)
         {
            return;
         }
         while(this._stream.bytesAvailable > _bytes && Boolean(this._isPromiseLoading))
         {
            this._stream.readBytes(this._ba,0,_bytes);
            this._promiseLoadProgress(this._ba);
         }
         if(this._isPromiseLoading)
         {
            this._stream.readBytes(this._ba,0,this._stream.bytesAvailable);
            this._promiseLoadProgress(this._ba);
         }
      }
      
      private function onPromiseProgress(e:Event) : void
      {
         this.promiseReadBytes();
      }
      
      private function onPromiseClose(e:Event) : void
      {
         this.unregisterPromiseStreamListeners();
         this._isPromiseLoading = false;
         this._promiseLoadClose();
      }
      
      private function onPromiseIOError(e:IOErrorEvent) : void
      {
         this.unregisterPromiseStreamListeners();
         this._isPromiseLoading = false;
         this._dispatchIOErrorEvent(e.errorID);
      }
      
      private native function _loadFilePromiseStart(param1:Boolean, param2:ApplicationDomain, param3:SecurityDomain, param4:DisplayObjectContainer, param5:Object, param6:Number, param7:Boolean) : void;
      
      private native function _promiseLoadCompleted() : void;
      
      private native function _promiseLoadClose() : void;
      
      private native function _promiseLoadProgress(param1:ByteArray) : void;
      
      private native function _dispatchIOErrorEvent(param1:int) : void;
   }
}

