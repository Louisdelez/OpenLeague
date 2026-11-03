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
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _httpHeaders:Object;
      
      private var _xmlSpecialCharsFilter:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var handleAxisSession:Boolean;
      
      private var _endpointURI:String;
      
      private var _forcePartArrays:Boolean = false;
      
      private var _headerFormat:String;
      
      private var _headers:Array;
      
      private var _resultFormat:String;
      
      private var _makeObjectsBindableSet:Boolean;
      
      private var _multiplePartsFormat:String;
      
      private var _decoder:ISOAPDecoder;
      
      private var _encoder:ISOAPEncoder;
      
      private var _ignoreWhitespace:Boolean = true;
      
      private var log:ILogger;
      
      private var pendingInvocations:Array;
      
      private var startTime:Date;
      
      private var timeout:int;
      
      private var webService:AbstractWebService;
      
      protected var _wsdlOperation:WSDLOperation;
      
      public function Operation(webService:AbstractService = null, name:String = null)
      {
         super(webService,name);
         this._resultFormat = "object";
         this._headerFormat = "e4x";
         this._headers = [];
         this.log = Log.getLogger("mx.rpc.soap.Operation");
         if(Boolean(webService))
         {
            this.webService = AbstractWebService(webService);
            this.log.info("Creating SOAP Operation for {0}",name);
         }
         this.timeout = -1;
      }
      
      public function get decoder() : ISOAPDecoder
      {
         if(this._decoder == null)
         {
            this._decoder = new SOAPDecoder();
            this._decoder.makeObjectsBindable = this.makeObjectsBindable;
            this._decoder.ignoreWhitespace = this.ignoreWhitespace;
         }
         if(this._decoder.wsdlOperation == null)
         {
            this._decoder.wsdlOperation = this.wsdlOperation;
         }
         return this._decoder;
      }
      
      public function set decoder(value:ISOAPDecoder) : void
      {
         this._decoder = value;
      }
      
      public function get encoder() : ISOAPEncoder
      {
         if(this._encoder == null)
         {
            this._encoder = new SOAPEncoder();
            this._encoder.ignoreWhitespace = this.ignoreWhitespace;
         }
         if(this._encoder.wsdlOperation == null)
         {
            this._encoder.wsdlOperation = this.wsdlOperation;
         }
         this._encoder.xmlSpecialCharsFilter = this.xmlSpecialCharsFilter;
         return this._encoder;
      }
      
      public function set encoder(value:ISOAPEncoder) : void
      {
         this._encoder = value;
      }
      
      public function get endpointURI() : String
      {
         return Boolean(this._endpointURI) ? this._endpointURI : this.webService.endpointURI;
      }
      
      public function set endpointURI(uri:String) : void
      {
         this._endpointURI = uri;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get forcePartArrays() : Boolean
      {
         return this._forcePartArrays;
      }
      
      public function set forcePartArrays(value:Boolean) : void
      {
         this._forcePartArrays = value;
      }
      
      [Inspectable(enumeration="object,e4x,xml,E4X,XML",defaultValue="e4x",category="General")]
      public function get headerFormat() : String
      {
         if(this._headerFormat == null)
         {
            this._headerFormat = "e4x";
         }
         return this._headerFormat;
      }
      
      public function set headerFormat(hf:String) : void
      {
         if(hf != null)
         {
            hf = hf.toLowerCase();
         }
         this._headerFormat = hf;
      }
      
      public function get headers() : Array
      {
         return this._headers;
      }
      
      [Inspectable(defaultValue="undefined",category="General")]
      public function get httpHeaders() : Object
      {
         if(this._httpHeaders != null)
         {
            return this._httpHeaders;
         }
         return AbstractWebService(service).httpHeaders;
      }
      
      public function set httpHeaders(value:Object) : void
      {
         this._httpHeaders = value;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      public function get ignoreWhitespace() : Boolean
      {
         return this._ignoreWhitespace;
      }
      
      public function set ignoreWhitespace(value:Boolean) : void
      {
         this._ignoreWhitespace = value;
         if(this._decoder != null)
         {
            this._decoder.ignoreWhitespace = this._ignoreWhitespace;
         }
         if(this._encoder != null)
         {
            this._encoder.ignoreWhitespace = this._ignoreWhitespace;
         }
      }
      
      [Inspectable(defaultValue="true",category="General")]
      override public function get makeObjectsBindable() : Boolean
      {
         if(this._makeObjectsBindableSet)
         {
            return _makeObjectsBindable;
         }
         return AbstractWebService(service).makeObjectsBindable;
      }
      
      override public function set makeObjectsBindable(value:Boolean) : void
      {
         _makeObjectsBindable = value;
         this._makeObjectsBindableSet = true;
         if(this._decoder != null)
         {
            this._decoder.makeObjectsBindable = value;
         }
      }
      
      [Inspectable(enumeration="object,array",defaultValue="object",category="General")]
      public function get multiplePartsFormat() : String
      {
         if(this._multiplePartsFormat == null)
         {
            if(this._wsdlOperation != null && this._wsdlOperation.style == "rpc")
            {
               this._multiplePartsFormat = "array";
            }
            else
            {
               this._multiplePartsFormat = "object";
            }
         }
         return this._multiplePartsFormat;
      }
      
      public function set multiplePartsFormat(value:String) : void
      {
         if(value != null)
         {
            value = value.toLowerCase();
         }
         this._multiplePartsFormat = value;
      }
      
      public function get request() : Object
      {
         return this.arguments;
      }
      
      public function set request(r:Object) : void
      {
         this.arguments = r;
      }
      
      [Inspectable(enumeration="object,e4x,xml,E4X,XML",defaultValue="object",category="General")]
      public function get resultFormat() : String
      {
         if(this._resultFormat == null)
         {
            this._resultFormat = "object";
         }
         return this._resultFormat;
      }
      
      public function set resultFormat(rf:String) : void
      {
         if(rf != null)
         {
            rf = rf.toLowerCase();
         }
         this._resultFormat = rf;
      }
      
      [Bindable("resultForBinding")]
      public function get resultHeaders() : Array
      {
         return _responseHeaders;
      }
      
      public function get xmlSpecialCharsFilter() : Function
      {
         if(this._xmlSpecialCharsFilter != null)
         {
            return this._xmlSpecialCharsFilter;
         }
         return AbstractWebService(service).xmlSpecialCharsFilter;
      }
      
      public function set xmlSpecialCharsFilter(func:Function) : void
      {
         this._xmlSpecialCharsFilter = func;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get wsdlOperation() : WSDLOperation
      {
         return this._wsdlOperation;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set wsdlOperation(value:WSDLOperation) : void
      {
         this._wsdlOperation = value;
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
      
      override public function cancel(id:String = null) : AsyncToken
      {
         var i:int = 0;
         var pc:OperationPendingCall = null;
         if(this.hasPendingInvocations())
         {
            if(null == id)
            {
               return this.pendingInvocations.pop().token;
            }
            for(i = this.pendingInvocations.length - 1; i >= 0; i--)
            {
               if(this.pendingInvocations[i].token.message != null && this.pendingInvocations[i].token.message.messageId == id)
               {
                  pc = this.pendingInvocations.splice(i,1)[0];
                  return pc.token;
               }
            }
         }
         return super.cancel(id);
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
      
      override public function send(... args) : AsyncToken
      {
         if(service != null)
         {
            service.initialize();
         }
         if(this.webService.convertParametersHandler != null)
         {
            args = this.webService.convertParametersHandler(args);
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
         if(Boolean(this._headers))
         {
            combinedHeaders = combinedHeaders.concat(this._headers);
         }
         if(Boolean(this.webService.headers))
         {
            combinedHeaders = combinedHeaders.concat(this.webService.headers);
         }
         var message:SOAPMessage = new SOAPMessage();
         var token:AsyncToken = new AsyncToken(message);
         var pc:OperationPendingCall = new OperationPendingCall(argsToPass,combinedHeaders,token);
         if(this.webService.ready)
         {
            this.invokePendingCall(pc);
         }
         else
         {
            this.log.debug("Queueing SOAP operation {0}",name);
            if(!this.pendingInvocations)
            {
               this.pendingInvocations = [];
            }
            this.pendingInvocations.push(pc);
         }
         return pc.token;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hasPendingInvocations() : Boolean
      {
         return this.pendingInvocations != null && this.pendingInvocations.length > 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invokeAllPending() : void
      {
         var i:int = 0;
         if(this.hasPendingInvocations())
         {
            for(i = 0; i < this.pendingInvocations.length; i++)
            {
               this.invokePendingCall(this.pendingInvocations[i]);
            }
            this.pendingInvocations = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invokePendingCall(pc:OperationPendingCall) : void
      {
         var message:SOAPMessage;
         var soap:XML = null;
         var errorMsg:String = null;
         var fault2:Fault = null;
         var faultEvent:FaultEvent = null;
         this.log.debug("Invoking SOAP operation {0}",name);
         this.startTime = new Date();
         message = SOAPMessage(pc.token.message);
         if(this.wsdlOperation == null)
         {
            this.log.debug("No operation found {0}",name);
            dispatchRpcEvent(this.createFaultEvent("Client.NoSuchMethod","Couldn\'t find method \'" + name + "\' in service."));
            return;
         }
         try
         {
            soap = this.encoder.encodeRequest(pc.args,pc.headers);
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
         message.httpHeaders = this.httpHeaders;
         if(message.getSOAPAction() == null)
         {
            message.setSOAPAction(this.wsdlOperation.soapAction);
         }
         message.body = soap.toXMLString();
         message.url = this.endpointURI;
         if(NetworkMonitor.isMonitoring())
         {
            message.recordHeaders = true;
         }
         invoke(message,pc.token);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processFault(message:IMessage, token:AsyncToken) : Boolean
      {
         var dispatchFaultEvent:Boolean = true;
         if(message != null && message.body != null)
         {
            dispatchFaultEvent = this.processSOAP(message,token);
         }
         return dispatchFaultEvent;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processResult(message:IMessage, token:AsyncToken) : Boolean
      {
         if(this.processSOAP(message,token))
         {
            if(this.webService.convertResultHandler != null)
            {
               _result = this.webService.convertResultHandler(_result,this);
            }
            return true;
         }
         return false;
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
            this.decoder.resultFormat = this.resultFormat;
            this.decoder.headerFormat = this.headerFormat;
            this.decoder.multiplePartsFormat = this.multiplePartsFormat;
            this.decoder.forcePartArrays = this.forcePartArrays;
            soapResult = this.decoder.decodeResponse(stringResult);
            _result = null;
            _responseHeaders = soapResult.headers;
            eventDispatchRequired = this.processHeaders(_responseHeaders,token,message);
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
                        msg = this.resourceManager.getString("rpc","noListenerForHeader",[headerQName]);
                        fault = new Fault("Client.MustUnderstand",msg);
                        faultEvent = FaultEvent.createEvent(fault,token,message);
                        dispatchRpcEvent(faultEvent);
                        return false;
                     }
                  }
                  if(this.handleAxisSession)
                  {
                     if(headerQName != null && headerQName.localName == "sessionID" && headerQName.uri == "http://xml.apache.org/axis/session")
                     {
                        newHeader = new SOAPHeader(headerQName,headerContent);
                        this.webService.addHeader(newHeader);
                     }
                  }
                  headerEvent = HeaderEvent.createEvent(header,token,message);
                  dispatchRpcEvent(headerEvent);
               }
            }
         }
         return true;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(value:AbstractService) : void
      {
         super.setService(value);
         this.webService = AbstractWebService(value);
      }
      
      protected function createFaultEvent(faultCode:String = null, faultString:String = null, faultDetail:String = null) : FaultEvent
      {
         var fault:Fault = new Fault(faultCode,faultString,faultDetail);
         return FaultEvent.createEvent(fault);
      }
   }
}

import mx.rpc.AsyncToken;

class OperationPendingCall
{
   
   public var args:*;
   
   public var headers:Array;
   
   public var token:AsyncToken;
   
   public function OperationPendingCall(args:*, headers:Array, token:AsyncToken)
   {
      super();
      this.args = args;
      this.headers = headers;
      this.token = token;
   }
}
