package mx.rpc.http
{
   import mx.logging.Log;
   import mx.rpc.AbstractService;
   import mx.rpc.AsyncRequest;
   import mx.rpc.AsyncToken;
   import mx.utils.URLUtil;
   
   public class Operation extends AbstractOperation
   {
      
      private var _method:String;
      
      private var _methodSet:Boolean = false;
      
      private var _makeObjectsBindableSet:Boolean;
      
      private var _contentTypeSet:Boolean = false;
      
      private var _concurrency:String;
      
      private var _resultFormatSet:Boolean = false;
      
      private var _multiService:HTTPMultiService;
      
      private var _concurrencySet:Boolean;
      
      private var _showBusyCursorSet:Boolean = false;
      
      private var _useProxySet:Boolean = false;
      
      public function Operation(service:HTTPMultiService = null, name:String = null)
      {
         super(service,name);
         _concurrencySet = false;
         _multiService = service;
         _log = Log.getLogger("mx.rpc.http.HTTPMultiService");
      }
      
      override public function set method(m:String) : void
      {
         _method = m;
         _methodSet = m != null;
      }
      
      override public function get showBusyCursor() : Boolean
      {
         if(_showBusyCursorSet)
         {
            return super.showBusyCursor;
         }
         return _multiService.showBusyCursor;
      }
      
      override public function set useProxy(value:Boolean) : void
      {
         _useProxySet = true;
         super.useProxy = value;
      }
      
      override public function send(... args) : AsyncToken
      {
         var params:Object = null;
         var i:int = 0;
         if(_multiService != null)
         {
            _multiService.initialize();
         }
         if(operationManager != null)
         {
            return operationManager(args);
         }
         var filter:SerializationFilter = getSerializationFilter();
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
               if(argumentNames.length == 1 && contentType == CONTENT_TYPE_XML)
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
      
      override protected function getHeaders() : Object
      {
         if(headers != null)
         {
            return headers;
         }
         return _multiService.headers;
      }
      
      override protected function getSerializationFilter() : SerializationFilter
      {
         var sf:SerializationFilter = serializationFilter;
         if(sf == null)
         {
            return _multiService.serializationFilter;
         }
         return sf;
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      override public function get concurrency() : String
      {
         if(_concurrencySet)
         {
            return _concurrency;
         }
         return _multiService.concurrency;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(s:AbstractService) : void
      {
         super.setService(s);
         if(s is HTTPMultiService)
         {
            _multiService = s as HTTPMultiService;
         }
      }
      
      override public function set showBusyCursor(b:Boolean) : void
      {
         super.showBusyCursor = b;
         _showBusyCursorSet = true;
      }
      
      override public function get contentType() : String
      {
         if(_contentTypeSet)
         {
            return super.contentType;
         }
         return _multiService.contentType;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get asyncRequest() : AsyncRequest
      {
         return _multiService.asyncRequest;
      }
      
      override public function get method() : String
      {
         if(_methodSet)
         {
            return _method;
         }
         return _multiService.method;
      }
      
      override public function set concurrency(c:String) : void
      {
         _concurrency = c;
         _concurrencySet = true;
      }
      
      override public function get useProxy() : Boolean
      {
         if(_useProxySet)
         {
            return super.useProxy;
         }
         return _multiService.useProxy;
      }
      
      override public function get rootURL() : String
      {
         var useRootURL:String = null;
         if(_rootURL == null)
         {
            useRootURL = _multiService.baseURL;
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
      
      override public function set resultFormat(rf:String) : void
      {
         _resultFormatSet = rf != null;
         super.resultFormat = rf;
      }
      
      override public function get resultFormat() : String
      {
         if(_resultFormatSet)
         {
            return super.resultFormat;
         }
         return _multiService.resultFormat;
      }
      
      override public function set makeObjectsBindable(b:Boolean) : void
      {
         _makeObjectsBindable = b;
         _makeObjectsBindableSet = true;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      override public function get makeObjectsBindable() : Boolean
      {
         if(_makeObjectsBindableSet)
         {
            return _makeObjectsBindable;
         }
         return _multiService.makeObjectsBindable;
      }
      
      override public function set contentType(ct:String) : void
      {
         _contentTypeSet = ct != null;
         super.contentType = ct;
      }
   }
}

