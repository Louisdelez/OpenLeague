package com.riotgames.platform.common.xmpp.data.privatedata
{
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.privatedata.IPrivatePayload;
   
   public class RiotPrivateDataExtension implements IPrivatePayload
   {
      
      public static const NS:String = "http://www.riotgames.com/XEP-0049";
      
      public static const NAME:String = "riot-games";
      
      public static const REQUEST_NORMAL:int = 100;
      
      public static const REQUEST_CONNECTION_ERROR:int = 201;
      
      public static const RESPONSE_UNAVAILABLE:int = 503;
      
      public static const ELEMENT_MUC_SERVER_REQ:String = "muc-server-request";
      
      public static const ELEMENT_SERVER:String = "server";
      
      public static const ELEMENT_IP:String = "ip-address";
      
      public static const ELEMENT_PORT:String = "port";
      
      public static const ATTR_KEY:String = "key";
      
      public static const ATTR_TYPE:String = "type";
      
      private var _key:String;
      
      private var _serverPort:int = 0;
      
      private var _serverIpAddress:String;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _type:int;
      
      public function RiotPrivateDataExtension(param1:String = null, param2:int = 0)
      {
         super();
         this._key = param1;
         this._type = param2;
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(RiotPrivateDataExtension);
      }
      
      public function get serverPort() : int
      {
         return this._serverPort;
      }
      
      public function get serverIpAddress() : String
      {
         return this._serverIpAddress;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:XMLNode = null;
         var _loc2_:XMLNode = new XMLNode(1,ELEMENT_MUC_SERVER_REQ);
         _loc2_.attributes[ATTR_KEY] = this._key;
         _loc2_.attributes[ATTR_TYPE] = this._type;
         if(Boolean(this._serverIpAddress) && this._serverPort > 0)
         {
            _loc3_ = new XMLNode(1,ELEMENT_SERVER);
            _loc4_ = new XMLNode(1,ELEMENT_IP);
            _loc4_.nodeValue = this._serverIpAddress;
            _loc5_ = new XMLNode(1,ELEMENT_PORT);
            _loc5_.nodeValue = this._serverPort.toString();
            _loc3_.appendChild(_loc4_);
            _loc3_.appendChild(_loc5_);
            _loc2_.appendChild(_loc3_);
         }
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var riotGamesNode:XMLNode = null;
         var serverNode:XMLNode = null;
         var children:Array = null;
         var child:XMLNode = null;
         var serverIpNode:XMLNode = null;
         var serverPort:XMLNode = null;
         var node:XMLNode = param1;
         try
         {
            riotGamesNode = node.firstChild;
            this._key = riotGamesNode.attributes[ATTR_KEY];
            this._type = riotGamesNode.attributes[ATTR_TYPE];
         }
         catch(error:Error)
         {
            logger.error("MucServerRequestPayload.deserialize Failed to parse Private Data stanza [" + error + "]");
            return false;
         }
         try
         {
            serverNode = riotGamesNode.firstChild;
            if(Boolean(serverNode) && serverNode.nodeName == ELEMENT_SERVER)
            {
               children = serverNode.childNodes;
               for each(child in children)
               {
                  if(child.nodeName == ELEMENT_IP)
                  {
                     serverIpNode = child.firstChild;
                     if(Boolean(serverIpNode))
                     {
                        this._serverIpAddress = serverIpNode.nodeValue;
                     }
                  }
                  if(child.nodeName == ELEMENT_PORT)
                  {
                     serverPort = child.firstChild;
                     if(Boolean(serverPort))
                     {
                        this._serverPort = parseInt(serverPort.nodeValue);
                     }
                  }
               }
            }
         }
         catch(error:Error)
         {
         }
         return true;
      }
      
      public function getElementName() : String
      {
         return NAME;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function getNS() : String
      {
         return NS;
      }
      
      public function get key() : String
      {
         return this._key;
      }
   }
}

