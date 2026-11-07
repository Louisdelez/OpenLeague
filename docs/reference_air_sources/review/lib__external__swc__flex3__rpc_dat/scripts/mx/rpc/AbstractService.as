package mx.rpc
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import mx.messaging.ChannelSet;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.AbstractEvent;
   
   use namespace flash_proxy;
   
   [Bindable(event="operationsChange")]
   [ResourceBundle("rpc")]
   [Event(name="fault",type="mx.rpc.events.FaultEvent")]
   [Event(name="result",type="mx.rpc.events.ResultEvent")]
   [Event(name="invoke",type="mx.rpc.events.InvokeEvent")]
   public dynamic class AbstractService extends Proxy implements IEventDispatcher
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _operations:Object;
      
      private var _initialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _availableChannelIds:Array;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _managers:Array;
      
      private var nextNameArray:Array;
      
      private var eventDispatcher:EventDispatcher;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var asyncRequest:AsyncRequest;
      
      public function AbstractService(destination:String = null)
      {
         super();
         eventDispatcher = new EventDispatcher(this);
         asyncRequest = new AsyncRequest();
         if(Boolean(destination))
         {
            this.destination = destination;
            asyncRequest.destination = destination;
         }
         _operations = {};
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return eventDispatcher.willTrigger(type);
      }
      
      [Inspectable(category="General")]
      public function get destination() : String
      {
         return asyncRequest.destination;
      }
      
      public function initialize() : void
      {
         var i:int = 0;
         var mgr:Object = null;
         if(!_initialized && _managers != null)
         {
            for(i = 0; i < _managers.length; i++)
            {
               mgr = _managers[i];
               if(mgr.hasOwnProperty("initialize"))
               {
                  mgr.initialize();
               }
            }
            _initialized = true;
         }
      }
      
      public function logout() : void
      {
         asyncRequest.logout();
      }
      
      public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String = null) : void
      {
         asyncRequest.setRemoteCredentials(remoteUsername,remotePassword,charset);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hasTokenResponders(event:Event) : Boolean
      {
         var rpcEvent:AbstractEvent = null;
         if(event is AbstractEvent)
         {
            rpcEvent = event as AbstractEvent;
            if(rpcEvent.token != null && rpcEvent.token.hasResponder())
            {
               return true;
            }
         }
         return false;
      }
      
      public function disconnect() : void
      {
         asyncRequest.disconnect();
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return nextNameArray[index - 1];
      }
      
      public function set destination(name:String) : void
      {
         asyncRequest.destination = name;
      }
      
      public function set requestTimeout(value:int) : void
      {
         if(requestTimeout != value)
         {
            asyncRequest.requestTimeout = value;
         }
      }
      
      public function valueOf() : Object
      {
         return this;
      }
      
      public function getOperation(name:String) : AbstractOperation
      {
         var o:Object = _operations[name];
         return o is AbstractOperation ? AbstractOperation(o) : null;
      }
      
      public function setCredentials(username:String, password:String, charset:String = null) : void
      {
         asyncRequest.setCredentials(username,password,charset);
      }
      
      public function set channelSet(value:ChannelSet) : void
      {
         if(channelSet != value)
         {
            asyncRequest.channelSet = value;
         }
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return eventDispatcher.dispatchEvent(event);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         eventDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         return getOperation(getLocalName(name));
      }
      
      public function set managers(mgrs:Array) : void
      {
         var i:int = 0;
         var mgr:Object = null;
         if(_managers != null)
         {
            for(i = 0; i < _managers.length; i++)
            {
               mgr = _managers[i];
               if(mgr.hasOwnProperty("service"))
               {
                  mgr.service = null;
               }
            }
         }
         _managers = mgrs;
         for(i = 0; i < mgrs.length; i++)
         {
            mgr = _managers[i];
            if(mgr.hasOwnProperty("service"))
            {
               mgr.service = this;
            }
            if(_initialized && mgr.hasOwnProperty("initialize"))
            {
               mgr.initialize();
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get requestTimeout() : int
      {
         return asyncRequest.requestTimeout;
      }
      
      override flash_proxy function callProperty(name:*, ... args) : *
      {
         return getOperation(getLocalName(name)).send.apply(null,args);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override flash_proxy function nextValue(index:int) : *
      {
         return _operations[nextNameArray[index - 1]];
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var message:String = resourceManager.getString("rpc","operationsNotAllowedInService",[getLocalName(name)]);
         throw new Error(message);
      }
      
      public function set operations(ops:Object) : void
      {
         var op:AbstractOperation = null;
         var i:String = null;
         for(i in ops)
         {
            op = AbstractOperation(ops[i]);
            op.setService(this);
            if(!op.name)
            {
               op.name = i;
            }
            op.asyncRequest = asyncRequest;
         }
         _operations = ops;
         dispatchEvent(new Event("operationsChange"));
      }
      
      public function get channelSet() : ChannelSet
      {
         return asyncRequest.channelSet;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLocalName(name:Object) : String
      {
         if(name is QName)
         {
            return QName(name).localName;
         }
         return String(name);
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         var op:String = null;
         if(index == 0)
         {
            nextNameArray = [];
            for(op in _operations)
            {
               nextNameArray.push(op);
            }
         }
         return index < nextNameArray.length ? int(index + 1) : 0;
      }
      
      public function get managers() : Array
      {
         return _managers;
      }
      
      public function get operations() : Object
      {
         return _operations;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return eventDispatcher.hasEventListener(type);
      }
   }
}

