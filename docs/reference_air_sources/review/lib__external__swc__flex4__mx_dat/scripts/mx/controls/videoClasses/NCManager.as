package mx.controls.videoClasses
{
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.net.Responder;
   import flash.utils.Timer;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("controls")]
   [ExcludeClass]
   public class NCManager implements INCManager
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const DEFAULT_TIMEOUT:Number = 60000;
      
      private static const DEFAULT_NC_TIMEOUT:uint = 1500;
      
      private static var RTMP_CONN:Array = [{
         "protocol":"rtmp:/",
         "port":"1935"
      },{
         "protocol":"rtmp:/",
         "port":"443"
      },{
         "protocol":"rtmpt:/",
         "port":"80"
      },{
         "protocol":"rtmps:/",
         "port":"443"
      }];
      
      public var fallbackServerName:String;
      
      private var owner:VideoPlayer;
      
      private var contentPath:String;
      
      private var protocol:String;
      
      private var serverName:String;
      
      private var portNumber:String;
      
      private var wrappedURL:String;
      
      private var appName:String;
      
      private var streams:Array;
      
      private var _isRTMP:int = -1;
      
      private var connectionTimer:Timer;
      
      private var autoSenseBW:Boolean;
      
      public var payload:uint;
      
      private var ncURI:String;
      
      private var ncConnected:Boolean;
      
      public var tryNC:Array;
      
      private var tryNCTimer:Timer;
      
      private var connTypeCounter:uint;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _timeout:uint;
      
      private var _bitrate:Number;
      
      private var _netConnection:NetConnection;
      
      private var _streamName:String;
      
      private var _streamLength:Number;
      
      private var _streamWidth:Number;
      
      private var _streamHeight:Number;
      
      public function NCManager()
      {
         super();
         this.initNCInfo();
         this.initOtherInfo();
         this.owner = null;
         this._netConnection = null;
         this.ncConnected = false;
         this.timeout = DEFAULT_TIMEOUT;
      }
      
      public function get timeout() : uint
      {
         return this._timeout;
      }
      
      public function set timeout(t:uint) : void
      {
         this._timeout = t;
         this.connectionTimer = new Timer(this._timeout,1);
         this.connectionTimer.addEventListener(TimerEvent.TIMER,this.onFCSConnectTimeOut);
      }
      
      public function get bitrate() : Number
      {
         return this._bitrate;
      }
      
      public function set bitrate(b:Number) : void
      {
         if(this._isRTMP == 0)
         {
            this._bitrate = b;
         }
      }
      
      public function get videoPlayer() : VideoPlayer
      {
         return this.owner;
      }
      
      public function set videoPlayer(value:VideoPlayer) : void
      {
         this.owner = value;
      }
      
      public function get netConnection() : NetConnection
      {
         return this._netConnection;
      }
      
      public function get streamName() : String
      {
         return this._streamName;
      }
      
      public function get streamLength() : Number
      {
         return this._streamLength;
      }
      
      public function get streamWidth() : Number
      {
         return this._streamWidth;
      }
      
      public function get streamHeight() : Number
      {
         return this._streamHeight;
      }
      
      public function isRTMP() : Boolean
      {
         return this._isRTMP != 0;
      }
      
      public function connectToURL(url:String) : Boolean
      {
         var canReuseRTMP:Boolean = false;
         var canReuseHTTP:Boolean = false;
         this.initOtherInfo();
         this.contentPath = url;
         if(!this.contentPath || this.contentPath == "")
         {
            throw new VideoError(VideoError.INVALID_CONTENT_PATH);
         }
         var parseResults:Object = this.parseURL(this.contentPath);
         if(!parseResults.streamName || parseResults.streamName == "")
         {
            throw new VideoError(VideoError.INVALID_CONTENT_PATH,url);
         }
         if(Boolean(parseResults.isRTMP))
         {
            canReuseRTMP = this.canReuseOldConnection(parseResults);
            this._isRTMP = 1;
            this.protocol = parseResults.protocol;
            this._streamName = parseResults.streamName;
            this.serverName = parseResults.serverName;
            this.wrappedURL = parseResults.wrappedURL;
            this.portNumber = parseResults.portNumber;
            this.appName = parseResults.appName;
            if(!this.appName || this.appName == "" || !this._streamName || this._streamName == "")
            {
               throw new VideoError(VideoError.INVALID_CONTENT_PATH,url);
            }
            this.autoSenseBW = this._streamName.indexOf(",") >= 0;
            return canReuseRTMP || this.connectRTMP();
         }
         canReuseHTTP = this.canReuseOldConnection(parseResults);
         this._isRTMP = 0;
         this._streamName = parseResults.streamName;
         return canReuseHTTP || this.connectHTTP();
      }
      
      public function connectAgain() : Boolean
      {
         var slashIndex:Number = this.appName.indexOf("/");
         if(slashIndex < 0)
         {
            slashIndex = this._streamName.indexOf("/");
            if(slashIndex >= 0)
            {
               this.appName += "/";
               this.appName += this._streamName.slice(0,slashIndex);
               this._streamName = this._streamName.slice(slashIndex + 1);
            }
            return false;
         }
         var newStreamName:String = this.appName.slice(slashIndex + 1);
         newStreamName += "/";
         newStreamName += this._streamName;
         this._streamName = newStreamName;
         this.appName = this.appName.slice(0,slashIndex);
         this.close();
         this.payload = 0;
         this.connTypeCounter = 0;
         this.cleanConns();
         this.connectRTMP();
         return true;
      }
      
      public function reconnect() : void
      {
         var message:String = null;
         if(!this._isRTMP)
         {
            message = this.resourceManager.getString("controls","invalidCall");
            throw new Error(message);
         }
         this._netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.reconnectOnStatus);
         this._netConnection.client = new NCManagerReconnectClient(this);
         this._netConnection.connect(this.ncURI,false);
      }
      
      public function close() : void
      {
         if(Boolean(this._netConnection))
         {
            this._netConnection.close();
            this.ncConnected = false;
         }
      }
      
      private function initNCInfo() : void
      {
         this._isRTMP = -1;
         this.serverName = null;
         this.wrappedURL = null;
         this.portNumber = null;
         this.appName = null;
      }
      
      private function initOtherInfo() : void
      {
         this.contentPath = null;
         this._streamName = null;
         this._streamLength = -1;
         this._streamWidth = -1;
         this._streamHeight = -1;
         this.streams = null;
         this.autoSenseBW = false;
         this.payload = 0;
         this.connTypeCounter = 0;
         this.cleanConns();
      }
      
      private function bitrateMatch() : void
      {
         var whichStream:Number = NaN;
         var checkBitrate:Number = this._bitrate;
         if(isNaN(checkBitrate))
         {
            checkBitrate = 0;
         }
         for(var j:uint = 0; j < this.streams.length; j++)
         {
            if(isNaN(this.streams[j].bitrate) || checkBitrate >= this.streams[j].bitrate)
            {
               whichStream = j;
               break;
            }
         }
         if(isNaN(whichStream))
         {
            throw new VideoError(VideoError.NO_BITRATE_MATCH);
         }
         if(Boolean(this._streamName))
         {
            this._streamName += this.streams[whichStream].src;
         }
         else
         {
            this._streamName = this.streams[whichStream].src;
         }
         this._streamLength = this.streams[whichStream].dur;
      }
      
      private function parseURL(url:String) : Object
      {
         var colonIndex:Number = NaN;
         var slashIndex:Number = NaN;
         var subURL:String = null;
         var subParseResults:Object = null;
         var parseResults:Object = {};
         var startIndex:uint = 0;
         var endIndex:int = url.indexOf(":/",startIndex);
         if(endIndex >= 0)
         {
            endIndex += 2;
            parseResults.protocol = url.slice(startIndex,endIndex);
            parseResults.isRelative = false;
         }
         else
         {
            parseResults.isRelative = true;
         }
         if(parseResults.protocol != null && (parseResults.protocol == "rtmp:/" || parseResults.protocol == "rtmpt:/" || parseResults.protocol == "rtmps:/" || parseResults.protocol == "rtmpe:/" || parseResults.protocol == "rmpte:/"))
         {
            parseResults.isRTMP = true;
            startIndex = uint(endIndex);
            if(url.charAt(startIndex) == "/")
            {
               startIndex++;
               colonIndex = url.indexOf(":",startIndex);
               slashIndex = url.indexOf("/",startIndex);
               if(slashIndex < 0)
               {
                  if(colonIndex < 0)
                  {
                     parseResults.serverName = url.slice(startIndex);
                  }
                  else
                  {
                     endIndex = colonIndex;
                     parseResults.portNumber = url.slice(startIndex,endIndex);
                     startIndex = endIndex + 1;
                     parseResults.serverName = url.slice(startIndex);
                  }
                  return parseResults;
               }
               if(colonIndex >= 0 && colonIndex < slashIndex)
               {
                  endIndex = colonIndex;
                  parseResults.serverName = url.slice(startIndex,endIndex);
                  startIndex = endIndex + 1;
                  endIndex = slashIndex;
                  parseResults.portNumber = url.slice(startIndex,endIndex);
               }
               else
               {
                  endIndex = slashIndex;
                  parseResults.serverName = url.slice(startIndex,endIndex);
               }
               startIndex = endIndex + 1;
            }
            if(url.charAt(startIndex) == "?")
            {
               subURL = url.slice(startIndex + 1);
               subParseResults = this.parseURL(subURL);
               if(!subParseResults.protocol || !subParseResults.isRTMP)
               {
                  throw new VideoError(VideoError.INVALID_CONTENT_PATH,url);
               }
               parseResults.wrappedURL = "?";
               parseResults.wrappedURL += subParseResults.protocol;
               if(subParseResults.serverName != null)
               {
                  parseResults.wrappedURL += "/";
                  parseResults.wrappedURL += subParseResults.server;
               }
               if(subParseResults.wrappedURL != null)
               {
                  parseResults.wrappedURL += "/?";
                  parseResults.wrappedURL += subParseResults.wrappedURL;
               }
               parseResults.appName = subParseResults.appName;
               parseResults.streamName = subParseResults.streamName;
               return parseResults;
            }
            endIndex = url.indexOf("/",startIndex);
            if(endIndex < 0)
            {
               parseResults.appName = url.slice(startIndex);
               return parseResults;
            }
            parseResults.appName = url.slice(startIndex,endIndex);
            startIndex = endIndex + 1;
            endIndex = url.indexOf("/",startIndex);
            if(endIndex < 0)
            {
               parseResults.streamName = url.slice(startIndex);
               if(parseResults.streamName.slice(-5).toLowerCase() == ".flv2")
               {
                  parseResults.streamName = parseResults.streamName.slice(0,-5);
               }
               else if(parseResults.streamName.slice(-4).toLowerCase() == ".flv")
               {
                  parseResults.streamName = parseResults.streamName.slice(0,-4);
               }
               return parseResults;
            }
            parseResults.appName += "/";
            parseResults.appName += url.slice(startIndex,endIndex);
            startIndex = endIndex + 1;
            parseResults.streamName = url.slice(startIndex);
            if(parseResults.streamName.slice(-5).toLowerCase() == ".flv2")
            {
               parseResults.streamName = parseResults.streamName.slice(0,-5);
            }
            else if(parseResults.streamName.slice(-4).toLowerCase() == ".flv")
            {
               parseResults.streamName = parseResults.streamName.slice(0,-4);
            }
         }
         else
         {
            parseResults.isRTMP = false;
            parseResults.streamName = url;
         }
         return parseResults;
      }
      
      private function connectHTTP() : Boolean
      {
         this._netConnection = new NetConnection();
         this._netConnection.objectEncoding = ObjectEncoding.AMF0;
         this._netConnection.connect(null);
         this.ncConnected = true;
         return true;
      }
      
      private function connectRTMP() : Boolean
      {
         this.connectionTimer.reset();
         this.connectionTimer.start();
         this.tryNC = [];
         this.tryNCTimer = new Timer(DEFAULT_NC_TIMEOUT);
         this.tryNCTimer.addEventListener(TimerEvent.TIMER,this.nextConnect);
         for(var i:uint = 0; i < RTMP_CONN.length; i++)
         {
            this.tryNC[i] = new NetConnection();
            this.tryNC[i].objectEncoding = ObjectEncoding.AMF0;
            this.tryNC[i].client = new NCManagerConnectClient(this.tryNC[i],this,i);
            this.tryNC[i].addEventListener(NetStatusEvent.NET_STATUS,this.connectOnStatus);
         }
         this.nextConnect(null);
         return false;
      }
      
      private function nextConnect(event:Event) : void
      {
         var tempProtocol:String = null;
         var port:String = null;
         var i:Number = NaN;
         this.tryNCTimer.reset();
         if(this.connTypeCounter == 0)
         {
            tempProtocol = this.protocol;
            if(Boolean(this.portNumber))
            {
               port = this.portNumber;
            }
            else
            {
               for(i = 0; i < RTMP_CONN.length; i++)
               {
                  if(this.protocol == RTMP_CONN[i].protocol)
                  {
                     port = RTMP_CONN[i].port;
                     break;
                  }
               }
            }
         }
         else
         {
            tempProtocol = RTMP_CONN[this.connTypeCounter].protocol;
            port = RTMP_CONN[this.connTypeCounter].port;
         }
         var connectionURL:String = tempProtocol + (!this.serverName ? "" : "/" + this.serverName + ":" + port + "/") + (!this.wrappedURL ? "" : this.wrappedURL + "/") + this.appName;
         this.tryNC[this.connTypeCounter].client.pending = true;
         this.tryNC[this.connTypeCounter].connect(connectionURL,this.autoSenseBW);
         if(this.connTypeCounter < RTMP_CONN.length - 1)
         {
            ++this.connTypeCounter;
            this.tryNCTimer.start();
         }
      }
      
      private function cleanConns() : void
      {
         var i:uint = 0;
         if(this.tryNCTimer != null)
         {
            this.tryNCTimer.reset();
            this.tryNCTimer = null;
         }
         if(Boolean(this.tryNC))
         {
            for(i = 0; i < this.tryNC.length; i++)
            {
               if(Boolean(this.tryNC[i]))
               {
                  this.tryNC[i].removeEventListener(NetStatusEvent.NET_STATUS,this.connectOnStatus);
                  if(Boolean(this.tryNC[i].client.pending))
                  {
                     this.tryNC[i].addEventListener(NetStatusEvent.NET_STATUS,this.disconnectOnStatus);
                  }
                  else
                  {
                     this.tryNC[i].close();
                  }
               }
               this.tryNC[i] = null;
            }
            this.tryNC = null;
         }
      }
      
      private function tryFallBack() : void
      {
         if(this.serverName == this.fallbackServerName || !this.fallbackServerName)
         {
            this._netConnection = null;
            this.ncConnected = false;
            this.owner.ncConnected();
         }
         else
         {
            this.connTypeCounter = 0;
            this.cleanConns();
            this.serverName = this.fallbackServerName;
            this.connectRTMP();
         }
      }
      
      public function onReconnected() : void
      {
         this._netConnection.removeEventListener(NetStatusEvent.NET_STATUS,this.connectOnStatus);
         this.ncConnected = true;
         this.owner.ncReconnected();
      }
      
      public function onConnected(p_nc:NetConnection, p_bw:Number) : void
      {
         var sSplit:Array = null;
         var i:uint = 0;
         var sName:String = null;
         var res:Responder = null;
         this.connectionTimer.reset();
         p_nc.removeEventListener(NetStatusEvent.NET_STATUS,this.connectOnStatus);
         this._netConnection = p_nc;
         this.ncURI = this._netConnection.uri;
         this.ncConnected = true;
         if(this.autoSenseBW)
         {
            this._bitrate = p_bw * 1024;
            if(Boolean(this.streams))
            {
               this.bitrateMatch();
            }
            else
            {
               sSplit = this._streamName.split(",");
               for(i = 0; i < sSplit.length; i += 2)
               {
                  sName = sSplit[i].replace(/^\s*(\S.*\S)\s*$/,"$1");
                  if(i + 1 >= sSplit.length)
                  {
                     this._streamName = sName;
                     break;
                  }
                  if(p_bw <= Number(sSplit[i + 1]))
                  {
                     this._streamName = sName;
                     break;
                  }
               }
               if(this._streamName.slice(-5).toLowerCase() == ".flv2")
               {
                  this._streamName = this._streamName.slice(0,-5);
               }
               else if(this._streamName.slice(-4).toLowerCase() == ".flv")
               {
                  this._streamName = this._streamName.slice(0,-4);
               }
            }
         }
         if(!this.owner.isLive && this._streamLength == -1 && this.owner.autoBandWidthDetection)
         {
            res = new Responder(this.getStreamLengthResult,this.getStreamLengthStatus);
            this._netConnection.call("getStreamLength",res,this._streamName);
         }
         else
         {
            this.owner.ncConnected();
         }
      }
      
      public function connectOnStatus(event:NetStatusEvent) : void
      {
         var stuff:Object = null;
         var target:NetConnection = NetConnection(event.target);
         target.client.pending = false;
         if(event.info.code == "NetConnection.Connect.Success")
         {
            this._netConnection = this.tryNC[target.client.connIndex];
            if(!this.owner.autoBandWidthDetection)
            {
               this.onConnected(this._netConnection,0);
            }
            this.tryNC[target.client.connIndex] = null;
            this.cleanConns();
         }
         else if((event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Rejected") && target.client.connIndex == RTMP_CONN.length - 1)
         {
            if(!this.connectAgain())
            {
               this.tryFallBack();
            }
         }
      }
      
      public function reconnectOnStatus(event:NetStatusEvent) : void
      {
         if(event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Rejected")
         {
            this._netConnection = null;
            this.ncConnected = false;
            this.owner.ncReconnected();
         }
      }
      
      public function disconnectOnStatus(event:NetStatusEvent) : void
      {
         if(event.info.code == "NetConnection.Connect.Success")
         {
            event.target.removeEventListener(NetStatusEvent.NET_STATUS,this.disconnectOnStatus);
            NetConnection(event.target).close();
         }
      }
      
      private function getStreamLengthResult(length:Number) : void
      {
         if(length > 0)
         {
            this._streamLength = length;
         }
         this.owner.ncConnected();
      }
      
      private function getStreamLengthStatus(item:Object) : void
      {
      }
      
      private function onFCSConnectTimeOut(event:Event) : void
      {
         this.cleanConns();
         this._netConnection = null;
         this.ncConnected = false;
         if(!this.connectAgain())
         {
            this.owner.ncConnected();
         }
      }
      
      private function canReuseOldConnection(parseResults:Object) : Boolean
      {
         if(this._netConnection == null || !this.ncConnected)
         {
            return false;
         }
         if(!parseResults.isRTMP)
         {
            if(!this._isRTMP)
            {
               return true;
            }
            this.owner.close();
            this._netConnection = null;
            this.ncConnected = false;
            this.initNCInfo();
            return false;
         }
         if(Boolean(this._isRTMP))
         {
            if(parseResults.serverName == this.serverName && parseResults.appName == this.appName && parseResults.protocol == this.protocol && parseResults.portNumber == this.portNumber && parseResults.wrappedURL == this.wrappedURL)
            {
               return true;
            }
            this.owner.close();
            this._netConnection = null;
            this.ncConnected = false;
         }
         this.initNCInfo();
         return false;
      }
   }
}

