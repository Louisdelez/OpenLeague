package mx.messaging
{
   import flash.errors.IllegalOperationError;
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.events.PropertyChangeEvent;
   import mx.messaging.messages.IMessage;
   import mx.rpc.AsyncDispatcher;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   [ExcludeClass]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   [Event(name="result",type="mx.rpc.events.ResultEvent")]
   [Event(name="status",type="flash.events.StatusEvent")]
   public class AbstractMessageStore extends ArrayCollection
   {
      
      public static const MESSAGE_STORE_HEADER:String = "DSMessageStore";
      
      protected var _initialized:Boolean = true;
      
      private var _loaded:Boolean;
      
      private var _producer:AbstractProducer;
      
      private var _autoSend:Boolean;
      
      private var _cacheId:String;
      
      public function AbstractMessageStore()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setProducer(value:AbstractProducer) : void
      {
         var event:PropertyChangeEvent = null;
         if(_producer != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"producer",_producer,value);
            if(_producer != null)
            {
               _producer.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,producerPropertyChangeHandler);
            }
            _producer = value;
            if(_producer != null)
            {
               _producer.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,producerPropertyChangeHandler);
               attemptToSendOrConnect();
            }
            dispatchEvent(event);
         }
      }
      
      private function producerPropertyChangeHandler(event:PropertyChangeEvent) : void
      {
         switch(event.property)
         {
            case "autoConnect":
            case "connected":
               if(Boolean(event.newValue))
               {
                  attemptToSendOrConnect();
               }
               break;
            case "clientId":
               if(event.newValue != null && event.oldValue == null)
               {
                  attemptToSendOrConnect();
               }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get loaded() : Boolean
      {
         return _loaded;
      }
      
      private function getInitFailedFault(details:String = null) : Fault
      {
         return new Fault("Client.Initialization.Failed","Could not initialize MessageStore.",details);
      }
      
      public function release() : AsyncToken
      {
         setLoaded(false);
         var token:AsyncToken = new AsyncToken(null);
         internalRelease(token);
         return token;
      }
      
      [Bindable(event="propertyChange")]
      public function get isInitialized() : Boolean
      {
         return _initialized;
      }
      
      public function saveCache() : AsyncToken
      {
         var success:Function;
         var failed:Function;
         var token:AsyncToken = null;
         var ms:AbstractMessageStore = null;
         checkCacheId();
         token = new AsyncToken(null);
         ms = this;
         success = function():void
         {
            ms.internalSaveCache(token);
         };
         failed = function():void
         {
            dispatchFaultEvent(getInitFailedFault(),token);
         };
         if(!isInitialized)
         {
            internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return token;
      }
      
      protected function setLoaded(value:Boolean) : void
      {
         var event:PropertyChangeEvent = null;
         if(_loaded != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"loaded",_loaded,value);
            _loaded = value;
            dispatchEvent(event);
         }
      }
      
      protected function internalSaveCache(token:AsyncToken) : void
      {
      }
      
      public function initialize() : AsyncToken
      {
         var result:AsyncToken = null;
         result = new AsyncToken(null);
         var success:Function = function():void
         {
            var event:ResultEvent = ResultEvent.createEvent(null,result);
            dispatchResultEvent(event,result);
         };
         var failed:Function = function():void
         {
            dispatchFaultEvent(getInitFailedFault(),result);
         };
         if(!isInitialized)
         {
            internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return result;
      }
      
      protected function internalRelease(token:AsyncToken) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get producer() : AbstractProducer
      {
         return _producer;
      }
      
      override public function addItem(item:Object) : void
      {
         var msg:IMessage = IMessage(item);
         if(msg != null)
         {
            if(autoSend && producer != null && producer.connected)
            {
               producer.send(msg);
            }
            else
            {
               super.addItem(msg);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get autoSend() : Boolean
      {
         return _autoSend;
      }
      
      protected function internalSetCacheId(value:String) : void
      {
      }
      
      protected function internalClearCache(token:AsyncToken) : void
      {
      }
      
      protected function dispatchResultEvent(event:ResultEvent, token:AsyncToken) : void
      {
         event.callTokenResponders();
         if(Boolean(hasEventListener(ResultEvent.RESULT)) && token != null)
         {
            dispatchEvent(event);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cacheID() : String
      {
         return _cacheId;
      }
      
      protected function attemptToSendOrConnect() : void
      {
         if(Boolean(length) && Boolean(autoSend) && producer != null)
         {
            if(!producer.connected && producer.autoConnect)
            {
               producer.connect();
            }
            else if(producer.connected && producer.clientId != null)
            {
               sendAll();
            }
         }
      }
      
      protected function send(msg:IMessage) : void
      {
         if(msg.headers[MESSAGE_STORE_HEADER] != null)
         {
            delete msg.headers[MESSAGE_STORE_HEADER];
         }
         producer.send(msg);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeMessage(msg:IMessage) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addMessage(msg:IMessage) : void
      {
      }
      
      protected function internalInitialize(success:Function, failed:Function) : void
      {
         success();
      }
      
      public function set autoSend(value:Boolean) : void
      {
         var event:PropertyChangeEvent = null;
         if(_autoSend != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"autoSend",_autoSend,value);
            _autoSend = value;
            attemptToSendOrConnect();
            dispatchEvent(event);
         }
      }
      
      protected function internalGetCacheIDs(view:ListCollectionView, token:AsyncToken) : void
      {
      }
      
      protected function dispatchFaultEvent(fault:Fault, token:AsyncToken) : void
      {
         var faultEvent:FaultEvent = FaultEvent.createEvent(fault,token);
         faultEvent.callTokenResponders();
         if(Boolean(hasEventListener(FaultEvent.FAULT)) && token != null)
         {
            dispatchEvent(faultEvent);
            return;
         }
         throw fault;
      }
      
      public function clearCache() : AsyncToken
      {
         var success:Function;
         var failed:Function;
         var token:AsyncToken = null;
         var ms:AbstractMessageStore = null;
         checkCacheId();
         token = new AsyncToken(null);
         ms = this;
         success = function():void
         {
            ms.internalClearCache(token);
         };
         failed = function():void
         {
            dispatchFaultEvent(getInitFailedFault(),token);
         };
         if(!isInitialized)
         {
            internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return token;
      }
      
      private function checkCacheId() : void
      {
         if(cacheID == null || cacheID.length == 0)
         {
            throw new IllegalOperationError("A cache identifier must be set before performing this operation.");
         }
      }
      
      protected function sendAll() : void
      {
      }
      
      public function set cacheID(value:String) : void
      {
         if(_cacheId != value)
         {
            _initialized = value == null;
            _cacheId = value;
            internalSetCacheId(value);
         }
      }
      
      public function getCacheIDs(view:ListCollectionView) : AsyncToken
      {
         var result:AsyncToken = new AsyncToken(null);
         internalGetCacheIDs(view,result);
         return result;
      }
      
      public function loadCache() : AsyncToken
      {
         var success:Function;
         var failed:Function;
         var token:AsyncToken = null;
         var ms:AbstractMessageStore = null;
         checkCacheId();
         token = new AsyncToken(null);
         ms = this;
         success = function():void
         {
            ms.internalLoadCache(token);
         };
         failed = function():void
         {
            dispatchFaultEvent(getInitFailedFault(),token);
         };
         if(!isInitialized)
         {
            internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return token;
      }
      
      protected function internalLoadCache(token:AsyncToken) : void
      {
      }
   }
}

