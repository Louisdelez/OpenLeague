package mx.rpc.http
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.DirectHTTPChannel;
   import mx.messaging.config.LoaderConfig;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractService;
   import mx.rpc.mxml.Concurrency;
   import mx.utils.URLUtil;
   
   [DefaultProperty("operationList")]
   [ResourceBundle("rpc")]
   [Event(name="invoke",type="mx.rpc.events.InvokeEvent")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   [Event(name="result",type="mx.rpc.events.ResultEvent")]
   public dynamic class HTTPMultiService extends AbstractService
   {
      
      private static var _directChannelSet:ChannelSet;
      
      private var _log:ILogger;
      
      [Inspectable(defaultValue="undefined",category="General")]
      public var headers:Object = {};
      
      public var serializationFilter:SerializationFilter;
      
      private var _useProxy:Boolean = false;
      
      private var _resultFormat:String = AbstractOperation.RESULT_FORMAT_OBJECT;
      
      private var _concurrency:String;
      
      public var baseURL:String;
      
      [Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete",defaultValue="GET",category="General")]
      public var method:String = HTTPRequestMessage.GET_METHOD;
      
      [Inspectable(enumeration="application/x-www-form-urlencoded,application/xml",defaultValue="application/x-www-form-urlencoded",category="General")]
      public var contentType:String = AbstractOperation.CONTENT_TYPE_FORM;
      
      private var _showBusyCursor:Boolean = false;
      
      [Inspectable(defaultValue="true",category="General")]
      public var makeObjectsBindable:Boolean = true;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function HTTPMultiService(baseURL:String = null, destination:String = null)
      {
         super();
         makeObjectsBindable = true;
         if(destination == null)
         {
            if(URLUtil.isHttpsURL(LoaderConfig.url))
            {
               asyncRequest.destination = HTTPService.DEFAULT_DESTINATION_HTTPS;
            }
            else
            {
               asyncRequest.destination = HTTPService.DEFAULT_DESTINATION_HTTP;
            }
         }
         else
         {
            asyncRequest.destination = destination;
         }
         _log = Log.getLogger("mx.rpc.http.HTTPMultiService");
         this.baseURL = baseURL;
         concurrency = Concurrency.MULTIPLE;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get showBusyCursor() : Boolean
      {
         return _showBusyCursor;
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
      
      public function set operationList(ol:Array) : void
      {
         var op:AbstractOperation = null;
         var ops:Object = null;
         var i:int = 0;
         var name:String = null;
         if(ol == null)
         {
            operations = null;
         }
         else
         {
            ops = new Object();
            for(i = 0; i < ol.length; i++)
            {
               op = AbstractOperation(ol[i]);
               name = op.name;
               if(!name)
               {
                  throw new ArgumentError("Operations must have a name property value for HTTPMultiService");
               }
               ops[name] = op;
            }
            operations = ops;
         }
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         _showBusyCursor = sbc;
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         return _concurrency;
      }
      
      override public function set destination(value:String) : void
      {
         useProxy = true;
         super.destination = value;
      }
      
      public function get operationList() : Array
      {
         var i:String = null;
         var op:AbstractOperation = null;
         if(operations == null)
         {
            return null;
         }
         var ol:Array = new Array();
         for(i in operations)
         {
            op = operations[i];
            ol.push(op);
         }
         return ol;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get useProxy() : Boolean
      {
         return _useProxy;
      }
      
      public function set concurrency(c:String) : void
      {
         _concurrency = c;
      }
      
      public function set resultFormat(value:String) : void
      {
         var message:String = null;
         switch(value)
         {
            case AbstractOperation.RESULT_FORMAT_OBJECT:
            case AbstractOperation.RESULT_FORMAT_ARRAY:
            case AbstractOperation.RESULT_FORMAT_XML:
            case AbstractOperation.RESULT_FORMAT_E4X:
            case AbstractOperation.RESULT_FORMAT_TEXT:
            case AbstractOperation.RESULT_FORMAT_FLASHVARS:
               break;
            default:
               if(value != null && (serializationFilter = SerializationFilter.filterForResultFormatTable[value]) == null)
               {
                  message = resourceManager.getString("rpc","invalidResultFormat",[value,AbstractOperation.RESULT_FORMAT_OBJECT,AbstractOperation.RESULT_FORMAT_ARRAY,AbstractOperation.RESULT_FORMAT_XML,AbstractOperation.RESULT_FORMAT_E4X,AbstractOperation.RESULT_FORMAT_TEXT,AbstractOperation.RESULT_FORMAT_FLASHVARS]);
                  throw new ArgumentError(message);
               }
         }
         _resultFormat = value;
      }
      
      [Inspectable(enumeration="object,array,xml,flashvars,text,e4x",defaultValue="object",category="General")]
      public function get resultFormat() : String
      {
         return _resultFormat;
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
   }
}

