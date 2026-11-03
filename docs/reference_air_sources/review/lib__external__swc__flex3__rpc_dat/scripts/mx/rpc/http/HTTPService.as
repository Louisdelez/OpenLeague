package mx.rpc.http
{
   import mx.messaging.ChannelSet;
   import mx.messaging.config.LoaderConfig;
   import mx.rpc.AbstractInvoker;
   import mx.rpc.AsyncRequest;
   import mx.rpc.AsyncToken;
   import mx.utils.URLUtil;
   
   [ResourceBundle("rpc")]
   [Event(name="invoke",type="mx.rpc.events.InvokeEvent")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   [Event(name="result",type="mx.rpc.events.ResultEvent")]
   public class HTTPService extends AbstractInvoker
   {
      
      public static const RESULT_FORMAT_E4X:String = "e4x";
      
      public static const RESULT_FORMAT_FLASHVARS:String = "flashvars";
      
      public static const RESULT_FORMAT_OBJECT:String = "object";
      
      public static const RESULT_FORMAT_ARRAY:String = "array";
      
      public static const RESULT_FORMAT_TEXT:String = "text";
      
      public static const RESULT_FORMAT_XML:String = "xml";
      
      public static const CONTENT_TYPE_XML:String = "application/xml";
      
      public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
      
      public static const DEFAULT_DESTINATION_HTTP:String = "DefaultHTTP";
      
      public static const DEFAULT_DESTINATION_HTTPS:String = "DefaultHTTPS";
      
      public static const ERROR_URL_REQUIRED:String = "Client.URLRequired";
      
      public static const ERROR_DECODING:String = "Client.CouldNotDecode";
      
      public static const ERROR_ENCODING:String = "Client.CouldNotEncode";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var operation:AbstractOperation;
      
      public function HTTPService(rootURL:String = null, destination:String = null)
      {
         super();
         operation = new HTTPOperation(this);
         operation.makeObjectsBindable = true;
         operation._rootURL = rootURL;
         if(destination == null)
         {
            if(URLUtil.isHttpsURL(LoaderConfig.url))
            {
               asyncRequest.destination = DEFAULT_DESTINATION_HTTPS;
            }
            else
            {
               asyncRequest.destination = DEFAULT_DESTINATION_HTTP;
            }
         }
         else
         {
            asyncRequest.destination = destination;
            useProxy = true;
         }
      }
      
      public function setCredentials(username:String, password:String, charset:String = null) : void
      {
         asyncRequest.setCredentials(username,password,charset);
      }
      
      public function set method(m:String) : void
      {
         operation.method = m;
      }
      
      public function logout() : void
      {
         asyncRequest.logout();
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get headers() : Object
      {
         return operation.headers;
      }
      
      public function get serializationFilter() : SerializationFilter
      {
         return operation.serializationFilter;
      }
      
      override public function cancel(id:String = null) : AsyncToken
      {
         return operation.cancel(id);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         operation.removeEventListener(type,listener,useCapture);
         super.removeEventListener(type,listener,useCapture);
      }
      
      public function set headers(r:Object) : void
      {
         operation.headers = r;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         operation.addEventListener(type,listener,useCapture,priority,useWeakReference);
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get request() : Object
      {
         return operation.request;
      }
      
      public function set serializationFilter(s:SerializationFilter) : void
      {
         operation.serializationFilter = s;
      }
      
      [Inspectable(category="General")]
      public function get requestTimeout() : int
      {
         return asyncRequest.requestTimeout;
      }
      
      [Inspectable(enumeration="application/x-www-form-urlencoded,application/xml",defaultValue="application/x-www-form-urlencoded",category="General")]
      public function get contentType() : String
      {
         return operation.contentType;
      }
      
      [Inspectable(defaultValue="DefaultHTTP",category="General")]
      public function get destination() : String
      {
         return asyncRequest.destination;
      }
      
      public function send(parameters:Object = null) : AsyncToken
      {
         if(parameters == null)
         {
            parameters = request;
         }
         return operation.sendBody(parameters);
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         operation.showBusyCursor = sbc;
      }
      
      public function set xmlDecode(u:Function) : void
      {
         operation.xmlDecode = u;
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         return operation.concurrency;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get showBusyCursor() : Boolean
      {
         return operation.showBusyCursor;
      }
      
      public function set destination(value:String) : void
      {
         useProxy = true;
         asyncRequest.destination = value;
      }
      
      public function set useProxy(u:Boolean) : void
      {
         operation.useProxy = u;
      }
      
      public function set request(r:Object) : void
      {
         operation.request = r;
      }
      
      public function get channelSet() : ChannelSet
      {
         return asyncRequest.channelSet;
      }
      
      [Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete",defaultValue="GET",category="General")]
      public function get method() : String
      {
         return operation.method;
      }
      
      [Bindable("resultForBinding")]
      override public function get lastResult() : Object
      {
         return operation.lastResult;
      }
      
      public function disconnect() : void
      {
         asyncRequest.disconnect();
      }
      
      public function set requestTimeout(value:int) : void
      {
         if(asyncRequest.requestTimeout != value)
         {
            asyncRequest.requestTimeout = value;
         }
      }
      
      public function set url(u:String) : void
      {
         operation.url = u;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set asyncRequest(ar:AsyncRequest) : void
      {
         operation.asyncRequest = ar;
      }
      
      public function set resultFormat(rf:String) : void
      {
         operation.resultFormat = rf;
      }
      
      public function set rootURL(ru:String) : void
      {
         operation.rootURL = ru;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get xmlDecode() : Function
      {
         return operation.xmlDecode;
      }
      
      public function set concurrency(c:String) : void
      {
         operation.concurrency = c;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get useProxy() : Boolean
      {
         return operation.useProxy;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get url() : String
      {
         return operation.url;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get xmlEncode() : Function
      {
         return operation.xmlEncode;
      }
      
      public function set xmlEncode(u:Function) : void
      {
         operation.xmlEncode = u;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get asyncRequest() : AsyncRequest
      {
         return operation.asyncRequest;
      }
      
      [Inspectable(enumeration="object,array,xml,flashvars,text,e4x",defaultValue="object",category="General")]
      public function get resultFormat() : String
      {
         return operation.resultFormat;
      }
      
      public function set contentType(c:String) : void
      {
         operation.contentType = c;
      }
      
      public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String = null) : void
      {
         asyncRequest.setRemoteCredentials(remoteUsername,remotePassword,charset);
      }
      
      override public function clearResult(fireBindingEvent:Boolean = true) : void
      {
         operation.clearResult(fireBindingEvent);
      }
      
      override public function set makeObjectsBindable(b:Boolean) : void
      {
         operation.makeObjectsBindable = b;
      }
      
      public function get rootURL() : String
      {
         return operation.rootURL;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      override public function get makeObjectsBindable() : Boolean
      {
         return operation.makeObjectsBindable;
      }
      
      public function set channelSet(value:ChannelSet) : void
      {
         useProxy = true;
         asyncRequest.channelSet = value;
      }
   }
}

import mx.rpc.AbstractService;
import mx.rpc.events.AbstractEvent;
import mx.rpc.http.AbstractOperation;
import mx.rpc.http.HTTPService;

class HTTPOperation extends AbstractOperation
{
   
   private var _httpService:HTTPService;
   
   public function HTTPOperation(httpService:HTTPService, name:String = null)
   {
      super(null,name);
      this._httpService = httpService;
   }
   
   override public function get service() : AbstractService
   {
      _log.warn("Attempted access to HTTPOperation.service. To get the containing HTTPService instance, use HTTPOperation.httpService");
      return null;
   }
   
   public function get httpService() : HTTPService
   {
      return _httpService;
   }
   
   override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchRpcEvent(event:AbstractEvent) : void
   {
      if(hasEventListener(event.type))
      {
         event.callTokenResponders();
         if(!event.isDefaultPrevented())
         {
            dispatchEvent(event);
         }
      }
      else if(httpService != null)
      {
         httpService.dispatchRpcEvent(event);
      }
      else
      {
         event.callTokenResponders();
      }
   }
}
