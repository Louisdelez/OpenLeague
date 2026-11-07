package spark.core
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import spark.events.LoaderInvalidationEvent;
   
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="httpStatus",type="flash.events.HTTPStatusEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class ContentRequest extends EventDispatcher
   {
      
      private var _shared:Boolean;
      
      protected var _content:Object;
      
      private var _complete:Boolean;
      
      public function ContentRequest(contentLoader:IContentLoader, content:*, shared:Boolean = false, complete:Boolean = false)
      {
         super();
         this.content = content;
         this._shared = shared;
         this._complete = complete;
         contentLoader.addEventListener("invalidateLoader",this.contentLoader_invalidateLoaderHandler,false,0,true);
      }
      
      public function get content() : Object
      {
         return this._content;
      }
      
      public function set content(value:Object) : void
      {
         this.removeLoaderListeners();
         this._content = value;
         this.addLoaderListeners();
      }
      
      public function get complete() : Boolean
      {
         if(Boolean(this._content) && this._content is LoaderInfo)
         {
            return this._complete;
         }
         return this._content != null;
      }
      
      private function addLoaderListeners() : void
      {
         var _contentLoaderInfo:LoaderInfo = null;
         if(Boolean(this._content) && this._content is LoaderInfo)
         {
            _contentLoaderInfo = LoaderInfo(this._content);
            _contentLoaderInfo.addEventListener(Event.COMPLETE,this.content_completeHandler,false,0,true);
            _contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.content_ioErrorHandler,false,0,true);
            _contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,dispatchEvent,false,0,true);
            _contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,dispatchEvent,false,0,true);
            _contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,dispatchEvent,false,0,true);
         }
      }
      
      private function removeLoaderListeners() : void
      {
         var _contentLoaderInfo:LoaderInfo = null;
         if(Boolean(this._content) && this._content is LoaderInfo)
         {
            _contentLoaderInfo = LoaderInfo(this._content);
            _contentLoaderInfo.removeEventListener(Event.COMPLETE,this.content_completeHandler);
            _contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.content_ioErrorHandler);
            _contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,dispatchEvent);
            _contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,dispatchEvent);
            _contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,dispatchEvent);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function content_completeHandler(e:Event) : void
      {
         if(e.target == this._content)
         {
            this._complete = true;
            dispatchEvent(e);
            this.removeLoaderListeners();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function content_ioErrorHandler(e:Event) : void
      {
         if(e.target == this._content)
         {
            if(hasEventListener(IOErrorEvent.IO_ERROR))
            {
               dispatchEvent(e);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function contentLoader_invalidateLoaderHandler(e:LoaderInvalidationEvent) : void
      {
         var loader:Loader = null;
         var loaderContext:LoaderContext = null;
         var url:String = null;
         var loaderInfo:LoaderInfo = null;
         if(this._shared)
         {
            if(this._content == e.content)
            {
               this._shared = false;
               loader = new Loader();
               loaderContext = new LoaderContext();
               url = this._content.url;
               loaderInfo = loader.contentLoaderInfo;
               loaderContext.checkPolicyFile = true;
               loader.load(new URLRequest(url),loaderContext);
            }
         }
      }
   }
}

