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
      
      public var convertResultHandler:Function;
      
      private var _endpoint:String;
      
      public var convertParametersHandler:Function;
      
      private var _concurrency:String;
      
      private var _showBusyCursor:Boolean;
      
      private var _source:String;
      
      private var _makeObjectsBindable:Boolean;
      
      public function RemoteObject(destination:String = null)
      {
         super(destination);
         concurrency = Concurrency.MULTIPLE;
         makeObjectsBindable = true;
         showBusyCursor = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function initEndpoint() : void
      {
         var chan:Channel = null;
         if(endpoint != null)
         {
            if(endpoint.indexOf("https") == 0)
            {
               chan = new SecureAMFChannel(null,endpoint);
            }
            else
            {
               chan = new AMFChannel(null,endpoint);
            }
            channelSet = new ChannelSet();
            channelSet.addChannel(chan);
         }
      }
      
      public function set makeObjectsBindable(b:Boolean) : void
      {
         _makeObjectsBindable = b;
      }
      
      [Inspectable(defaultValue="false",category="General")]
      public function get showBusyCursor() : Boolean
      {
         return _showBusyCursor;
      }
      
      [Inspectable(enumeration="multiple,single,last",defaultValue="multiple",category="General")]
      public function get concurrency() : String
      {
         return _concurrency;
      }
      
      [Inspectable(category="General")]
      public function get endpoint() : String
      {
         return _endpoint;
      }
      
      public function set showBusyCursor(sbc:Boolean) : void
      {
         _showBusyCursor = sbc;
      }
      
      [Inspectable(category="General")]
      public function get source() : String
      {
         return _source;
      }
      
      override public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String = null) : void
      {
         super.setRemoteCredentials(remoteUsername,remotePassword,charset);
      }
      
      public function set concurrency(c:String) : void
      {
         _concurrency = c;
      }
      
      public function set endpoint(url:String) : void
      {
         if(_endpoint != url || url == null)
         {
            _endpoint = url;
            channelSet = null;
         }
      }
      
      public function toString() : String
      {
         var s:String = "[RemoteObject ";
         s += " destination=\"" + destination + "\"";
         if(Boolean(source))
         {
            s += " source=\"" + source + "\"";
         }
         return s + (" channelSet=\"" + channelSet + "\"]");
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
      
      public function set source(s:String) : void
      {
         _source = s;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get makeObjectsBindable() : Boolean
      {
         return _makeObjectsBindable;
      }
   }
}

