package mx.rpc.soap.mxml
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.IMXMLObject;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractOperation;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.mxml.Concurrency;
   import mx.rpc.mxml.IMXMLSupport;
   import mx.rpc.soap.WebService;
   
   [ResourceBundle("rpc")]
   public dynamic class WebService extends mx.rpc.soap.WebService implements IMXMLSupport, IMXMLObject
   {
      
      private var _concurrency:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var document:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var id:String;
      
      private var _showBusyCursor:Boolean;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function WebService(destination:String = null)
      {
         super(destination);
         concurrency = Concurrency.MULTIPLE;
         showBusyCursor = false;
      }
      
      public function set serviceName(sn:String) : void
      {
         destination = sn;
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         var reason:String = null;
         var evt:ErrorEvent = null;
         var message:String = null;
         if(hasEventListener(event.type))
         {
            return super.dispatchEvent(event);
         }
         if(event is FaultEvent && !hasTokenResponders(event) || event is ErrorEvent)
         {
            reason = event is FaultEvent ? FaultEvent(event).fault.faultString : ErrorEvent(event).text;
            if(Boolean(document) && Boolean(document.willTrigger(ErrorEvent.ERROR)))
            {
               evt = new ErrorEvent(ErrorEvent.ERROR,true,true);
               evt.text = reason;
               return document.dispatchEvent(evt);
            }
            if(event is FaultEvent)
            {
               throw FaultEvent(event).fault;
            }
            message = resourceManager.getString("rpc","noListenerForEvent",[reason]);
            throw new Error(message);
         }
         return false;
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
      
      [Deprecated(replacement="destination")]
      public function get serviceName() : String
      {
         return destination;
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.document = document;
         this.id = id;
         if(document is IEventDispatcher)
         {
            IEventDispatcher(document).addEventListener("creationComplete",creationComplete);
         }
         initialize();
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get showBusyCursor() : Boolean
      {
         return _showBusyCursor;
      }
      
      public function set concurrency(c:String) : void
      {
         _concurrency = c;
      }
      
      [Deprecated("Property protocol is deprecated. Please use an appropriate channel from your services configuration file (DefaultHTTP or DefaultHTTPS for instance); when useProxy is false set your URL to use the right protocol")]
      public function set protocol(protocol:String) : void
      {
         var message:String = null;
         if(destination == DEFAULT_DESTINATION_HTTP || destination == DEFAULT_DESTINATION_HTTP)
         {
            if(protocol == "http")
            {
               destination = DEFAULT_DESTINATION_HTTP;
            }
            else
            {
               if(protocol != "https")
               {
                  message = resourceManager.getString("rpc","unknownProtocol",[protocol]);
                  throw new Error(message);
               }
               destination = DEFAULT_DESTINATION_HTTPS;
            }
         }
      }
      
      override public function getOperation(name:String) : AbstractOperation
      {
         var o:Object = _operations[name];
         var op:AbstractOperation = o is AbstractOperation ? AbstractOperation(o) : null;
         if(op == null)
         {
            op = new Operation(this,name);
            _operations[name] = op;
            op.asyncRequest = asyncRequest;
            initializeOperation(op as Operation);
         }
         return op;
      }
      
      public function creationComplete(event:Event) : void
      {
         if(canLoadWSDL())
         {
            loadWSDL();
         }
      }
   }
}

