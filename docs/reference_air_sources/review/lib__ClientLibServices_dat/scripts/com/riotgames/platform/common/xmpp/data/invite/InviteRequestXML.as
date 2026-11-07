package com.riotgames.platform.common.xmpp.data.invite
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class InviteRequestXML extends XMLStanza
   {
      
      public static var ELEMENT:String = "body";
      
      public static var ENTRY_INVITE_ID:String = "inviteId";
      
      public static var ENTRY_USER_NAME:String = "userName";
      
      public static var ENTRY_SUMMONER_ID:String = "summonerId";
      
      public static var ENTRY_ICON_ID:String = "profileIconId";
      
      public static var ENTRY_GAME_ID:String = "gameId";
      
      public static var ENTRY_GAME_PASSWORD:String = "gamePassword";
      
      public static var ENTRY_GAME_MODE:String = "gameMode";
      
      public static var ENTRY_MAP_ID:String = "mapId";
      
      public static var ENTRY_QUEUE_ID:String = "queueId";
      
      public static var ENTRY_GAME_TYPE:String = "gameType";
      
      public static var ENTRY_GAME_TYPE_INDEX:String = "gameTypeIndex";
      
      public static var ENTRY_GAME_DIFFICULTY:String = "gameDifficulty";
      
      public static var ENTRY_INVITE_REJECT_REASON:String = "rejectReason";
      
      public static var ENTRY_SUGGESTED_INVITE_JID:String = "suggestedInviteJid";
      
      public static var ENTRY_SUGGESTED_INVITE_NAME:String = "suggestedInviteName";
      
      public static var ENTRY_ORIGINAL_INVITOR:String = "originalInvitor";
      
      public static var ENTRY_TEAM_NAME:String = "teamName";
      
      public static var ENTRY_SEASON_REWARD_ICON:String = "seasonRewards";
      
      public static var REJECT_REASON_NOT_ENOUGH_CHAMPS:String = "notEnoughChamps";
      
      public static var REJECT_REASON_TOO_LOW_LEVEL:String = "tooLowLevel";
      
      public static var REJECT_REASON_SHUTDOWN_PRONE:String = "shutdownProne";
      
      public static var GROUP_ID:String = "groupId";
      
      public function InviteRequestXML(param1:String = null)
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
      
      public function getSuggestedInviteName() : String
      {
         return this.getTextNodeValue(ENTRY_SUGGESTED_INVITE_NAME);
      }
      
      public function getGameType() : String
      {
         var _loc1_:String = this.getTextNodeValue(ENTRY_GAME_TYPE);
         if(_loc1_ == "")
         {
            _loc1_ = null;
         }
         return _loc1_;
      }
      
      public function getGameDifficulty() : String
      {
         return this.getTextNodeValue(ENTRY_GAME_DIFFICULTY);
      }
      
      public function getGroupId() : String
      {
         return this.getTextNodeValue(GROUP_ID);
      }
      
      public function setRejectReason(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_INVITE_REJECT_REASON,param1);
      }
      
      public function setInviteId(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_INVITE_ID,param1);
      }
      
      public function getOriginalInvitor() : String
      {
         return this.getTextNodeValue(ENTRY_ORIGINAL_INVITOR);
      }
      
      public function getSeasonRewardIcon() : String
      {
         return this.getTextNodeValue(ENTRY_SEASON_REWARD_ICON);
      }
      
      public function getInviteId() : String
      {
         return this.getTextNodeValue(ENTRY_INVITE_ID);
      }
      
      public function getIconID() : int
      {
         return parseInt(this.getTextNodeValue(ENTRY_ICON_ID));
      }
      
      public function setSummonerId(param1:Number) : void
      {
         addTextNode(getNode(),ENTRY_SUMMONER_ID,param1.toString());
      }
      
      public function setSeasonRewardIcon(param1:int) : void
      {
         addTextNode(getNode(),ENTRY_SEASON_REWARD_ICON,param1.toString());
      }
      
      public function setGameType(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_GAME_TYPE,param1);
      }
      
      public function getSuggestedInviteJID() : String
      {
         return this.getTextNodeValue(ENTRY_SUGGESTED_INVITE_JID);
      }
      
      public function setGroupId(param1:String) : void
      {
         addTextNode(getNode(),GROUP_ID,param1);
      }
      
      public function setQueueId(param1:int) : void
      {
         addTextNode(getNode(),ENTRY_QUEUE_ID,param1.toString());
      }
      
      public function setMapId(param1:int) : void
      {
         addTextNode(getNode(),ENTRY_MAP_ID,param1.toString());
      }
      
      public function setIconID(param1:int) : void
      {
         addTextNode(getNode(),ENTRY_ICON_ID,param1.toString());
      }
      
      public function setTeamName(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_TEAM_NAME,param1);
      }
      
      public function setSuggestedInviteJID(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_SUGGESTED_INVITE_JID,param1);
      }
      
      public function getQueueId() : int
      {
         var _loc1_:int = 0;
         var _loc2_:String = this.getTextNodeValue(ENTRY_QUEUE_ID);
         if(_loc2_ != null)
         {
            _loc1_ = int(_loc2_);
         }
         return _loc1_;
      }
      
      public function setGameDifficulty(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_GAME_DIFFICULTY,param1);
      }
      
      public function getMapId() : int
      {
         var _loc1_:int = 0;
         var _loc2_:String = this.getTextNodeValue(ENTRY_MAP_ID);
         if(_loc2_ != null)
         {
            _loc1_ = int(_loc2_);
         }
         return _loc1_;
      }
      
      public function getGameId() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:String = this.getTextNodeValue(ENTRY_GAME_ID);
         if(_loc2_ != null)
         {
            _loc1_ = parseInt(_loc2_);
         }
         return _loc1_;
      }
      
      public function setGameTypeIndex(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_GAME_TYPE_INDEX,param1);
      }
      
      public function getGamePassword() : String
      {
         var _loc1_:String = this.getTextNodeValue(ENTRY_GAME_PASSWORD);
         if(_loc1_ == "")
         {
            _loc1_ = null;
         }
         return _loc1_;
      }
      
      public function getGameMode() : String
      {
         return this.getTextNodeValue(ENTRY_GAME_MODE);
      }
      
      public function getUserName() : String
      {
         return this.getTextNodeValue(ENTRY_USER_NAME);
      }
      
      public function setGamePassword(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_GAME_PASSWORD,param1);
      }
      
      public function getGameTypeIndex() : String
      {
         return this.getTextNodeValue(ENTRY_GAME_TYPE_INDEX);
      }
      
      public function setOriginalInvitor(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_ORIGINAL_INVITOR,param1);
      }
      
      public function setSuggestedInviteName(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_SUGGESTED_INVITE_NAME,param1);
      }
      
      public function setGameId(param1:Number) : void
      {
         addTextNode(getNode(),ENTRY_GAME_ID,param1.toString());
      }
      
      public function setGameMode(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_GAME_MODE,param1);
      }
      
      public function setUserName(param1:String) : void
      {
         addTextNode(getNode(),ENTRY_USER_NAME,param1);
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
         return this.getTextNodeValue(ENTRY_TEAM_NAME);
      }
      
      public function getSummonerId() : Number
      {
         return parseFloat(this.getTextNodeValue(ENTRY_SUMMONER_ID));
      }
   }
}

