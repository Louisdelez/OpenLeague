package flash.desktop
{
   import flash.events.*;
   import flash.filesystem.*;
   import flash.utils.*;
   
   [native(cls="FilePromiseManagerClass",instance="FilePromiseManagerObject",methods="auto")]
   internal class FilePromiseManager extends EventDispatcher
   {
      
      public static const DATA_EVENT_TIMEOUT:int = 30 * 60 * 1000;
      
      private static const MAX_ACTIVE_ASYNC_PROMISES:int = 2;
      
      internal static const ASYNC_FILE_PROMISE_DONE_EVENT:String = "asyncFilePromiseDone";
      
      public static const FILE_PROMISE_ERR_OPEN:int = 1;
      
      public static const FILE_PROMISE_ERR_CLOSE:int = 2;
      
      public static const FILE_PROMISE_ERR_TIMEOUT:int = 3;
      
      private var _asyncPromises:Vector.<MacFilePromiseWrapper> = new Vector.<MacFilePromiseWrapper>();
      
      private var _syncPromises:Vector.<MacFilePromiseWrapper> = new Vector.<MacFilePromiseWrapper>();
      
      private var _activePromises:Vector.<MacFilePromiseWrapper> = new Vector.<MacFilePromiseWrapper>();
      
      private var _syncPromisesTimer:Timer = new Timer(100);
      
      private var _asyncPromisesTimer:Timer = new Timer(100);
      
      public function FilePromiseManager()
      {
         super();
         this._syncPromisesTimer.addEventListener(TimerEvent.TIMER,this.processSyncPromises);
         this._asyncPromisesTimer.addEventListener(TimerEvent.TIMER,this.processAsyncPromises);
      }
      
      public static native function newFilePromiseErrorEvent(param1:int) : Event;
      
      public function addPromises(clipboard:Clipboard, dropDirectoryPath:String) : Boolean
      {
         var promise:IFilePromise = null;
         if(clipboard == null)
         {
            return false;
         }
         var promises:Array = clipboard.getData(ClipboardFormats.FILE_PROMISE_LIST_FORMAT) as Array;
         if(promises == null)
         {
            return false;
         }
         var baseDirectory:File = new File(dropDirectoryPath);
         for(var i:int = 0; i < promises.length; i++)
         {
            promise = promises[i] as IFilePromise;
            if(promise != null)
            {
               (promise.isAsync ? this._asyncPromises : this._syncPromises).push(new MacFilePromiseWrapper(promise,baseDirectory));
            }
         }
         if(this._syncPromises.length > 0 && !this._syncPromisesTimer.running)
         {
            this._syncPromisesTimer.start();
         }
         if(this._asyncPromises.length > 0 && this._activePromises.length < MAX_ACTIVE_ASYNC_PROMISES)
         {
            this._asyncPromisesTimer.start();
         }
         return true;
      }
      
      private function processAsyncPromises(e:TimerEvent = null) : void
      {
         var activePromise:MacFilePromiseWrapper = null;
         if(this._asyncPromisesTimer.running)
         {
            this._asyncPromisesTimer.stop();
         }
         while(this._asyncPromises.length > 0 && this._activePromises.length < MAX_ACTIVE_ASYNC_PROMISES)
         {
            activePromise = this._asyncPromises.shift();
            if(activePromise.open())
            {
               activePromise.addEventListener(ASYNC_FILE_PROMISE_DONE_EVENT,this.onAsyncPromiseDone);
               this._activePromises.push(activePromise);
            }
         }
      }
      
      private function processSyncPromises(e:TimerEvent = null) : void
      {
         this._syncPromisesTimer.stop();
         if(this._syncPromises.length > 0)
         {
            this._syncPromises.shift().open();
         }
         if(this._syncPromises.length > 0)
         {
            this._syncPromisesTimer.start();
         }
      }
      
      private function onAsyncPromiseDone(e:Event) : void
      {
         var promise:MacFilePromiseWrapper = null;
         var activePromise:MacFilePromiseWrapper = e.target as MacFilePromiseWrapper;
         var len:int = int(this._activePromises.length);
         for(var i:int = 0; i < len; i++)
         {
            promise = this._activePromises.shift();
            if(promise !== activePromise)
            {
               this._activePromises.push(promise);
            }
         }
         this.processAsyncPromises();
      }
   }
}

