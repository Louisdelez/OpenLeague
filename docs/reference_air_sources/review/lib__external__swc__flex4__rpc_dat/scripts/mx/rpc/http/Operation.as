package mx.rpc.http
{
   import mx.logging.Log;
   import mx.rpc.AbstractService;
   import mx.rpc.AsyncRequest;
   import mx.rpc.AsyncToken;
   import mx.utils.URLUtil;
   
   public class Operation extends AbstractOperation
   {
      
      private var _multiService:HTTPMultiService;
      
      private var _concurrency:String;
      
      private var _concurrencySet:Boolean;
      
      private var _makeObjectsBindableSet:Boolean;
      
      private var _methodSet:Boolean = false;
      
      private var _method:String;
      
      private var _showBusyCursorSet:Boolean = false;
      
      private var _useProxySet:Boolean = false;
      
      private var _contentTypeSet:Boolean = false;
      
      private var _resultFormatSet:Boolean = false;
      
      public function Operation(service:HTTPMultiService = null, name:String = null)
      {
         super(service,name);
         this._concurrencySet = false;
         this._multiService = service;
         _log = Log.getLogger("mx.rpc.http.HTTPMultiService");
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      override public function get concurrency() : String
      {
         if(this._concurrencySet)
         {
            return this._concurrency;
         }
         return this._multiService.concurrency;
      }
      
      override public function set concurrency(c:String) : void
      {
         this._concurrency = c;
         this._concurrencySet = true;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      override public function get makeObjectsBindable() : Boolean
      {
         if(this._makeObjectsBindableSet)
         {
            return _makeObjectsBindable;
         }
         return this._multiService.makeObjectsBindable;
      }
      
      override public function set makeObjectsBindable(b:Boolean) : void
      {
         _makeObjectsBindable = b;
         this._makeObjectsBindableSet = true;
      }
      
      override public function get method() : String
      {
         if(this._methodSet)
         {
            return this._method;
         }
         return this._multiService.method;
      }
      
      override public function set method(m:String) : void
      {
         this._method = m;
         this._methodSet = m != null;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(s:AbstractService) : void
      {
         super.setService(s);
         if(s is HTTPMultiService)
         {
            this._multiService = s as HTTPMultiService;
         }
      }
      
      override public function get showBusyCursor() : Boolean
      {
         if(this._showBusyCursorSet)
         {
            return super.showBusyCursor;
         }
         return this._multiService.showBusyCursor;
      }
      
      override public function set showBusyCursor(b:Boolean) : void
      {
         super.showBusyCursor = b;
         this._showBusyCursorSet = true;
      }
      
      override public function get rootURL() : String
      {
         var useRootURL:String = null;
         if(_rootURL == null)
         {
            useRootURL = this._multiService.baseURL;
            if(useRootURL != null && useRootURL.length > 0)
            {
               if(useRootURL.charAt(useRootURL.length - 1) != "/")
               {
                  useRootURL += "/";
               }
               if(useRootURL.charAt(0) == "/")
               {
                  useRootURL = URLUtil.getFullURL(super.rootURL,useRootURL);
               }
               return useRootURL;
            }
            return super.rootURL;
         }
         return _rootURL;
      }
      
      override public function get useProxy() : Boolean
      {
         if(this._useProxySet)
         {
            return super.useProxy;
         }
         return this._multiService.useProxy;
      }
      
      override public function set useProxy(value:Boolean) : void
      {
         this._useProxySet = true;
         super.useProxy = value;
      }
      
      override public function get contentType() : String
      {
         if(this._contentTypeSet)
         {
            return super.contentType;
         }
         return this._multiService.contentType;
      }
      
      override public function set contentType(ct:String) : void
      {
         this._contentTypeSet = ct != null;
         super.contentType = ct;
      }
      
      override public function send(... args) : AsyncToken
      {
         var params:Object = null;
         var i:int = 0;
         if(this._multiService != null)
         {
            this._multiService.initialize();
         }
         if(operationManager != null)
         {
            return operationManager(args);
         }
         var filter:SerializationFilter = this.getSerializationFilter();
         if(filter != null)
         {
            params = filter.serializeParameters(this,args);
         }
         else
         {
            params = args;
            if(!params || Boolean(params.length == 0) && Boolean(this.request))
            {
               params = this.request;
            }
            if(params is Array && argumentNames != null)
            {
               args = params as Array;
               if(args.length != argumentNames.length)
               {
                  throw new ArgumentError("HTTPMultiService operation called with " + argumentNames.length + " argumentNames and " + args.length + " number of parameters.  When argumentNames is specified, it must match the number of arguments passed to the invocation");
               }
               if(argumentNames.length == 1 && this.contentType == CONTENT_TYPE_XML)
               {
                  params = args[0];
               }
               else
               {
                  for(i = 0; i < argumentNames.length; i++)
                  {
                     params[argumentNames[i]] = args[i];
                  }
               }
            }
            else if(args.length == 1)
            {
               params = args[0];
            }
            else if(args.length != 0)
            {
               throw new ArgumentError("HTTPMultiService - you must set argumentNames to an array of parameter names if you use more than one parameter.");
            }
         }
         return sendBody(params);
      }
      
      override public function get resultFormat() : String
      {
         if(this._resultFormatSet)
         {
            return super.resultFormat;
         }
         return this._multiService.resultFormat;
      }
      
      override public function set resultFormat(rf:String) : void
      {
         this._resultFormatSet = rf != null;
         super.resultFormat = rf;
      }
      
      override protected function getSerializationFilter() : SerializationFilter
      {
         var sf:SerializationFilter = serializationFilter;
         if(sf == null)
         {
            return this._multiService.serializationFilter;
         }
         return sf;
      }
      
      override protected function getHeaders() : Object
      {
         if(headers != null)
         {
            return headers;
         }
         return this._multiService.headers;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get asyncRequest() : AsyncRequest
      {
         return this._multiService.asyncRequest;
      }
   }
}

