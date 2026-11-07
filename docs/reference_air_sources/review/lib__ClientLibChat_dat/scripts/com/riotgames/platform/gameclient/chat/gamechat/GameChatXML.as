package com.riotgames.platform.gameclient.chat.gamechat
{
   import flash.utils.Dictionary;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class GameChatXML extends XMLStanza
   {
      
      public static const ENTRY_NODE_TYPE:String = "type";
      
      public static const ENTRY_NODE_SUMMONER_NAME:String = "summoner";
      
      public static const ENTRY_NODE_SUMMONER_MESSAGE:String = "message";
      
      public static const ENTRY_NODE_AAS_MESSAGE:String = "aasMessage";
      
      public static const ENTRY_NODE_BUDDY:String = "buddy";
      
      public static const CHAT_TYPE_MESSAGE_RECIEVED:String = "rcvMessage";
      
      public static const CHAT_TYPE_BUDDY_LIST_UPDATE:String = "updBuddyList";
      
      public static const CHAT_TYPE_IGNORE_LIST_UPDATE:String = "updIgnoreList";
      
      public static const CHAT_TYPE_AAS_NOTIFICATION:String = "aasNotification";
      
      public static const CHAT_TYPE_TOGGLE_IGNORE:String = "toggleIgnore";
      
      public static const CHAT_TYPE_MESSAGE_SEND:String = "sndMessage";
      
      public static const CHAT_TYPE_REQUEST_UPDATE:String = "rqUpdate";
      
      private var nodesCreated:Dictionary = new Dictionary();
      
      public function GameChatXML()
      {
         super();
      }
      
      public function getBuddy() : XMLNode
      {
         return null;
      }
      
      private function udpateEntry(param1:String, param2:String) : void
      {
         this.nodesCreated[param1] = this.replaceTextNode(this.getNode(),this.nodesCreated[param1],param1,param2);
      }
      
      public function parseXML(param1:String) : void
      {
         var _loc4_:XMLNode = null;
         var _loc2_:XMLDocument = new XMLDocument();
         _loc2_.parseXML(param1);
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_.childNodes)
         {
            _loc3_.push(_loc4_);
         }
         for each(_loc4_ in _loc3_)
         {
            getNode().appendChild(_loc4_);
         }
      }
      
      public function getStringValue(param1:String) : String
      {
         return this.getTextNodeValue(param1);
      }
      
      private function getTextNodeValue(param1:String) : String
      {
         var _loc3_:XMLNode = null;
         var _loc2_:String = "";
         if(getNode() != null)
         {
            for each(_loc3_ in getNode().childNodes)
            {
               if(_loc3_.nodeName == param1)
               {
                  if(_loc3_.firstChild != null)
                  {
                     _loc2_ = _loc3_.firstChild.nodeValue;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function addBuddy(param1:String, param2:String) : void
      {
         var _loc3_:XMLNode = addTextNode(getNode(),ENTRY_NODE_BUDDY,param1);
      }
      
      public function setStringValue(param1:String, param2:String) : void
      {
         this.udpateEntry(param1,param2);
      }
   }
}

