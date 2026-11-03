package mx.rpc.http
{
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.DirectHTTPChannel;
   import mx.messaging.config.LoaderConfig;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.messaging.messages.IMessage;
   import mx.netmon.NetworkMonitor;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractOperation;
   import mx.rpc.AbstractService;
   import mx.rpc.AsyncDispatcher;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.mxml.Concurrency;
   import mx.rpc.xml.SimpleXMLDecoder;
   import mx.rpc.xml.SimpleXMLEncoder;
   import mx.utils.ObjectProxy;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   import mx.utils.URLUtil;
   
   public class AbstractOperation extends mx.rpc.AbstractOperation
   {
      
      private static var _directChannelSet:ChannelSet;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const RESULT_FORMAT_E4X:String = "e4x";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const RESULT_FORMAT_FLASHVARS:String = "flashvars";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const RESULT_FORMAT_OBJECT:String = "object";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const RESULT_FORMAT_ARRAY:String = "array";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const RESULT_FORMAT_TEXT:String = "text";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const RESULT_FORMAT_XML:String = "xml";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CONTENT_TYPE_XML:String = "application/xml";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
      
      private static const ERROR_URL_REQUIRED:String = "Client.URLRequired";
      
      private static const ERROR_DECODING:String = "Client.CouldNotDecode";
      
      private static const ERROR_ENCODING:String = "Client.CouldNotEncode";
      
      private var _method:String = "GET";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _log:ILogger;
      
      private var _useProxy:Boolean = false;
      
      public var serializationFilter:SerializationFilter;
      
      public var argumentNames:Array;
      
      [Inspectable(defaultValue="undefined",category="General")]
      public var xmlEncode:Function;
      
      [Inspectable(defaultValue="undefined",category="General")]
      public var request:Object = {};
      
      private var _contentType:String = "application/x-www-form-urlencoded";
      
      [Inspectable(defaultValue="undefined",category="General")]
      public var headers:Object = {};
      
      private var _url:String;
      
      private var _showBusyCursor:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _resultFormat:String = "object";
      
      private var _concurrency:String;
      
      [Inspectable(defaultValue="undefined",category="General")]
      public var xmlDecode:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _rootURL:String;
      
      public function AbstractOperation(service:AbstractService = null, name:String = null)
      {
         super(service,name);
         _log = Log.getLogger("mx.rpc.http.HTTPService");
         concurrency = Concurrency.MULTIPLE;
      }
      
      private function decodeArray(o:Object) : Object
      {
         var a:Array = null;
         if(o is Array)
         {
            a = o as Array;
         }
         else
         {
            if(o is ArrayCollection)
            {
               return o;
            }
            a = [];
            a.push(o);
         }
         if(makeObjectsBindable)
         {
            return new ArrayCollection(a);
         }
         return a;
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         return _concurrency;
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         _showBusyCursor = sbc;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get showBusyCursor() : Boolean
      {
         return _showBusyCursor;
      }
      
      private function getDirectChannelSet() : ChannelSet
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
      
      public function set concurrency(c:String) : void
      {
         _concurrency = c;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get useProxy() : Boolean
      {
         return _useProxy;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function preHandle(event:MessageEvent) : AsyncToken
      {
         if(showBusyCursor)
         {
            CursorManager.removeBusyCursor();
         }
         var wasLastCall:Boolean = activeCalls.wasLastCall(AsyncMessage(event.message).correlationId);
         var token:AsyncToken = super.preHandle(event);
         if(Concurrency.LAST == concurrency && !wasLastCall)
         {
            return null;
         }
         return token;
      }
      
      public function get rootURL() : String
      {
         if(_rootURL == null)
         {
            _rootURL = LoaderConfig.url;
         }
         return _rootURL;
      }
      
      public function set contentType(ct:String) : void
      {
         _contentType = ct;
      }
      
      public function set method(m:String) : void
      {
         _method = m;
      }
      
      private function decodeParameterString(source:String) : Object
      {
         var param:String = null;
         var equalsIndex:int = 0;
         var name:String = null;
         var value:String = null;
         var trimmed:String = StringUtil.trim(source);
         var params:Array = trimmed.split("&");
         var decoded:Object = {};
         for(var i:int = 0; i < params.length; i++)
         {
            param = params[i];
            equalsIndex = param.indexOf("=");
            if(equalsIndex != -1)
            {
               name = param.substr(0,equalsIndex);
               name = name.split("+").join(" ");
               name = unescape(name);
               value = param.substr(equalsIndex + 1);
               value = value.split("+").join(" ");
               value = unescape(value);
               decoded[name] = value;
            }
         }
         return decoded;
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
      
      protected function getHeaders() : Object
      {
         return headers;
      }
      
      public function sendBody(parameters:Object) : AsyncToken
      {
         var paramsToSend:Object = null;
         var token:AsyncToken = null;
         var fault:Fault = null;
         var faultEvent:FaultEvent = null;
         var msg:String = null;
         var m:String = null;
         var funcEncoded:Object = null;
         var encoder:SimpleXMLEncoder = null;
         var xmlDoc:XMLDocument = null;
         var childNodes:Array = null;
         var i:int = 0;
         var val:Object = null;
         var classinfo:Object = null;
         var p:* = undefined;
         var dcs:ChannelSet = null;
         var filter:SerializationFilter = getSerializationFilter();
         if(Concurrency.SINGLE == concurrency && activeCalls.hasActiveCalls())
         {
            token = new AsyncToken(null);
            m = resourceManager.getString("rpc","pendingCallExists");
            fault = new Fault("ConcurrencyError",m);
            faultEvent = FaultEvent.createEvent(fault,token);
            new AsyncDispatcher(dispatchRpcEvent,[faultEvent],10);
            return token;
         }
         var ctype:String = contentType;
         var urlToUse:String = url;
         if(Boolean(urlToUse) && urlToUse != "")
         {
            urlToUse = URLUtil.getFullURL(rootURL,urlToUse);
         }
         if(filter != null)
         {
            ctype = filter.getRequestContentType(this,parameters,ctype);
            urlToUse = filter.serializeURL(this,parameters,urlToUse);
            parameters = filter.serializeBody(this,parameters);
         }
         if(ctype == CONTENT_TYPE_XML)
         {
            if(parameters is String && xmlEncode == null)
            {
               paramsToSend = parameters as String;
            }
            else if(!(parameters is XMLNode) && !(parameters is XML))
            {
               if(xmlEncode != null)
               {
                  funcEncoded = xmlEncode(parameters);
                  if(null == funcEncoded)
                  {
                     token = new AsyncToken(null);
                     msg = resourceManager.getString("rpc","xmlEncodeReturnNull");
                     fault = new Fault(ERROR_ENCODING,msg);
                     faultEvent = FaultEvent.createEvent(fault,token);
                     new AsyncDispatcher(dispatchRpcEvent,[faultEvent],10);
                     return token;
                  }
                  if(!(funcEncoded is XMLNode))
                  {
                     token = new AsyncToken(null);
                     msg = resourceManager.getString("rpc","xmlEncodeReturnNoXMLNode");
                     fault = new Fault(ERROR_ENCODING,msg);
                     faultEvent = FaultEvent.createEvent(fault,token);
                     new AsyncDispatcher(dispatchRpcEvent,[faultEvent],10);
                     return token;
                  }
                  paramsToSend = XMLNode(funcEncoded).toString();
               }
               else
               {
                  encoder = new SimpleXMLEncoder(null);
                  xmlDoc = new XMLDocument();
                  childNodes = encoder.encodeValue(parameters,new QName(null,"encoded"),new XMLNode(1,"top")).childNodes.concat();
                  for(i = 0; i < childNodes.length; i++)
                  {
                     xmlDoc.appendChild(childNodes[i]);
                  }
                  paramsToSend = xmlDoc.toString();
               }
            }
            else
            {
               paramsToSend = XML(parameters).toXMLString();
            }
         }
         else if(ctype == CONTENT_TYPE_FORM)
         {
            paramsToSend = {};
            if(typeof parameters == "object")
            {
               classinfo = ObjectUtil.getClassInfo(parameters);
               for each(p in classinfo.properties)
               {
                  val = parameters[p];
                  if(val != null)
                  {
                     if(val is Array)
                     {
                        paramsToSend[p] = val;
                     }
                     else
                     {
                        paramsToSend[p] = val.toString();
                     }
                  }
               }
            }
            else
            {
               paramsToSend = parameters;
            }
         }
         else
         {
            paramsToSend = parameters;
         }
         var message:HTTPRequestMessage = new HTTPRequestMessage();
         if(useProxy)
         {
            if(Boolean(urlToUse) && urlToUse != "")
            {
               message.url = urlToUse;
            }
            if(NetworkMonitor.isMonitoring())
            {
               message.recordHeaders = true;
            }
         }
         else
         {
            if(!urlToUse)
            {
               token = new AsyncToken(null);
               msg = resourceManager.getString("rpc","urlNotSpecified");
               fault = new Fault(ERROR_URL_REQUIRED,msg);
               faultEvent = FaultEvent.createEvent(fault,token);
               new AsyncDispatcher(dispatchRpcEvent,[faultEvent],10);
               return token;
            }
            if(!useProxy)
            {
               dcs = getDirectChannelSet();
               if(dcs != asyncRequest.channelSet)
               {
                  asyncRequest.channelSet = dcs;
               }
            }
            if(NetworkMonitor.isMonitoring())
            {
               message.recordHeaders = true;
            }
            message.url = urlToUse;
         }
         message.contentType = ctype;
         message.method = method.toUpperCase();
         if(ctype == CONTENT_TYPE_XML && message.method == HTTPRequestMessage.GET_METHOD)
         {
            message.method = HTTPRequestMessage.POST_METHOD;
         }
         message.body = paramsToSend;
         message.httpHeaders = getHeaders();
         return invoke(message);
      }
      
      protected function getSerializationFilter() : SerializationFilter
      {
         return serializationFilter;
      }
      
      public function get contentType() : String
      {
         return _contentType;
      }
      
      public function set url(value:String) : void
      {
         _url = value;
      }
      
      [Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete",defaultValue="GET",category="General")]
      public function get method() : String
      {
         return _method;
      }
      
      public function set resultFormat(value:String) : void
      {
         var sf:SerializationFilter = null;
         var message:String = null;
         switch(value)
         {
            case RESULT_FORMAT_OBJECT:
            case RESULT_FORMAT_ARRAY:
            case RESULT_FORMAT_XML:
            case RESULT_FORMAT_E4X:
            case RESULT_FORMAT_TEXT:
            case RESULT_FORMAT_FLASHVARS:
               break;
            default:
               if(value != null && (sf = SerializationFilter.filterForResultFormatTable[value]) == null)
               {
                  message = resourceManager.getString("rpc","invalidResultFormat",[value,RESULT_FORMAT_OBJECT,RESULT_FORMAT_ARRAY,RESULT_FORMAT_XML,RESULT_FORMAT_E4X,RESULT_FORMAT_TEXT,RESULT_FORMAT_FLASHVARS]);
                  throw new ArgumentError(message);
               }
               serializationFilter = sf;
         }
         _resultFormat = value;
      }
      
      public function set rootURL(value:String) : void
      {
         _rootURL = value;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processResult(message:IMessage, token:AsyncToken) : Boolean
      {
         var filter:SerializationFilter;
         var tmp:Object = null;
         var fault:Fault = null;
         var decoded:Object = null;
         var msg:String = null;
         var fault1:Fault = null;
         var decoder:SimpleXMLDecoder = null;
         var fault2:Fault = null;
         var fault3:Fault = null;
         var body:Object = message.body;
         _log.info("Decoding HTTPService response");
         _log.debug("Processing HTTPService response message:\n{0}",message);
         filter = getSerializationFilter();
         if(filter != null)
         {
            body = filter.deserializeResult(this,body);
         }
         if(body == null || body != null && body is String && StringUtil.trim(String(body)) == "")
         {
            _result = body;
            return true;
         }
         if(body is String)
         {
            if(resultFormat == RESULT_FORMAT_XML || resultFormat == RESULT_FORMAT_OBJECT || resultFormat == RESULT_FORMAT_ARRAY)
            {
               tmp = new XMLDocument();
               XMLDocument(tmp).ignoreWhite = true;
               try
               {
                  XMLDocument(tmp).parseXML(String(body));
               }
               catch(parseError:Error)
               {
                  fault = new Fault(ERROR_DECODING,parseError.message);
                  dispatchRpcEvent(FaultEvent.createEvent(fault,token,message));
                  return false;
               }
               if(resultFormat == RESULT_FORMAT_OBJECT || resultFormat == RESULT_FORMAT_ARRAY)
               {
                  if(xmlDecode != null)
                  {
                     decoded = xmlDecode(tmp);
                     if(decoded == null)
                     {
                        msg = resourceManager.getString("rpc","xmlDecodeReturnNull");
                        fault1 = new Fault(ERROR_DECODING,msg);
                        dispatchRpcEvent(FaultEvent.createEvent(fault1,token,message));
                     }
                  }
                  else
                  {
                     decoder = new SimpleXMLDecoder(makeObjectsBindable);
                     decoded = decoder.decodeXML(XMLNode(tmp));
                     if(decoded == null)
                     {
                        msg = resourceManager.getString("rpc","defaultDecoderFailed");
                        fault2 = new Fault(ERROR_DECODING,msg);
                        dispatchRpcEvent(FaultEvent.createEvent(fault2,token,message));
                     }
                  }
                  if(decoded == null)
                  {
                     return false;
                  }
                  if(makeObjectsBindable && getQualifiedClassName(decoded) == "Object")
                  {
                     decoded = new ObjectProxy(decoded);
                  }
                  else
                  {
                     ;
                  }
                  if(resultFormat == RESULT_FORMAT_ARRAY)
                  {
                     decoded = decodeArray(decoded);
                  }
                  _result = decoded;
               }
               else
               {
                  if(tmp.childNodes.length == 1)
                  {
                     tmp = tmp.firstChild;
                  }
                  _result = tmp;
               }
            }
            else if(resultFormat == RESULT_FORMAT_E4X)
            {
               try
               {
                  _result = new XML(String(body));
               }
               catch(error:Error)
               {
                  fault3 = new Fault(ERROR_DECODING,error.message);
                  dispatchRpcEvent(FaultEvent.createEvent(fault3,token,message));
                  return false;
               }
            }
            else if(resultFormat == RESULT_FORMAT_FLASHVARS)
            {
               _result = decodeParameterString(String(body));
            }
            else
            {
               _result = body;
            }
         }
         else
         {
            if(resultFormat == RESULT_FORMAT_ARRAY)
            {
               body = decodeArray(body);
            }
            _result = body;
         }
         return true;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get url() : String
      {
         return _url;
      }
      
      [Inspectable(enumeration="object,array,xml,flashvars,text,e4x",category="General")]
      public function get resultFormat() : String
      {
         return _resultFormat;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invoke(message:IMessage, token:AsyncToken = null) : AsyncToken
      {
         if(showBusyCursor)
         {
            CursorManager.setBusyCursor();
         }
         return super.invoke(message,token);
      }
      
      override public function cancel(id:String = null) : AsyncToken
      {
         if(showBusyCursor)
         {
            CursorManager.removeBusyCursor();
         }
         return super.cancel(id);
      }
   }
}

