package mx.rpc.remoting
{
   import mx.managers.CursorManager;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.IMessage;
   import mx.messaging.messages.RemotingMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractOperation;
   import mx.rpc.AbstractService;
   import mx.rpc.AsyncDispatcher;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.mxml.Concurrency;
   
   public class Operation extends AbstractOperation
   {
      
      public var argumentNames:Array;
      
      private var _concurrency:String;
      
      private var _concurrencySet:Boolean;
      
      private var _makeObjectsBindableSet:Boolean;
      
      private var _showBusyCursor:Boolean;
      
      private var _showBusyCursorSet:Boolean;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var remoteObject:RemoteObject;
      
      public function Operation(remoteObject:AbstractService = null, name:String = null)
      {
         super(remoteObject,name);
         this.argumentNames = [];
         this.remoteObject = RemoteObject(remoteObject);
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         if(this._concurrencySet)
         {
            return this._concurrency;
         }
         return this.remoteObject.concurrency;
      }
      
      public function set concurrency(c:String) : void
      {
         this._concurrency = c;
         this._concurrencySet = true;
      }
      
      [Inspectable(defaultValue="true",category="General")]
      override public function get makeObjectsBindable() : Boolean
      {
         if(this._makeObjectsBindableSet)
         {
            return _makeObjectsBindable;
         }
         return RemoteObject(service).makeObjectsBindable;
      }
      
      override public function set makeObjectsBindable(b:Boolean) : void
      {
         _makeObjectsBindable = b;
         this._makeObjectsBindableSet = true;
      }
      
      public function get showBusyCursor() : Boolean
      {
         if(this._showBusyCursorSet)
         {
            return this._showBusyCursor;
         }
         return this.remoteObject.showBusyCursor;
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         this._showBusyCursor = sbc;
         this._showBusyCursorSet = true;
      }
      
      override public function send(... args) : AsyncToken
      {
         var token:AsyncToken = null;
         var m:String = null;
         var fault:Fault = null;
         var faultEvent:FaultEvent = null;
         var i:int = 0;
         if(service != null)
         {
            service.initialize();
         }
         if(this.remoteObject.convertParametersHandler != null)
         {
            args = this.remoteObject.convertParametersHandler(args);
         }
         if(operationManager != null)
         {
            return operationManager(args);
         }
         if(Concurrency.SINGLE == this.concurrency && activeCalls.hasActiveCalls())
         {
            token = new AsyncToken(null);
            m = this.resourceManager.getString("rpc","pendingCallExists");
            fault = new Fault("ConcurrencyError",m);
            faultEvent = FaultEvent.createEvent(fault,token);
            new AsyncDispatcher(dispatchRpcEvent,[faultEvent],10);
            return token;
         }
         if(asyncRequest.channelSet == null && this.remoteObject.endpoint != null)
         {
            this.remoteObject.initEndpoint();
         }
         if(!args || Boolean(args.length == 0) && Boolean(this.arguments))
         {
            if(this.arguments is Array)
            {
               args = this.arguments as Array;
            }
            else
            {
               args = [];
               for(i = 0; i < this.argumentNames.length; i++)
               {
                  args[i] = this.arguments[this.argumentNames[i]];
               }
            }
         }
         var message:RemotingMessage = new RemotingMessage();
         message.operation = name;
         message.body = args;
         message.source = RemoteObject(service).source;
         return this.invoke(message);
      }
      
      override public function cancel(id:String = null) : AsyncToken
      {
         if(this.showBusyCursor)
         {
            CursorManager.removeBusyCursor();
         }
         return super.cancel(id);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setService(ro:AbstractService) : void
      {
         super.setService(ro);
         this.remoteObject = RemoteObject(ro);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invoke(message:IMessage, token:AsyncToken = null) : AsyncToken
      {
         if(this.showBusyCursor)
         {
            CursorManager.setBusyCursor();
         }
         return super.invoke(message,token);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function preHandle(event:MessageEvent) : AsyncToken
      {
         if(this.showBusyCursor)
         {
            CursorManager.removeBusyCursor();
         }
         var wasLastCall:Boolean = activeCalls.wasLastCall(AsyncMessage(event.message).correlationId);
         var token:AsyncToken = super.preHandle(event);
         if(Concurrency.LAST == this.concurrency && !wasLastCall)
         {
            return null;
         }
         return token;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processResult(message:IMessage, token:AsyncToken) : Boolean
      {
         if(super.processResult(message,token))
         {
            if(this.remoteObject.convertResultHandler != null)
            {
               _result = this.remoteObject.convertResultHandler(_result,this);
            }
            return true;
         }
         return false;
      }
   }
}

