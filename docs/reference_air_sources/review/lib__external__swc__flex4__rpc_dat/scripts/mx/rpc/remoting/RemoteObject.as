package mx.rpc.remoting
{
   import mx.messaging.Channel;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.AMFChannel;
   import mx.messaging.channels.SecureAMFChannel;
   import mx.rpc.AbstractOperation;
   import mx.rpc.AbstractService;
   import mx.rpc.mxml.Concurrency;
   
   public dynamic class RemoteObject extends AbstractService
   {
      
      private var _concurrency:String;
      
      private var _endpoint:String;
      
      private var _source:String;
      
      private var _makeObjectsBindable:Boolean;
      
      private var _showBusyCursor:Boolean;
      
      public var convertParametersHandler:Function;
      
      public var convertResultHandler:Function;
      
      public function RemoteObject(destination:String = null)
      {
         super(destination);
         this.concurrency = Concurrency.MULTIPLE;
         this.makeObjectsBindable = true;
         this.showBusyCursor = false;
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         return this._concurrency;
      }
      
      public function set concurrency(c:String) : void
      {
         this._concurrency = c;
      }
      
      [Inspectable(category="General")]
      public function get endpoint() : String
      {
         return this._endpoint;
      }
      
      public function set endpoint(url:String) : void
      {
         if(this._endpoint != url || url == null)
         {
            this._endpoint = url;
            channelSet = null;
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get makeObjectsBindable() : Boolean
      {
         return this._makeObjectsBindable;
      }
      
      public function set makeObjectsBindable(b:Boolean) : void
      {
         this._makeObjectsBindable = b;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get showBusyCursor() : Boolean
      {
         return this._showBusyCursor;
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         this._showBusyCursor = sbc;
      }
      
      [Inspectable(category="General")]
      public function get source() : String
      {
         return this._source;
      }
      
      public function set source(s:String) : void
      {
         this._source = s;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function initEndpoint() : void
      {
         var chan:Channel = null;
         if(this.endpoint != null)
         {
            if(this.endpoint.indexOf("https") == 0)
            {
               chan = new SecureAMFChannel(null,this.endpoint);
            }
            else
            {
               chan = new AMFChannel(null,this.endpoint);
            }
            chan.requestTimeout = requestTimeout;
            channelSet = new ChannelSet();
            channelSet.addChannel(chan);
         }
      }
      
      override public function getOperation(name:String) : AbstractOperation
      {
         var op:AbstractOperation = super.getOperation(name);
         if(op == null)
         {
            op = new Operation(this,name);
            _operations[name] = op;
            op.asyncRequest = asyncRequest;
         }
         return op;
      }
      
      override public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String = null) : void
      {
         super.setRemoteCredentials(remoteUsername,remotePassword,charset);
      }
      
      public function toString() : String
      {
         var s:String = "[RemoteObject ";
         s += " destination=\"" + destination + "\"";
         if(Boolean(this.source))
         {
            s += " source=\"" + this.source + "\"";
         }
         return s + (" channelSet=\"" + channelSet + "\"]");
      }
   }
}

