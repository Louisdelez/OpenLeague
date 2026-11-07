package mx.rpc.soap
{
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.messages.IMessage;
   import mx.messaging.messages.SOAPMessage;
   import mx.netmon.NetworkMonitor;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractOperation;
   import mx.rpc.AbstractService;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.HeaderEvent;
   import mx.rpc.wsdl.WSDLOperation;
   import mx.utils.XMLUtil;
   
   [ResourceBundle("rpc")]
   [Event(name="header",type="mx.rpc.events.HeaderEvent")]
   public class Operation extends AbstractOperation
   {
      
      private var _decoder:ISOAPDecoder;
      
      private var _forcePartArrays:Boolean = false;
      
      private var _httpHeaders:Object;
      
      private var _xmlSpecialCharsFilter:Function;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _multiplePartsFormat:String;
      
      private var _headerFormat:String;
      
      private var _makeObjectsBindableSet:Boolean;
      
      private var pendingInvocations:Array;
      
      private var startTime:Date;
      
      private var webService:AbstractWebService;
      
      private var _resultFormat:String;
      
      private var _ignoreWhitespace:Boolean = true;
      
      private var _headers:Array;
      
      private var log:ILogger;
      
      private var _encoder:ISOAPEncoder;
      
      private var _endpointURI:String;
      
      private var timeout:int;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var handleAxisSession:Boolean;
      
      protected var _wsdlOperation:WSDLOperation;
      
      public function Operation(webService:AbstractService = null, name:String = null)
      {
         super(webService,name);
         _resultFormat = "object";
         _headerFormat = "e4x";
         _headers = [];
         log = Log.getLogger("mx.rpc.soap.Operation");
         if(Boolean(webService))
         {
            this.webService = AbstractWebService(webService);
            log.info("Creating SOAP Operation for {0}",name);
         }
         timeout = -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processSOAP(message:IMessage, token:AsyncToken) : Boolean
      {
         var body:Object = null;
         var stringResult:String = null;
         var soapResult:SOAPResult = null;
         var faults:Array = null;
         var soapFault:Fault = null;
         var errorMsg:String = null;
         var fault2:Fault = null;
         var faultEvent:FaultEvent = null;
         body = message.body;
         var eventDispatchRequired:Boolean = true;
         try
         {
            stringResult = String(body);
            decoder.resultFormat = resultFormat;
            decoder.headerFormat = headerFormat;
            decoder.multiplePartsFormat = multiplePartsFormat;
            decoder.forcePartArrays = forcePartArrays;
            soapResult = decoder.decodeResponse(stringResult);
            _result = null;
            _responseHeaders = soapResult.headers;
            eventDispatchRequired = processHeaders(_responseHeaders,token,message);
            if(soapResult.isFault)
            {
               faults = soapResult.result as Array;
               for each(soapFault in faults)
               {
                  soapFault.content = body;
                  dispatchRpcEvent(FaultEvent.createEvent(soapFault,token,message));
               }
               eventDispatchRequired = false;
            }
            if(eventDispatchRequired)
            {
               _result = soapResult.result;
            }
         }
         catch(fault:Fault)
         {
            fault.content = body;
            dispatchRpcEvent(FaultEvent.createEvent(fault,token,message));
            eventDispatchRequired = false;
         }
         catch(error:Error)
         {
            errorMsg = error.message != null ? error.message : "";
            fault2 = new Fault("DecodingError",errorMsg);
            fault2.content = body;
            faultEvent = FaultEvent.createEvent(fault2,token,message);
            dispatchRpcEvent(faultEvent);
            eventDispatchRequired = false;
         }
         return eventDispatchRequired;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(value:AbstractService) : void
      {
         super.setService(value);
         webService = AbstractWebService(value);
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
      
      [Inspectable(defaultValue="true",category="General")]
      override public function get makeObjectsBindable() : Boolean
      {
         if(_makeObjectsBindableSet)
         {
            return _makeObjectsBindable;
         }
         return AbstractWebService(service).makeObjectsBindable;
      }
      
      public function get headers() : Array
      {
         return _headers;
      }
      
      public function set decoder(value:ISOAPDecoder) : void
      {
         _decoder = value;
      }
      
      override public function set makeObjectsBindable(value:Boolean) : void
      {
         _makeObjectsBindable = value;
         _makeObjectsBindableSet = true;
         if(_decoder != null)
         {
            _decoder.makeObjectsBindable = value;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hasPendingInvocations() : Boolean
      {
         return pendingInvocations != null && pendingInvocations.length > 0;
      }
      
      public function set multiplePartsFormat(value:String) : void
      {
         if(value != null)
         {
            value = value.toLowerCase();
         }
         _multiplePartsFormat = value;
      }
      
      public function get request() : Object
      {
         return this.arguments;
      }
      
      public function addHeader(header:Object) : void
      {
         _headers.push(header);
      }
      
      protected function processHeaders(responseHeaders:Array, token:AsyncToken, message:IMessage) : Boolean
      {
         var i:uint = 0;
         var header:Object = null;
         var mustUnderstand:Boolean = false;
         var headerQName:QName = null;
         var headerContent:Object = null;
         var headerXML:XML = null;
         var headerEvent:HeaderEvent = null;
         var msg:String = null;
         var fault:Fault = null;
         var faultEvent:FaultEvent = null;
         var newHeader:SOAPHeader = null;
         if(responseHeaders != null)
         {
            for(i = 0; i < responseHeaders.length; i++)
            {
               header = responseHeaders[i];
               if(header is XML)
               {
                  headerXML = header as XML;
                  mustUnderstand = headerXML.@mustUnderstand == "1" ? true : false;
                  headerQName = headerXML.name();
                  if(headerXML.hasComplexContent())
                  {
                     headerContent = headerXML.elements();
                  }
                  else
                  {
                     headerContent = headerXML.text();
                  }
               }
               else if(header is SOAPHeader)
               {
                  mustUnderstand = Boolean(header.mustUnderstand);
                  headerQName = header.qname;
                  headerContent = header.content;
               }
               if(headerQName != null)
               {
                  if(mustUnderstand == true)
                  {
                     if(!hasEventListener(HeaderEvent.HEADER) && !service.hasEventListener(HeaderEvent.HEADER))
                     {
                        msg = resourceManager.getString("rpc","noListenerForHeader",[headerQName]);
                        fault = new Fault("Client.MustUnderstand",msg);
                        faultEvent = FaultEvent.createEvent(fault,token,message);
                        dispatchRpcEvent(faultEvent);
                        return false;
                     }
                  }
                  if(handleAxisSession)
                  {
                     if(headerQName != null && headerQName.localName == "sessionID" && headerQName.uri == "http://xml.apache.org/axis/session")
                     {
                        newHeader = new SOAPHeader(headerQName,headerContent);
                        webService.addHeader(newHeader);
                     }
                  }
                  headerEvent = HeaderEvent.createEvent(header,token,message);
                  dispatchRpcEvent(headerEvent);
               }
            }
         }
         return true;
      }
      
      public function get encoder() : ISOAPEncoder
      {
         if(_encoder == null)
         {
            _encoder = new SOAPEncoder();
            _encoder.ignoreWhitespace = ignoreWhitespace;
         }
         if(_encoder.wsdlOperation == null)
         {
            _encoder.wsdlOperation = wsdlOperation;
         }
         _encoder.xmlSpecialCharsFilter = xmlSpecialCharsFilter;
         return _encoder;
      }
      
      public function get endpointURI() : String
      {
         return Boolean(_endpointURI) ? _endpointURI : webService.endpointURI;
      }
      
      public function addSimpleHeader(qnameLocal:String, qnameNamespace:String, headerName:String, headerValue:String) : void
      {
         var obj:Object = {};
         obj[headerName] = headerValue;
         addHeader(new SOAPHeader(new QName(qnameNamespace,qnameLocal),obj));
      }
      
      public function set request(r:Object) : void
      {
         this.arguments = r;
      }
      
      [Bindable("resultForBinding")]
      public function get resultHeaders() : Array
      {
         return _responseHeaders;
      }
      
      override public function send(... args) : AsyncToken
      {
         if(service != null)
         {
            service.initialize();
         }
         if(webService.convertParametersHandler != null)
         {
            args = webService.convertParametersHandler(args);
         }
         if(operationManager != null)
         {
            return operationManager(args);
         }
         var argsToPass:Object = null;
         if(Boolean(args) && args.length > 0)
         {
            if(args.length == 1 && (args[0] is XMLNode || args[0] is XML))
            {
               argsToPass = args[0];
            }
            else
            {
               argsToPass = args;
            }
         }
         else if(Boolean(this.arguments))
         {
            argsToPass = this.arguments;
         }
         var combinedHeaders:Array = [];
         if(Boolean(_headers))
         {
            combinedHeaders = combinedHeaders.concat(_headers);
         }
         if(Boolean(webService.headers))
         {
            combinedHeaders = combinedHeaders.concat(webService.headers);
         }
         var message:SOAPMessage = new SOAPMessage();
         var token:AsyncToken = new AsyncToken(message);
         var pc:OperationPendingCall = new OperationPendingCall(argsToPass,combinedHeaders,token);
         if(webService.ready)
         {
            invokePendingCall(pc);
         }
         else
         {
            log.debug("Queueing SOAP operation {0}",name);
            if(!pendingInvocations)
            {
               pendingInvocations = [];
            }
            pendingInvocations.push(pc);
         }
         return pc.token;
      }
      
      public function set endpointURI(uri:String) : void
      {
         _endpointURI = uri;
      }
      
      public function set forcePartArrays(value:Boolean) : void
      {
         _forcePartArrays = value;
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
      
      public function get xmlSpecialCharsFilter() : Function
      {
         if(_xmlSpecialCharsFilter != null)
         {
            return _xmlSpecialCharsFilter;
         }
         return AbstractWebService(service).xmlSpecialCharsFilter;
      }
      
      public function set encoder(value:ISOAPEncoder) : void
      {
         _encoder = value;
      }
      
      protected function createFaultEvent(faultCode:String = null, faultString:String = null, faultDetail:String = null) : FaultEvent
      {
         var fault:Fault = new Fault(faultCode,faultString,faultDetail);
         return FaultEvent.createEvent(fault);
      }
      
      public function set httpHeaders(value:Object) : void
      {
         _httpHeaders = value;
      }
      
      public function get decoder() : ISOAPDecoder
      {
         if(_decoder == null)
         {
            _decoder = new SOAPDecoder();
            _decoder.makeObjectsBindable = makeObjectsBindable;
            _decoder.ignoreWhitespace = ignoreWhitespace;
         }
         if(_decoder.wsdlOperation == null)
         {
            _decoder.wsdlOperation = wsdlOperation;
         }
         return _decoder;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set wsdlOperation(value:WSDLOperation) : void
      {
         _wsdlOperation = value;
      }
      
      [Inspectable(enumeration="object,array",defaultValue="object",category="General")]
      public function get multiplePartsFormat() : String
      {
         if(_multiplePartsFormat == null)
         {
            if(_wsdlOperation != null && _wsdlOperation.style == "rpc")
            {
               _multiplePartsFormat = "array";
            }
            else
            {
               _multiplePartsFormat = "object";
            }
         }
         return _multiplePartsFormat;
      }
      
      public function set headerFormat(hf:String) : void
      {
         if(hf != null)
         {
            hf = hf.toLowerCase();
         }
         _headerFormat = hf;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invokeAllPending() : void
      {
         var i:int = 0;
         if(hasPendingInvocations())
         {
            for(i = 0; i < pendingInvocations.length; i++)
            {
               invokePendingCall(pendingInvocations[i]);
            }
            pendingInvocations = null;
         }
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get forcePartArrays() : Boolean
      {
         return _forcePartArrays;
      }
      
      public function set ignoreWhitespace(value:Boolean) : void
      {
         _ignoreWhitespace = value;
         if(_decoder != null)
         {
            _decoder.ignoreWhitespace = _ignoreWhitespace;
         }
         if(_encoder != null)
         {
            _encoder.ignoreWhitespace = _ignoreWhitespace;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get wsdlOperation() : WSDLOperation
      {
         return _wsdlOperation;
      }
      
      [Inspectable(enumeration="object,e4x,xml,E4X,XML",defaultValue="e4x",category="General")]
      public function get headerFormat() : String
      {
         if(_headerFormat == null)
         {
            _headerFormat = "e4x";
         }
         return _headerFormat;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get httpHeaders() : Object
      {
         if(_httpHeaders != null)
         {
            return _httpHeaders;
         }
         return AbstractWebService(service).httpHeaders;
      }
      
      public function set xmlSpecialCharsFilter(func:Function) : void
      {
         _xmlSpecialCharsFilter = func;
      }
      
      public function set resultFormat(rf:String) : void
      {
         if(rf != null)
         {
            rf = rf.toLowerCase();
         }
         _resultFormat = rf;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processResult(message:IMessage, token:AsyncToken) : Boolean
      {
         if(processSOAP(message,token))
         {
            if(webService.convertResultHandler != null)
            {
               _result = webService.convertResultHandler(_result,this);
            }
            return true;
         }
         return false;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      public function get ignoreWhitespace() : Boolean
      {
         return _ignoreWhitespace;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processFault(message:IMessage, token:AsyncToken) : Boolean
      {
         var dispatchFaultEvent:Boolean = true;
         if(message != null && message.body != null)
         {
            dispatchFaultEvent = processSOAP(message,token);
         }
         return dispatchFaultEvent;
      }
      
      [Inspectable(enumeration="object,e4x,xml,E4X,XML",defaultValue="object",category="General")]
      public function get resultFormat() : String
      {
         if(_resultFormat == null)
         {
            _resultFormat = "object";
         }
         return _resultFormat;
      }
      
      public function clearHeaders() : void
      {
         _headers.length = 0;
      }
      
      override public function cancel(id:String = null) : AsyncToken
      {
         var i:int = 0;
         var pc:OperationPendingCall = null;
         if(hasPendingInvocations())
         {
            if(null == id)
            {
               return pendingInvocations.pop().token;
            }
            for(i = pendingInvocations.length - 1; i >= 0; i--)
            {
               if(pendingInvocations[i].token.message != null && pendingInvocations[i].token.message.messageId == id)
               {
                  pc = pendingInvocations.splice(i,1)[0];
                  return pc.token;
               }
            }
         }
         return super.cancel(id);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invokePendingCall(pc:OperationPendingCall) : void
      {
         var message:SOAPMessage;
         var soap:XML = null;
         var errorMsg:String = null;
         var fault2:Fault = null;
         var faultEvent:FaultEvent = null;
         log.debug("Invoking SOAP operation {0}",name);
         startTime = new Date();
         message = SOAPMessage(pc.token.message);
         if(wsdlOperation == null)
         {
            log.debug("No operation found {0}",name);
            dispatchRpcEvent(createFaultEvent("Client.NoSuchMethod","Couldn\'t find method \'" + name + "\' in service."));
            return;
         }
         try
         {
            soap = encoder.encodeRequest(pc.args,pc.headers);
         }
         catch(fault:Fault)
         {
            dispatchRpcEvent(FaultEvent.createEvent(fault));
            return;
         }
         catch(error:Error)
         {
            errorMsg = Boolean(error.message) ? error.message : "";
            fault2 = new Fault("EncodingError",errorMsg);
            faultEvent = FaultEvent.createEvent(fault2);
            dispatchRpcEvent(faultEvent);
            return;
         }
         message.httpHeaders = httpHeaders;
         if(message.getSOAPAction() == null)
         {
            message.setSOAPAction(wsdlOperation.soapAction);
         }
         message.body = soap.toXMLString();
         message.url = endpointURI;
         if(NetworkMonitor.isMonitoring())
         {
            message.recordHeaders = true;
         }
         invoke(message,pc.token);
      }
   }
}

import mx.rpc.AsyncToken;

class OperationPendingCall
{
   
   public var headers:Array;
   
   public var token:AsyncToken;
   
   public var args:*;
   
   public function OperationPendingCall(args:*, headers:Array, token:AsyncToken)
   {
      super();
      this.args = args;
      this.headers = headers;
      this.token = token;
   }
}
