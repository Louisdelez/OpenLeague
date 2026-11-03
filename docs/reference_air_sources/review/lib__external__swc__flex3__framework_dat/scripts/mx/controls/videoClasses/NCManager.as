package mx.controls.videoClasses
{
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.net.Responder;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   [ExcludeClass]
   public class NCManager implements INCManager
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
      
      private var connectionTimer:Timer;
      
      private var _timeout:uint;
      
      private var portNumber:String;
      
      private var _bitrate:Number;
      
      private var contentPath:String;
      
      private var appName:String;
      
      private var _netConnection:NetConnection;
      
      private var _streamLength:Number;
      
      private var _streamWidth:Number;
      
      private var serverName:String;
      
      private var tryNCTimer:Timer;
      
      private var ncURI:String;
      
      public var payload:uint;
      
      private var connTypeCounter:uint;
      
      private var protocol:String;
      
      private var _streamHeight:Number;
      
      private var wrappedURL:String;
      
      private var _isRTMP:int = -1;
      
      public var tryNC:Array;
      
      private var owner:VideoPlayer;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _streamName:String;
      
      private var autoSenseBW:Boolean;
      
      private var ncConnected:Boolean;
      
      public var fallbackServerName:String;
      
      private var streams:Array;
      
      public function NCManager()
      {
         super();
         initNCInfo();
         initOtherInfo();
         owner = null;
         _netConnection = null;
         ncConnected = false;
         timeout = DEFAULT_TIMEOUT;
      }
      
      private function getStreamLengthStatus(item:Object) : void
      {
      }
      
      private function initNCInfo() : void
      {
         _isRTMP = -1;
         serverName = null;
         wrappedURL = null;
         portNumber = null;
         appName = null;
      }
      
      public function get streamWidth() : Number
      {
         return _streamWidth;
      }
      
      public function reconnectOnStatus(event:NetStatusEvent) : void
      {
         if(event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Rejected")
         {
            _netConnection = null;
            ncConnected = false;
            owner.ncReconnected();
         }
      }
      
      public function get streamName() : String
      {
         return _streamName;
      }
      
      public function connectToURL(url:String) : Boolean
      {
         var canReuseRTMP:Boolean = false;
         var canReuseHTTP:Boolean = false;
         initOtherInfo();
         contentPath = url;
         if(!contentPath || contentPath == "")
         {
            throw new VideoError(VideoError.INVALID_CONTENT_PATH);
         }
         var parseResults:Object = parseURL(contentPath);
         if(!parseResults.streamName || parseResults.streamName == "")
         {
            throw new VideoError(VideoError.INVALID_CONTENT_PATH,url);
         }
         if(Boolean(parseResults.isRTMP))
         {
            canReuseRTMP = canReuseOldConnection(parseResults);
            _isRTMP = 1;
            protocol = parseResults.protocol;
            _streamName = parseResults.streamName;
            serverName = parseResults.serverName;
            wrappedURL = parseResults.wrappedURL;
            portNumber = parseResults.portNumber;
            appName = parseResults.appName;
            if(!appName || appName == "" || !_streamName || _streamName == "")
            {
               throw new VideoError(VideoError.INVALID_CONTENT_PATH,url);
            }
            autoSenseBW = _streamName.indexOf(",") >= 0;
            return canReuseRTMP || connectRTMP();
         }
         canReuseHTTP = canReuseOldConnection(parseResults);
         _isRTMP = 0;
         _streamName = parseResults.streamName;
         return canReuseHTTP || connectHTTP();
      }
      
      private function getStreamLengthResult(length:Number) : void
      {
         if(length > 0)
         {
            _streamLength = length;
         }
         owner.ncConnected();
      }
      
      public function get videoPlayer() : VideoPlayer
      {
         return owner;
      }
      
      private function canReuseOldConnection(parseResults:Object) : Boolean
      {
         if(_netConnection == null || !ncConnected)
         {
            return false;
         }
         if(!parseResults.isRTMP)
         {
            if(!_isRTMP)
            {
               return true;
            }
            owner.close();
            _netConnection = null;
            ncConnected = false;
            initNCInfo();
            return false;
         }
         if(Boolean(_isRTMP))
         {
            if(parseResults.serverName == serverName && parseResults.appName == appName && parseResults.protocol == protocol && parseResults.portNumber == portNumber && parseResults.wrappedURL == wrappedURL)
            {
               return true;
            }
            owner.close();
            _netConnection = null;
            ncConnected = false;
         }
         initNCInfo();
         return false;
      }
      
      private function connectRTMP() : Boolean
      {
         connectionTimer.reset();
         connectionTimer.start();
         tryNC = [];
         tryNCTimer = new Timer(DEFAULT_NC_TIMEOUT);
         tryNCTimer.addEventListener(TimerEvent.TIMER,nextConnect);
         for(var i:uint = 0; i < RTMP_CONN.length; i++)
         {
            tryNC[i] = new NetConnection();
            tryNC[i].objectEncoding = ObjectEncoding.AMF0;
            tryNC[i].client = new NCManagerConnectClient(tryNC[i],this,i);
            tryNC[i].addEventListener(NetStatusEvent.NET_STATUS,connectOnStatus);
         }
         nextConnect(null);
         return false;
      }
      
      public function reconnect() : void
      {
         var message:String = null;
         if(!_isRTMP)
         {
            message = resourceManager.getString("controls","invalidCall");
            throw new Error(message);
         }
         _netConnection.addEventListener(NetStatusEvent.NET_STATUS,reconnectOnStatus);
         _netConnection.client = new NCManagerReconnectClient(this);
         _netConnection.connect(ncURI,false);
      }
      
      private function bitrateMatch() : void
      {
         var whichStream:Number = NaN;
         var checkBitrate:Number = _bitrate;
         if(isNaN(checkBitrate))
         {
            checkBitrate = 0;
         }
         for(var j:uint = 0; j < streams.length; j++)
         {
            if(isNaN(streams[j].bitrate) || checkBitrate >= streams[j].bitrate)
            {
               whichStream = j;
               break;
            }
         }
         if(isNaN(whichStream))
         {
            throw new VideoError(VideoError.NO_BITRATE_MATCH);
         }
         if(Boolean(_streamName))
         {
            _streamName += streams[whichStream].src;
         }
         else
         {
            _streamName = streams[whichStream].src;
         }
         _streamLength = streams[whichStream].dur;
      }
      
      public function get netConnection() : NetConnection
      {
         return _netConnection;
      }
      
      public function get timeout() : uint
      {
         return _timeout;
      }
      
      public function disconnectOnStatus(event:NetStatusEvent) : void
      {
         if(event.info.code == "NetConnection.Connect.Success")
         {
            event.target.removeEventListener(NetStatusEvent.NET_STATUS,disconnectOnStatus);
            NetConnection(event.target).close();
         }
      }
      
      private function connectHTTP() : Boolean
      {
         _netConnection = new NetConnection();
         _netConnection.objectEncoding = ObjectEncoding.AMF0;
         _netConnection.connect(null);
         ncConnected = true;
         return true;
      }
      
      private function nextConnect(event:Event) : void
      {
         var tempProtocol:String = null;
         var port:String = null;
         var i:Number = NaN;
         tryNCTimer.reset();
         if(connTypeCounter == 0)
         {
            tempProtocol = protocol;
            if(Boolean(portNumber))
            {
               port = portNumber;
            }
            else
            {
               for(i = 0; i < RTMP_CONN.length; i++)
               {
                  if(protocol == RTMP_CONN[i].protocol)
                  {
                     port = RTMP_CONN[i].port;
                     break;
                  }
               }
            }
         }
         else
         {
            tempProtocol = RTMP_CONN[connTypeCounter].protocol;
            port = RTMP_CONN[connTypeCounter].port;
         }
         var connectionURL:String = tempProtocol + (!serverName ? "" : "/" + serverName + ":" + port + "/") + (!wrappedURL ? "" : wrappedURL + "/") + appName;
         tryNC[connTypeCounter].client.pending = true;
         tryNC[connTypeCounter].connect(connectionURL,autoSenseBW);
         if(connTypeCounter < RTMP_CONN.length - 1)
         {
            ++connTypeCounter;
            tryNCTimer.start();
         }
      }
      
      public function set videoPlayer(value:VideoPlayer) : void
      {
         owner = value;
      }
      
      public function get bitrate() : Number
      {
         return _bitrate;
      }
      
      public function get streamLength() : Number
      {
         return _streamLength;
      }
      
      public function isRTMP() : Boolean
      {
         return _isRTMP != 0;
      }
      
      public function connectAgain() : Boolean
      {
         var slashIndex:Number = appName.indexOf("/");
         if(slashIndex < 0)
         {
            slashIndex = _streamName.indexOf("/");
            if(slashIndex >= 0)
            {
               appName += "/";
               appName += _streamName.slice(0,slashIndex);
               _streamName = _streamName.slice(slashIndex + 1);
            }
            return false;
         }
         var newStreamName:String = appName.slice(slashIndex + 1);
         newStreamName += "/";
         newStreamName += _streamName;
         _streamName = newStreamName;
         appName = appName.slice(0,slashIndex);
         close();
         payload = 0;
         connTypeCounter = 0;
         cleanConns();
         connectRTMP();
         return true;
      }
      
      private function initOtherInfo() : void
      {
         contentPath = null;
         _streamName = null;
         _streamLength = -1;
         _streamWidth = -1;
         _streamHeight = -1;
         streams = null;
         autoSenseBW = false;
         payload = 0;
         connTypeCounter = 0;
         cleanConns();
      }
      
      public function connectOnStatus(event:NetStatusEvent) : void
      {
         var stuff:Object = null;
         var target:NetConnection = NetConnection(event.target);
         target.client.pending = false;
         if(event.info.code == "NetConnection.Connect.Success")
         {
            _netConnection = tryNC[target.client.connIndex];
            if(!owner.autoBandWidthDetection)
            {
               onConnected(_netConnection,0);
            }
            tryNC[target.client.connIndex] = null;
            cleanConns();
         }
         else if((event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Rejected") && target.client.connIndex == RTMP_CONN.length - 1)
         {
            if(!connectAgain())
            {
               tryFallBack();
            }
         }
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
               subParseResults = parseURL(subURL);
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
      
      public function set timeout(t:uint) : void
      {
         _timeout = t;
         connectionTimer = new Timer(_timeout,1);
         connectionTimer.addEventListener(TimerEvent.TIMER,onFCSConnectTimeOut);
      }
      
      public function get streamHeight() : Number
      {
         return _streamHeight;
      }
      
      private function onFCSConnectTimeOut(event:Event) : void
      {
         cleanConns();
         _netConnection = null;
         ncConnected = false;
         if(!connectAgain())
         {
            owner.ncConnected();
         }
      }
      
      public function onReconnected() : void
      {
         _netConnection.removeEventListener(NetStatusEvent.NET_STATUS,connectOnStatus);
         ncConnected = true;
         owner.ncReconnected();
      }
      
      public function set bitrate(b:Number) : void
      {
         if(_isRTMP == 0)
         {
            _bitrate = b;
         }
      }
      
      private function tryFallBack() : void
      {
         if(serverName == fallbackServerName || !fallbackServerName)
         {
            _netConnection = null;
            ncConnected = false;
            owner.ncConnected();
         }
         else
         {
            connTypeCounter = 0;
            cleanConns();
            serverName = fallbackServerName;
            connectRTMP();
         }
      }
      
      public function onConnected(p_nc:NetConnection, p_bw:Number) : void
      {
         var sSplit:Array = null;
         var i:uint = 0;
         var sName:String = null;
         var res:Responder = null;
         connectionTimer.reset();
         p_nc.removeEventListener(NetStatusEvent.NET_STATUS,connectOnStatus);
         _netConnection = p_nc;
         ncURI = _netConnection.uri;
         ncConnected = true;
         if(autoSenseBW)
         {
            _bitrate = p_bw * 1024;
            if(Boolean(streams))
            {
               bitrateMatch();
            }
            else
            {
               sSplit = _streamName.split(",");
               for(i = 0; i < sSplit.length; i += 2)
               {
                  sName = sSplit[i].replace(/^\s*(\S.*\S)\s*$/,"$1");
                  if(i + 1 >= sSplit.length)
                  {
                     _streamName = sName;
                     break;
                  }
                  if(p_bw <= Number(sSplit[i + 1]))
                  {
                     _streamName = sName;
                     break;
                  }
               }
               if(_streamName.slice(-5).toLowerCase() == ".flv2")
               {
                  _streamName = _streamName.slice(0,-5);
               }
               else if(_streamName.slice(-4).toLowerCase() == ".flv")
               {
                  _streamName = _streamName.slice(0,-4);
               }
            }
         }
         if(!owner.isLive && _streamLength == -1 && owner.autoBandWidthDetection)
         {
            res = new Responder(getStreamLengthResult,getStreamLengthStatus);
            _netConnection.call("getStreamLength",res,_streamName);
         }
         else
         {
            owner.ncConnected();
         }
      }
      
      public function close() : void
      {
         if(Boolean(_netConnection))
         {
            _netConnection.close();
            ncConnected = false;
         }
      }
      
      private function cleanConns() : void
      {
         var i:uint = 0;
         if(tryNCTimer != null)
         {
            tryNCTimer.reset();
            tryNCTimer = null;
         }
         if(Boolean(tryNC))
         {
            for(i = 0; i < tryNC.length; i++)
            {
               if(Boolean(tryNC[i]))
               {
                  tryNC[i].removeEventListener(NetStatusEvent.NET_STATUS,connectOnStatus);
                  if(Boolean(tryNC[i].client.pending))
                  {
                     tryNC[i].addEventListener(NetStatusEvent.NET_STATUS,disconnectOnStatus);
                  }
                  else
                  {
                     tryNC[i].close();
                  }
               }
               tryNC[i] = null;
            }
            tryNC = null;
         }
      }
   }
}

