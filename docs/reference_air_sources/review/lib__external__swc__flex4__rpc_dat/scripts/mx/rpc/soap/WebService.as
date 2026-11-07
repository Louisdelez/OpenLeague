package mx.rpc.soap
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractOperation;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.WSDLLoadEvent;
   import mx.rpc.http.HTTPService;
   import mx.rpc.wsdl.WSDL;
   import mx.rpc.wsdl.WSDLLoader;
   import mx.rpc.wsdl.WSDLOperation;
   import mx.rpc.wsdl.WSDLPort;
   import mx.utils.URLUtil;
   
   [ResourceBundle("rpc")]
   [Event(name="load",type="mx.rpc.soap.LoadEvent")]
   public dynamic class WebService extends AbstractWebService
   {
      
      public static const DEFAULT_DESTINATION_HTTP:String = "DefaultHTTP";
      
      public static const DEFAULT_DESTINATION_HTTPS:String = "DefaultHTTPS";
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _wsdlURL:String;
      
      private var _log:ILogger;
      
      private var _wsdlFault:Boolean;
      
      private var _wsdl:WSDL;
      
      private var _wsdlLoader:WSDLLoader;
      
      public function WebService(destination:String = null, rootURL:String = null)
      {
         super(destination,rootURL);
         _ready = false;
         this._log = Log.getLogger("mx.rpc.soap.WebService");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get wsdlFault() : Boolean
      {
         return this._wsdlFault;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      public function get wsdl() : String
      {
         return this._wsdlURL;
      }
      
      public function set wsdl(w:String) : void
      {
         this._wsdlURL = w;
      }
      
      public function canLoadWSDL() : Boolean
      {
         if(Boolean(this.wsdl))
         {
            return true;
         }
         if(destination != DEFAULT_DESTINATION_HTTP && destination != DEFAULT_DESTINATION_HTTPS)
         {
            return true;
         }
         return false;
      }
      
      override public function getOperation(name:String) : AbstractOperation
      {
         var op:AbstractOperation = super.getOperation(name);
         if(op == null)
         {
            op = new Operation(this,name);
            _operations[name] = op;
            op.asyncRequest = asyncRequest;
            this.initializeOperation(op as Operation);
         }
         return op;
      }
      
      public function loadWSDL(uri:String = null) : void
      {
         var message:String = null;
         var fault:Fault = null;
         var fault1:Fault = null;
         if(uri != null)
         {
            this.wsdl = uri;
         }
         if(!this.wsdl)
         {
            if(!useProxy)
            {
               message = this.resourceManager.getString("rpc","mustSpecifyWSDLLocation");
               fault = new Fault("Client.WSDL",message);
               dispatchEvent(FaultEvent.createEvent(fault));
               return;
            }
            if(destination == null || !destinationSet || destination == DEFAULT_DESTINATION_HTTP || destination == DEFAULT_DESTINATION_HTTPS)
            {
               message = this.resourceManager.getString("rpc","destinationOrWSDLNotSpecified");
               fault1 = new Fault("Client.WSDL",message);
               dispatchEvent(FaultEvent.createEvent(fault1));
               return;
            }
         }
         if(!destinationSet && URLUtil.isHttpsURL(this.wsdl))
         {
            asyncRequest.destination = DEFAULT_DESTINATION_HTTPS;
            destinationSet = true;
         }
         this._wsdlLoader = new WSDLLoader(this.deriveHTTPService());
         this._wsdlLoader.addEventListener(WSDLLoadEvent.LOAD,this.wsdlHandler);
         this._wsdlLoader.addEventListener(FaultEvent.FAULT,this.wsdlFaultHandler);
         this._wsdlFault = false;
         this._wsdlLoader.load(this.wsdl);
      }
      
      public function toString() : String
      {
         var s:String = "[WebService ";
         s += " destination=\"" + destination + "\"";
         if(Boolean(this.wsdl))
         {
            s += " wsdl=\"" + this.wsdl + "\"";
         }
         return s + (" channelSet=\"" + channelSet + "\"]");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function wsdlFaultHandler(event:FaultEvent) : void
      {
         this._wsdlFault = true;
         dispatchEvent(event);
         unEnqueueCalls(event.fault);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function wsdlHandler(event:WSDLLoadEvent) : void
      {
         var wsdlPort:WSDLPort = null;
         var op:Operation = null;
         var loadEvent:LoadEvent = null;
         var faultEvent:FaultEvent = null;
         var errorMessage:String = null;
         var message:String = null;
         var fault:Fault = null;
         var faultEvent2:FaultEvent = null;
         this._log.debug("WSDL loaded");
         this._wsdl = event.wsdl;
         try
         {
            wsdlPort = this._wsdl.getPort(service,port);
            _endpointURI = wsdlPort.endpointURI;
            if(!URLUtil.isHttpURL(_endpointURI) && event.location != null)
            {
               _endpointURI = URLUtil.getFullURL(event.location,_endpointURI);
            }
            _service = wsdlPort.service.name;
            _port = wsdlPort.name;
            for each(op in _operations)
            {
               this.initializeOperation(op);
            }
            _ready = true;
            loadEvent = LoadEvent.createEvent(event.wsdl,event.location);
            dispatchEvent(loadEvent);
            unEnqueueCalls();
         }
         catch(fault:Fault)
         {
            faultEvent = FaultEvent.createEvent(fault);
            dispatchEvent(faultEvent);
            super.unEnqueueCalls(fault);
            return;
         }
         catch(error:Error)
         {
            errorMessage = Boolean(error.message) ? error.message : "";
            message = resourceManager.getString("rpc","unexpectedException",[errorMessage]);
            fault = new Fault("WSDLError",message);
            fault.rootCause = error;
            faultEvent2 = FaultEvent.createEvent(fault);
            dispatchEvent(faultEvent2);
            super.unEnqueueCalls(fault);
            return;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function deriveHTTPService() : HTTPService
      {
         var httpService:HTTPService = new HTTPService();
         httpService.asyncRequest = asyncRequest;
         if(Boolean(destination))
         {
            httpService.destination = destination;
         }
         httpService.useProxy = useProxy;
         httpService.resultFormat = HTTPService.RESULT_FORMAT_XML;
         httpService.rootURL = rootURL;
         httpService.headers = httpHeaders;
         return httpService;
      }
      
      protected function initializeOperation(operation:Operation) : void
      {
         var wsdlOp:WSDLOperation = null;
         if(this._wsdl != null)
         {
            wsdlOp = this._wsdl.getOperation(operation.name,service,port);
            if(operation.endpointURI == null)
            {
               operation.endpointURI = endpointURI;
            }
            operation.wsdlOperation = wsdlOp;
         }
      }
      
      private function dispatchFault(faultCode:String, faultString:String, faultDetail:String = null) : void
      {
         var fault:Fault = new Fault(faultCode,faultString,faultDetail);
         var event:FaultEvent = FaultEvent.createEvent(fault);
         dispatchEvent(event);
      }
   }
}

