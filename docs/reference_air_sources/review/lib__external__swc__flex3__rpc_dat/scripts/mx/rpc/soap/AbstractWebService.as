package mx.rpc.soap
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.DirectHTTPChannel;
   import mx.messaging.config.LoaderConfig;
   import mx.rpc.AbstractService;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.utils.URLUtil;
   import mx.utils.XMLUtil;
   
   public class AbstractWebService extends AbstractService
   {
      
      private static var _directChannelSet:ChannelSet = null;
      
      public static const DEFAULT_DESTINATION_HTTP:String = "DefaultHTTP";
      
      public static const DEFAULT_DESTINATION_HTTPS:String = "DefaultHTTPS";
      
      private var _log:ILogger;
      
      private var endpointOverride:String;
      
      public var convertParametersHandler:Function;
      
      private var _httpHeaders:Object;
      
      protected var _ready:Boolean;
      
      private var _useProxy:Boolean;
      
      private var _xmlSpecialCharsFilter:Function;
      
      private var _description:String;
      
      private var _makeObjectsBindable:Boolean;
      
      private var _headers:Array;
      
      protected var _endpointURI:String;
      
      protected var _port:String;
      
      private var _rootURL:String;
      
      protected var _service:String;
      
      public var convertResultHandler:Function;
      
      protected var destinationSet:Boolean;
      
      public function AbstractWebService(destination:String = null, rootURL:String = null)
      {
         super(destination);
         _useProxy = false;
         _headers = [];
         _log = Log.getLogger("mx.rpc.soap.AbstractWebService");
         if(destination == null)
         {
            if(URLUtil.isHttpsURL(LoaderConfig.url))
            {
               super.destination = DEFAULT_DESTINATION_HTTPS;
            }
            else
            {
               super.destination = DEFAULT_DESTINATION_HTTP;
            }
            destinationSet = false;
         }
         else
         {
            destinationSet = true;
         }
         makeObjectsBindable = true;
         _ready = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function findJSessionID() : String
      {
         var js:Object = null;
         var u:String = null;
         var ind:Number = NaN;
         var arr:Array = null;
         var jsessionid:String = null;
         var args:Object = LoaderConfig.parameters;
         if(Boolean(args))
         {
            js = args.jsessionid;
            if(!js)
            {
               js = args.JSESSIONID;
               if(!js)
               {
                  u = LoaderConfig.url;
                  if(Boolean(u))
                  {
                     ind = u.lastIndexOf(";");
                     if(ind != -1)
                     {
                        arr = u.substring(ind + 1).split("=");
                        if(arr[0] == "jsessionid" || arr[0] == "JSESSIONID")
                        {
                           jsessionid = arr[1];
                        }
                     }
                  }
               }
               else
               {
                  jsessionid = String(js);
               }
            }
            else
            {
               jsessionid = String(js);
            }
         }
         return jsessionid;
      }
      
      public function get port() : String
      {
         return _port;
      }
      
      public function set port(value:String) : void
      {
         _port = value;
      }
      
      public function getHeader(qname:QName, headerName:String = null) : SOAPHeader
      {
         var header:SOAPHeader = null;
         var length:uint = _headers.length;
         for(var i:uint = 0; i < length; i++)
         {
            header = SOAPHeader(_headers[i]);
            if(XMLUtil.qnamesEqual(header.qname,qname))
            {
               if(!Boolean(headerName))
               {
                  return header;
               }
               if(Boolean(header.content) && Boolean(header.content[headerName]))
               {
                  return header;
               }
            }
         }
         return null;
      }
      
      public function get headers() : Array
      {
         return _headers;
      }
      
      public function get description() : String
      {
         return _description;
      }
      
      override public function get destination() : String
      {
         return super.destination;
      }
      
      override public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String = null) : void
      {
         super.setRemoteCredentials(remoteUsername,remotePassword,charset);
      }
      
      public function addHeader(header:Object) : void
      {
         _headers.push(header);
      }
      
      public function get endpointURI() : String
      {
         return Boolean(endpointOverride) ? endpointOverride : _endpointURI;
      }
      
      override public function set destination(value:String) : void
      {
         super.destination = value;
         useProxy = true;
         destinationSet = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDirectChannelSet() : ChannelSet
      {
         var dcs:ChannelSet = null;
         if(_directChannelSet == null)
         {
            dcs = new ChannelSet();
            dcs.addChannel(new DirectHTTPChannel("direct_http_channel"));
            _directChannelSet = dcs;
         }
         return _directChannelSet;
      }
      
      public function addSimpleHeader(qnameLocal:String, qnameNamespace:String, headerName:String, headerValue:String) : void
      {
         var obj:Object = {};
         obj[headerName] = headerValue;
         addHeader(new SOAPHeader(new QName(qnameNamespace,qnameLocal),obj));
      }
      
      public function get ready() : Boolean
      {
         return _ready;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get useProxy() : Boolean
      {
         return _useProxy;
      }
      
      public function get rootURL() : String
      {
         if(_rootURL == null)
         {
            _rootURL = LoaderConfig.url;
         }
         return _rootURL;
      }
      
      public function set endpointURI(value:String) : void
      {
         endpointOverride = value;
      }
      
      public function removeHeader(qname:QName, headerName:String = null) : void
      {
         var header:SOAPHeader = null;
         var length:uint = _headers.length;
         for(var i:uint = 0; i < length; i++)
         {
            header = SOAPHeader(_headers[i]);
            if(XMLUtil.qnamesEqual(header.qname,qname))
            {
               if(!Boolean(headerName))
               {
                  _headers.splice(i,1);
                  return;
               }
               if(Boolean(header.content) && Boolean(header.content[headerName]))
               {
                  _headers.splice(i,1);
                  return;
               }
            }
         }
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get xmlSpecialCharsFilter() : Function
      {
         return _xmlSpecialCharsFilter;
      }
      
      public function get service() : String
      {
         return _service;
      }
      
      public function set httpHeaders(value:Object) : void
      {
         _httpHeaders = value;
      }
      
      public function set useProxy(value:Boolean) : void
      {
         var dcs:ChannelSet = null;
         if(value != _useProxy)
         {
            _useProxy = value;
            dcs = getDirectChannelSet();
            if(!useProxy)
            {
               if(dcs != asyncRequest.channelSet)
               {
                  asyncRequest.channelSet = dcs;
               }
            }
            else if(asyncRequest.channelSet == dcs)
            {
               asyncRequest.channelSet = null;
            }
         }
      }
      
      public function set rootURL(value:String) : void
      {
         _rootURL = value;
      }
      
      public function set makeObjectsBindable(value:Boolean) : void
      {
         _makeObjectsBindable = value;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get httpHeaders() : Object
      {
         return _httpHeaders;
      }
      
      protected function unEnqueueCalls(fault:Fault = null) : void
      {
         var op:Operation = null;
         var opName:String = null;
         for(opName in _operations)
         {
            op = _operations[opName];
            if(op.hasPendingInvocations())
            {
               if(fault != null)
               {
                  _log.info("Faulting previously queued operation calls {0}",op.name);
                  while(op.hasPendingInvocations())
                  {
                     op.cancel();
                     op.dispatchEvent(FaultEvent.createEvent(fault));
                  }
               }
               else
               {
                  _log.info("Invoking previously queued calls {0}",op.name);
                  op.invokeAllPending();
               }
            }
         }
      }
      
      public function set service(value:String) : void
      {
         _service = value;
      }
      
      public function set xmlSpecialCharsFilter(func:Function) : void
      {
         _xmlSpecialCharsFilter = func;
      }
      
      public function set description(value:String) : void
      {
         _description = value;
      }
      
      public function clearHeaders() : void
      {
         _headers.length = 0;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      public function get makeObjectsBindable() : Boolean
      {
         return _makeObjectsBindable;
      }
   }
}

