package mx.rpc.soap.mxml
{
   import mx.managers.CursorManager;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractService;
   import mx.rpc.AsyncDispatcher;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.mxml.Concurrency;
   import mx.rpc.mxml.IMXMLSupport;
   import mx.rpc.soap.Operation;
   import mx.rpc.soap.WebService;
   
   [ResourceBundle("rpc")]
   public class Operation extends mx.rpc.soap.Operation implements IMXMLSupport
   {
      
      private var webService:mx.rpc.soap.mxml.WebService;
      
      private var _concurrency:String;
      
      private var _showBusyCursor:Boolean;
      
      private var _concurrencySet:Boolean;
      
      private var _showBusyCursorSet:Boolean;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function Operation(webService:mx.rpc.soap.WebService = null, name:String = null)
      {
         super(webService,name);
         this.webService = mx.rpc.soap.mxml.WebService(webService);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getNetmonId() : String
      {
         return webService.id;
      }
      
      override public function send(... args) : AsyncToken
      {
         var token:AsyncToken = null;
         var message:String = null;
         var fault:Fault = null;
         var faultEvent:FaultEvent = null;
         if(Concurrency.SINGLE == concurrency && (hasPendingInvocations() || activeCalls.hasActiveCalls()))
         {
            token = new AsyncToken(null);
            message = resourceManager.getString("rpc","pendingCallExists");
            fault = new Fault("ConcurrencyError",message);
            faultEvent = FaultEvent.createEvent(fault,token);
            new AsyncDispatcher(dispatchRpcEvent,[faultEvent],10);
            return token;
         }
         return super.send.apply(null,args);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(ro:AbstractService) : void
      {
         super.setService(ro);
         webService = mx.rpc.soap.mxml.WebService(ro);
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         if(_concurrencySet)
         {
            return _concurrency;
         }
         return webService.concurrency;
      }
      
      public function get showBusyCursor() : Boolean
      {
         if(_showBusyCursorSet)
         {
            return _showBusyCursor;
         }
         return webService.showBusyCursor;
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         _showBusyCursor = sbc;
         _showBusyCursorSet = true;
      }
      
      public function set concurrency(c:String) : void
      {
         _concurrency = c;
         _concurrencySet = true;
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

