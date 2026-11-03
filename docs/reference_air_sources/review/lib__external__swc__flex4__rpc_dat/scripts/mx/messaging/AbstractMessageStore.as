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
      
      private var _autoSend:Boolean;
      
      private var _cacheId:String;
      
      protected var _initialized:Boolean = true;
      
      private var _loaded:Boolean;
      
      private var _producer:AbstractProducer;
      
      public function AbstractMessageStore()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get autoSend() : Boolean
      {
         return this._autoSend;
      }
      
      public function set autoSend(value:Boolean) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._autoSend != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"autoSend",this._autoSend,value);
            this._autoSend = value;
            this.attemptToSendOrConnect();
            dispatchEvent(event);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cacheID() : String
      {
         return this._cacheId;
      }
      
      public function set cacheID(value:String) : void
      {
         if(this._cacheId != value)
         {
            this._initialized = value == null;
            this._cacheId = value;
            this.internalSetCacheId(value);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isInitialized() : Boolean
      {
         return this._initialized;
      }
      
      [Bindable(event="propertyChange")]
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      [Bindable(event="propertyChange")]
      public function get producer() : AbstractProducer
      {
         return this._producer;
      }
      
      override public function addItem(item:Object) : void
      {
         var msg:IMessage = IMessage(item);
         if(msg != null)
         {
            if(this.autoSend && this.producer != null && this.producer.connected)
            {
               this.producer.send(msg);
            }
            else
            {
               super.addItem(msg);
            }
         }
      }
      
      public function clearCache() : AsyncToken
      {
         var success:Function;
         var failed:Function;
         var token:AsyncToken = null;
         var ms:AbstractMessageStore = null;
         this.checkCacheId();
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
         if(!this.isInitialized)
         {
            this.internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return token;
      }
      
      public function getCacheIDs(view:ListCollectionView) : AsyncToken
      {
         var result:AsyncToken = new AsyncToken(null);
         this.internalGetCacheIDs(view,result);
         return result;
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
         if(!this.isInitialized)
         {
            this.internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return result;
      }
      
      public function loadCache() : AsyncToken
      {
         var success:Function;
         var failed:Function;
         var token:AsyncToken = null;
         var ms:AbstractMessageStore = null;
         this.checkCacheId();
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
         if(!this.isInitialized)
         {
            this.internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return token;
      }
      
      public function release() : AsyncToken
      {
         this.setLoaded(false);
         var token:AsyncToken = new AsyncToken(null);
         this.internalRelease(token);
         return token;
      }
      
      public function saveCache() : AsyncToken
      {
         var success:Function;
         var failed:Function;
         var token:AsyncToken = null;
         var ms:AbstractMessageStore = null;
         this.checkCacheId();
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
         if(!this.isInitialized)
         {
            this.internalInitialize(success,failed);
         }
         else
         {
            new AsyncDispatcher(success,[],1);
         }
         return token;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addMessage(msg:IMessage) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeMessage(msg:IMessage) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setProducer(value:AbstractProducer) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._producer != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"producer",this._producer,value);
            if(this._producer != null)
            {
               this._producer.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.producerPropertyChangeHandler);
            }
            this._producer = value;
            if(this._producer != null)
            {
               this._producer.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.producerPropertyChangeHandler);
               this.attemptToSendOrConnect();
            }
            dispatchEvent(event);
         }
      }
      
      protected function attemptToSendOrConnect() : void
      {
         if(Boolean(length) && Boolean(this.autoSend) && this.producer != null)
         {
            if(!this.producer.connected && this.producer.autoConnect)
            {
               this.producer.connect();
            }
            else if(this.producer.connected && this.producer.clientId != null)
            {
               this.sendAll();
            }
         }
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
      
      protected function dispatchResultEvent(event:ResultEvent, token:AsyncToken) : void
      {
         event.callTokenResponders();
         if(Boolean(hasEventListener(ResultEvent.RESULT)) && token != null)
         {
            dispatchEvent(event);
         }
      }
      
      protected function internalClearCache(token:AsyncToken) : void
      {
      }
      
      protected function internalGetCacheIDs(view:ListCollectionView, token:AsyncToken) : void
      {
      }
      
      protected function internalInitialize(success:Function, failed:Function) : void
      {
         success();
      }
      
      protected function internalLoadCache(token:AsyncToken) : void
      {
      }
      
      protected function internalRelease(token:AsyncToken) : void
      {
      }
      
      protected function internalSetCacheId(value:String) : void
      {
      }
      
      protected function internalSaveCache(token:AsyncToken) : void
      {
      }
      
      protected function send(msg:IMessage) : void
      {
         if(msg.headers[MESSAGE_STORE_HEADER] != null)
         {
            delete msg.headers[MESSAGE_STORE_HEADER];
         }
         this.producer.send(msg);
      }
      
      protected function sendAll() : void
      {
      }
      
      protected function setLoaded(value:Boolean) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._loaded != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"loaded",this._loaded,value);
            this._loaded = value;
            dispatchEvent(event);
         }
      }
      
      private function checkCacheId() : void
      {
         if(this.cacheID == null || this.cacheID.length == 0)
         {
            throw new IllegalOperationError("A cache identifier must be set before performing this operation.");
         }
      }
      
      private function getInitFailedFault(details:String = null) : Fault
      {
         return new Fault("Client.Initialization.Failed","Could not initialize MessageStore.",details);
      }
      
      private function producerPropertyChangeHandler(event:PropertyChangeEvent) : void
      {
         switch(event.property)
         {
            case "autoConnect":
            case "connected":
               if(Boolean(event.newValue))
               {
                  this.attemptToSendOrConnect();
               }
               break;
            case "clientId":
               if(event.newValue != null && event.oldValue == null)
               {
                  this.attemptToSendOrConnect();
               }
         }
      }
   }
}

