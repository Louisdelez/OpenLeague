package com.riotgames.platform.common.xmpp.data.rankedTeams
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class RankedTeamXMLStanza extends XMLStanza
   {
      
      private static const ELEMENT:String = "body";
      
      private static const ENTRY_MSG_TYPE:String = "msgType";
      
      public static const TEAM_ID:String = "teamId";
      
      public static const TEAM_NAME:String = "teamName";
      
      public static const SUMMONER_NAME:String = "summonerName";
      
      public static const RANKED_TEAM_INVITE:String = "invited";
      
      public static const RANKED_TEAM_REVOKE_INVITE:String = "revoked_invite";
      
      public static const RANKED_TEAM_KICKED:String = "kicked";
      
      public static const RANKED_TEAM_NOTIFY_JOIN:String = "notifyJoin";
      
      public static const RANKED_TEAM_NOTIFY_LEFT:String = "notifyLeft";
      
      public static const RANKED_TEAM_NOTIFY_DECLINE_INVITE:String = "notifyDeclineInvite";
      
      public static const RANKED_TEAM_NOTIFY_NEW_OWNER:String = "notifyNewOwner";
      
      public function RankedTeamXMLStanza(param1:String = null)
      {
         var _loc2_:XMLDocument = null;
         super();
         if(param1 != null)
         {
            _loc2_ = new XMLDocument();
            _loc2_.ignoreWhite = true;
            _loc2_.parseXML(param1);
            setNode(_loc2_.firstChild);
         }
         else
         {
            super.getNode().nodeName = ELEMENT;
         }
      }
      
      public function setTeamName(param1:String) : void
      {
         addTextNode(getNode(),TEAM_NAME,param1);
      }
      
      public function getMsgType() : String
      {
         return this.getTextNodeValue(ENTRY_MSG_TYPE);
      }
      
      public function setMsgType(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_MSG_TYPE,param1);
      }
      
      public function setTeamId(param1:String) : void
      {
         addTextNode(getNode(),TEAM_ID,param1);
      }
      
      public function setSummonerName(param1:String) : void
      {
         addTextNode(getNode(),SUMMONER_NAME,param1);
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
      
      public function getTeamName() : String
      {
         return this.getTextNodeValue(TEAM_NAME);
      }
      
      public function getTeamId() : String
      {
         return this.getTextNodeValue(TEAM_ID);
      }
      
      public function getSummonerName() : String
      {
         return this.getTextNodeValue(SUMMONER_NAME);
      }
   }
}

