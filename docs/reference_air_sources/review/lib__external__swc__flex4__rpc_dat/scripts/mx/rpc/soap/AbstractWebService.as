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
      
      private var _httpHeaders:Object;
      
      private var _xmlSpecialCharsFilter:Function;
      
      public var convertParametersHandler:Function;
      
      public var convertResultHandler:Function;
      
      protected var _endpointURI:String;
      
      private var _description:String;
      
      private var endpointOverride:String;
      
      private var _headers:Array;
      
      private var _makeObjectsBindable:Boolean;
      
      protected var _port:String;
      
      private var _rootURL:String;
      
      protected var _service:String;
      
      private var _useProxy:Boolean;
      
      protected var destinationSet:Boolean;
      
      protected var _ready:Boolean;
      
      private var _log:ILogger;
      
      public function AbstractWebService(destination:String = null, rootURL:String = null)
      {
         super(destination);
         this._useProxy = false;
         this._headers = [];
         this._log = Log.getLogger("mx.rpc.soap.AbstractWebService");
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
            this.destinationSet = false;
         }
         else
         {
            this.destinationSet = true;
         }
         this.makeObjectsBindable = true;
         this._ready = true;
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
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(value:String) : void
      {
         this._description = value;
      }
      
      override public function get destination() : String
      {
         return super.destination;
      }
      
      override public function set destination(value:String) : void
      {
         super.destination = value;
         this.useProxy = true;
         this.destinationSet = true;
      }
      
      public function get endpointURI() : String
      {
         return Boolean(this.endpointOverride) ? this.endpointOverride : this._endpointURI;
      }
      
      public function set endpointURI(value:String) : void
      {
         this.endpointOverride = value;
      }
      
      public function get headers() : Array
      {
         return this._headers;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get httpHeaders() : Object
      {
         return this._httpHeaders;
      }
      
      public function set httpHeaders(value:Object) : void
      {
         this._httpHeaders = value;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      public function get makeObjectsBindable() : Boolean
      {
         return this._makeObjectsBindable;
      }
      
      public function set makeObjectsBindable(value:Boolean) : void
      {
         this._makeObjectsBindable = value;
      }
      
      public function get port() : String
      {
         return this._port;
      }
      
      public function set port(value:String) : void
      {
         this._port = value;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function get rootURL() : String
      {
         if(this._rootURL == null)
         {
            this._rootURL = LoaderConfig.url;
         }
         return this._rootURL;
      }
      
      public function set rootURL(value:String) : void
      {
         this._rootURL = value;
      }
      
      public function get service() : String
      {
         return this._service;
      }
      
      public function set service(value:String) : void
      {
         this._service = value;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get useProxy() : Boolean
      {
         return this._useProxy;
      }
      
      public function set useProxy(value:Boolean) : void
      {
         var dcs:ChannelSet = null;
         if(value != this._useProxy)
         {
            this._useProxy = value;
            dcs = this.getDirectChannelSet();
            if(!this.useProxy)
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
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get xmlSpecialCharsFilter() : Function
      {
         return this._xmlSpecialCharsFilter;
      }
      
      public function set xmlSpecialCharsFilter(func:Function) : void
      {
         this._xmlSpecialCharsFilter = func;
      }
      
      public function addHeader(header:Object) : void
      {
         this._headers.push(header);
      }
      
      public function addSimpleHeader(qnameLocal:String, qnameNamespace:String, headerName:String, headerValue:String) : void
      {
         var obj:Object = {};
         obj[headerName] = headerValue;
         this.addHeader(new SOAPHeader(new QName(qnameNamespace,qnameLocal),obj));
      }
      
      public function clearHeaders() : void
      {
         this._headers.length = 0;
      }
      
      public function getHeader(qname:QName, headerName:String = null) : SOAPHeader
      {
         var header:SOAPHeader = null;
         var length:uint = this._headers.length;
         for(var i:uint = 0; i < length; i++)
         {
            header = SOAPHeader(this._headers[i]);
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
      
      public function removeHeader(qname:QName, headerName:String = null) : void
      {
         var header:SOAPHeader = null;
         var length:uint = this._headers.length;
         for(var i:uint = 0; i < length; i++)
         {
            header = SOAPHeader(this._headers[i]);
            if(XMLUtil.qnamesEqual(header.qname,qname))
            {
               if(!Boolean(headerName))
               {
                  this._headers.splice(i,1);
                  return;
               }
               if(Boolean(header.content) && Boolean(header.content[headerName]))
               {
                  this._headers.splice(i,1);
                  return;
               }
            }
         }
      }
      
      override public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String = null) : void
      {
         super.setRemoteCredentials(remoteUsername,remotePassword,charset);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDirectChannelSet() : ChannelSet
      {
         var dcs:ChannelSet = null;
         var dhc:DirectHTTPChannel = null;
         if(_directChannelSet == null)
         {
            dcs = new ChannelSet();
            dhc = new DirectHTTPChannel("direct_http_channel");
            dhc.requestTimeout = requestTimeout;
            dcs.addChannel(dhc);
            _directChannelSet = dcs;
         }
         return _directChannelSet;
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
                  this._log.info("Faulting previously queued operation calls {0}",op.name);
                  while(op.hasPendingInvocations())
                  {
                     op.cancel();
                     op.dispatchEvent(FaultEvent.createEvent(fault));
                  }
               }
               else
               {
                  this._log.info("Invoking previously queued calls {0}",op.name);
                  op.invokeAllPending();
               }
            }
         }
      }
   }
}

