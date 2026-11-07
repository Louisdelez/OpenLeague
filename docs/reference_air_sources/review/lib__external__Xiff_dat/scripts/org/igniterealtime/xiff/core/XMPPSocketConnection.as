package org.igniterealtime.xiff.core
{
   import com.hurlant.crypto.tls.TLSConfig;
   import com.hurlant.crypto.tls.TLSEngine;
   import com.hurlant.crypto.tls.TLSSocket;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.util.SocketConn;
   import org.igniterealtime.xiff.util.SocketDataEvent;
   
   public class XMPPSocketConnection extends XMPPConnection
   {
      
      private static const logger:ILogger = Log.getLogger("org.igniterealtime.xiff.core.XMPPSocketConnection");
      
      private var _incompleteRawXML:String = "";
      
      protected var binarySocket:SocketConn;
      
      public function XMPPSocketConnection()
      {
         super();
      }
      
      private function configureSocket() : void
      {
         var _loc1_:TLSConfig = null;
         if(!useSSL)
         {
            this.binarySocket = new SocketConn();
         }
         else
         {
            _loc1_ = new TLSConfig(TLSEngine.CLIENT);
            _loc1_.acceptSelfSignedCert = _acceptSelfSignedCert;
            this.binarySocket = new TLSSocket(_loc1_);
         }
         this.binarySocket.addEventListener(Event.CLOSE,socketClosed);
         this.binarySocket.addEventListener(Event.CONNECT,socketConnected);
         this.binarySocket.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         this.binarySocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
         this.binarySocket.addEventListener(SocketDataEvent.SOCKET_DATA_RECEIVED,this.bSocketReceivedData);
      }
      
      override protected function sendXML(param1:*) : void
      {
         this.binarySocket.sendString(param1);
         var _loc2_:OutgoingDataEvent = new OutgoingDataEvent();
         _loc2_.data = param1;
         dispatchEvent(_loc2_);
      }
      
      override public function disconnect() : void
      {
         var _loc1_:DisconnectionEvent = null;
         if(isActive())
         {
            this.sendXML(closingStreamTag);
            this.binarySocket.close();
            active = false;
            loggedIn = false;
            _loc1_ = new DisconnectionEvent();
            dispatchEvent(_loc1_);
         }
      }
      
      override public function connect(param1:String = "terminatedStandard") : Boolean
      {
         if(this.binarySocket != null && this.binarySocket.connected)
         {
            this.binarySocket.removeEventListener(Event.CLOSE,socketClosed);
            this.binarySocket.removeEventListener(Event.CONNECT,socketConnected);
            this.binarySocket.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
            this.binarySocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
            this.binarySocket.removeEventListener(SocketDataEvent.SOCKET_DATA_RECEIVED,this.bSocketReceivedData);
            this.binarySocket.flush();
            this.binarySocket.close();
            this.binarySocket = null;
         }
         this.configureSocket();
         active = false;
         loggedIn = false;
         switch(param1)
         {
            case "flash":
               openingStreamTag = "<?xml version=\"1.0\"?><flash:stream to=\"" + domain + "\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\" version=\"1.0\">";
               closingStreamTag = "</flash:stream>";
               break;
            case "terminatedFlash":
               openingStreamTag = "<?xml version=\"1.0\"?><flash:stream to=\"" + domain + "\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\" version=\"1.0\" />";
               closingStreamTag = "</flash:stream>";
               break;
            case "standard":
               openingStreamTag = "<?xml version=\"1.0\"?><stream:stream to=\"" + domain + "\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">";
               closingStreamTag = "</stream:stream>";
               break;
            case "terminatedStandard":
            default:
               openingStreamTag = "<?xml version=\"1.0\"?><stream:stream to=\"" + domain + "\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\" />";
               closingStreamTag = "</stream:stream>";
         }
         this.binarySocket.connect(server,port);
         return true;
      }
      
      protected function bSocketReceivedData(param1:SocketDataEvent) : void
      {
         var xmlData:XMLDocument;
         var pattern:RegExp = null;
         var resultObj:Object = null;
         var pattern2:RegExp = null;
         var resultObj2:Object = null;
         var isComplete:Boolean = false;
         var event:IncomingDataEvent = null;
         var i:int = 0;
         var currentNode:XMLNode = null;
         var nodeName:String = null;
         var ev:SocketDataEvent = param1;
         var rawXML:String = this._incompleteRawXML + ev.data as String;
         if(!_expireTagSearch)
         {
            pattern = /<flash:stream/;
            resultObj = pattern.exec(rawXML);
            if(resultObj != null)
            {
               rawXML = rawXML.concat("</flash:stream>");
               _expireTagSearch = true;
            }
         }
         if(!_expireTagSearch)
         {
            pattern2 = /<stream:stream/;
            resultObj2 = pattern2.exec(rawXML);
            if(resultObj2 != null)
            {
               rawXML = rawXML.concat("</stream:stream>");
               _expireTagSearch = true;
            }
         }
         xmlData = new XMLDocument();
         xmlData.ignoreWhite = this.ignoreWhite;
         try
         {
            isComplete = true;
            xmlData.parseXML(rawXML);
            this._incompleteRawXML = "";
         }
         catch(err:Error)
         {
            isComplete = false;
            _incompleteRawXML += ev.data as String;
         }
         if(isComplete)
         {
            event = new IncomingDataEvent();
            event.data = xmlData;
            dispatchEvent(event);
            i = 0;
            while(i < xmlData.childNodes.length)
            {
               currentNode = xmlData.childNodes[i];
               nodeName = currentNode.nodeName.toLowerCase();
               switch(nodeName)
               {
                  case "stream:stream":
                     _expireTagSearch = false;
                     handleStream(currentNode);
                     break;
                  case "flash:stream":
                     _expireTagSearch = false;
                     handleStream(currentNode);
                     break;
                  case "stream:error":
                     handleStreamError(currentNode);
                     break;
                  case "iq":
                     handleIQ(currentNode);
                     break;
                  case "message":
                     handleMessage(currentNode);
                     break;
                  case "presence":
                     handlePresence(currentNode);
                     break;
                  case "stream:features":
                     handleStreamFeatures(currentNode);
                     break;
                  case "success":
                     handleAuthentication(currentNode);
                     break;
                  case "failure":
                     handleAuthentication(currentNode);
                     break;
                  default:
                     dispatchError("undefined-condition","Unknown Error","modify",500);
               }
               i++;
            }
         }
      }
   }
}

