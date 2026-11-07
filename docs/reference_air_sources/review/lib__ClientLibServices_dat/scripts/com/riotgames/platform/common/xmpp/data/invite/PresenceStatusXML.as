package com.riotgames.platform.common.xmpp.data.invite
{
   import flash.utils.Dictionary;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class PresenceStatusXML extends XMLStanza
   {
      
      public static var ELEMENT:String = "body";
      
      public static var ENTRY_STATUS_MSG:String = "statusMsg";
      
      public static var ENTRY_GAME_STATUS:String = "gameStatus";
      
      public static var ENTRY_PROFILE_ICON:String = "profileIcon";
      
      public static var ENTRY_CHAMPION_SKINNAME:String = "skinname";
      
      public static var ENTRY_PROFILE_WINS:String = "wins";
      
      public static var ENTRY_PROFILE_LEAVES:String = "leaves";
      
      public static var ENTRY_PROFILE_ODIN_WINS:String = "odinWins";
      
      public static var ENTRY_PROFILE_ODIN_LEAVES:String = "odinLeaves";
      
      public static var ENTRY_PROFILE_LEVEL:String = "level";
      
      public static var ENTRY_PROFILE_TIMESTAMP:String = "timeStamp";
      
      public static var ENTRY_PROFILE_RANKED_QUEUETYPE:String = "queueType";
      
      public static var ENTRY_PROFILE_RANKED_WINS:String = "rankedWins";
      
      public static var ENTRY_PROFILE_RANKED_LOSSES:String = "rankedLosses";
      
      public static var ENTRY_PROFILE_RANKED_RATING:String = "rankedRating";
      
      public static var ENTRY_PROFILE_RANKED_LEAGUE_NAME:String = "rankedLeagueName";
      
      public static var ENTRY_PROFILE_RANKED_LEAGUE_DIVISION:String = "rankedLeagueDivision";
      
      public static var ENTRY_PROFILE_RANKED_LEAGUE_TIER:String = "rankedLeagueTier";
      
      public static var ENTRY_PROFILE_RANKED_LEAGUE_QUEUE_TYPE:String = "rankedLeagueQueue";
      
      public static var ENTRY_PROFILE_TIER:String = "tier";
      
      public static var ENTRY_QUEUE_TYPE:String = "gameQueueType";
      
      public static var ENTRY_IS_OBSERVABLE:String = "isObservable";
      
      public static var ENTRY_DROP_IN_SPECTATE_GAME_ID:String = "dropInSpectateGameId";
      
      public static var ENTRY_FEATURED_GAME_DATA:String = "featuredGameData";
      
      public static var ENTRY_RANKED_SOLO_RESTRICTED:String = "rankedSoloRestricted";
      
      public static const GAME_STATUS_OUT_OF_GAME:String = "outOfGame";
      
      public static const GAME_STATUS_UNKNOWN:String = "unknown";
      
      public static const GAME_STATUS_HOSTING_NORMAL_GAME:String = "hostingNormalGame";
      
      public static const GAME_STATUS_HOSTING_RANKED_GAME:String = "hostingRankedGame";
      
      public static const GAME_STATUS_HOSTING_COOP_VS_AI_GAME:String = "hostingCoopVsAIGame";
      
      public static const GAME_STATUS_HOSTING_PRACTICE_GAME:String = "hostingPracticeGame";
      
      public static const GAME_STATUS_TEAM_SELECT:String = "teamSelect";
      
      public static const GAME_STATUS_WATCHING_REPLAY:String = "watchingReplay";
      
      public static const GAME_STATUS_IN_QUEUE:String = "inQueue";
      
      public static const GAME_STATUS_CHAMPION_SELECT:String = "championSelect";
      
      public static const GAME_STATUS_TUTORIAL:String = "tutorial";
      
      public static const GAME_STATUS_IN_SPECTATING:String = "spectating";
      
      public static const GAME_STATUS_IN_GAME:String = "inGame";
      
      public static const GAME_STATUS_IN_TEAM_BUILDER_LOBBY:String = "inTeamBuilder";
      
      private var nodesCreated:Dictionary;
      
      public function PresenceStatusXML(param1:String = null)
      {
         var result:XMLDocument = null;
         var xmlString:String = param1;
         this.nodesCreated = new Dictionary();
         super();
         try
         {
            if(xmlString != null)
            {
               result = new XMLDocument();
               result.ignoreWhite = true;
               result.parseXML(xmlString);
               setNode(result.firstChild);
            }
            else
            {
               super.getNode().nodeName = ELEMENT;
               this.setGameType(GAME_STATUS_OUT_OF_GAME);
            }
         }
         catch(e:Error)
         {
            super.getNode().nodeName = ELEMENT;
         }
      }
      
      public static function isGameLobbyStatus(param1:String) : *
      {
         return param1 == GAME_STATUS_HOSTING_NORMAL_GAME || param1 == GAME_STATUS_HOSTING_RANKED_GAME || param1 == GAME_STATUS_HOSTING_COOP_VS_AI_GAME || param1 == GAME_STATUS_HOSTING_PRACTICE_GAME || param1 == GAME_STATUS_TEAM_SELECT || param1 == GAME_STATUS_IN_TEAM_BUILDER_LOBBY;
      }
      
      public static function getStatusPrecedence(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case GAME_STATUS_OUT_OF_GAME:
               _loc2_ = 0;
               break;
            case GAME_STATUS_UNKNOWN:
               _loc2_ = 5;
               break;
            case GAME_STATUS_WATCHING_REPLAY:
               _loc2_ = 10;
               break;
            case GAME_STATUS_HOSTING_NORMAL_GAME:
            case GAME_STATUS_HOSTING_RANKED_GAME:
            case GAME_STATUS_HOSTING_COOP_VS_AI_GAME:
            case GAME_STATUS_HOSTING_PRACTICE_GAME:
            case GAME_STATUS_TEAM_SELECT:
            case GAME_STATUS_IN_TEAM_BUILDER_LOBBY:
               _loc2_ = 20;
               break;
            case GAME_STATUS_IN_QUEUE:
               _loc2_ = 30;
               break;
            case GAME_STATUS_CHAMPION_SELECT:
            case GAME_STATUS_TUTORIAL:
            case GAME_STATUS_IN_SPECTATING:
            case GAME_STATUS_IN_GAME:
               _loc2_ = 40;
         }
         return _loc2_;
      }
      
      public static function getStatusShowMode(param1:String) : String
      {
         var _loc2_:String = Presence.SHOW_CHAT;
         switch(param1)
         {
            case GAME_STATUS_OUT_OF_GAME:
            case GAME_STATUS_WATCHING_REPLAY:
            case GAME_STATUS_HOSTING_NORMAL_GAME:
            case GAME_STATUS_HOSTING_RANKED_GAME:
            case GAME_STATUS_HOSTING_COOP_VS_AI_GAME:
            case GAME_STATUS_HOSTING_PRACTICE_GAME:
            case GAME_STATUS_TEAM_SELECT:
            case GAME_STATUS_IN_TEAM_BUILDER_LOBBY:
               _loc2_ = Presence.SHOW_CHAT;
               break;
            case GAME_STATUS_UNKNOWN:
            case GAME_STATUS_IN_QUEUE:
            case GAME_STATUS_CHAMPION_SELECT:
            case GAME_STATUS_TUTORIAL:
            case GAME_STATUS_IN_SPECTATING:
            case GAME_STATUS_IN_GAME:
               _loc2_ = Presence.SHOW_DND;
         }
         return _loc2_;
      }
      
      public function setProfileIcon(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_ICON,param1);
      }
      
      public function setLeagueQueueType(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_RANKED_LEAGUE_QUEUE_TYPE,param1);
      }
      
      public function getGameType() : String
      {
         return this.getTextNodeValue(ENTRY_GAME_STATUS);
      }
      
      public function setIntValue(param1:String, param2:int) : void
      {
         this.updateEntry(param1,param2.toString());
      }
      
      public function setLeagueDivision(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_RANKED_LEAGUE_DIVISION,param1);
      }
      
      public function getLeagueQueueType() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_RANKED_LEAGUE_QUEUE_TYPE);
      }
      
      public function setRankedSoloRestricted(param1:Boolean) : void
      {
         this.updateEntry(ENTRY_RANKED_SOLO_RESTRICTED,param1.toString());
      }
      
      public function setLevel(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_LEVEL,param1);
      }
      
      public function setSkinname(param1:String) : void
      {
         this.updateEntry(ENTRY_CHAMPION_SKINNAME,param1);
      }
      
      public function getProfileIcon() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_ICON);
      }
      
      public function getWins() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_WINS);
      }
      
      public function getLevel() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_LEVEL);
      }
      
      public function isRankedSoloRestricted() : Boolean
      {
         return this.getTextNodeValue(ENTRY_RANKED_SOLO_RESTRICTED).toLowerCase() == "true";
      }
      
      public function getLeagueName() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_RANKED_LEAGUE_NAME);
      }
      
      public function getLeaves() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_LEAVES);
      }
      
      public function setFeaturedGameData(param1:String) : void
      {
         this.setStringValue(ENTRY_FEATURED_GAME_DATA,param1);
      }
      
      public function setTimestamp(param1:Number) : void
      {
         this.updateEntry(ENTRY_PROFILE_TIMESTAMP,param1.toString());
      }
      
      public function setGameType(param1:String) : void
      {
         var _loc2_:Date = null;
         this.updateEntry(ENTRY_GAME_STATUS,param1);
         if(param1 == GAME_STATUS_IN_QUEUE || param1 == GAME_STATUS_IN_GAME)
         {
            _loc2_ = new Date();
            this.setTimestamp(_loc2_.time);
         }
      }
      
      public function getFeaturedGameData() : String
      {
         return this.getStringValue(ENTRY_FEATURED_GAME_DATA);
      }
      
      public function setWins(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_WINS,param1);
      }
      
      public function getIntValue(param1:String) : int
      {
         var _loc2_:String = this.getTextNodeValue(param1);
         if(_loc2_ == null || _loc2_ == "")
         {
            return 0;
         }
         return int(_loc2_);
      }
      
      public function setDropInSpectatorId(param1:String) : void
      {
         this.setStringValue(ENTRY_DROP_IN_SPECTATE_GAME_ID,param1);
      }
      
      public function setLeagueName(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_RANKED_LEAGUE_NAME,param1);
      }
      
      public function setLeaves(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_LEAVES,param1);
      }
      
      public function setLeagueTier(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_RANKED_LEAGUE_TIER,param1);
      }
      
      public function setIsGameObservable(param1:String) : void
      {
         this.setStringValue(ENTRY_IS_OBSERVABLE,param1);
      }
      
      public function getIsGameObservable() : String
      {
         return this.getStringValue(ENTRY_IS_OBSERVABLE);
      }
      
      public function setStringValue(param1:String, param2:String) : void
      {
         this.updateEntry(param1,param2);
      }
      
      public function getDropInSpectatorId() : String
      {
         return this.getStringValue(ENTRY_DROP_IN_SPECTATE_GAME_ID);
      }
      
      public function getOdinWins() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_ODIN_WINS);
      }
      
      public function setQueueType(param1:String) : void
      {
         this.updateEntry(ENTRY_QUEUE_TYPE,param1);
      }
      
      public function getStringValue(param1:String) : String
      {
         return this.getTextNodeValue(param1);
      }
      
      public function getOdinLeaves() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_ODIN_LEAVES);
      }
      
      public function getTimestamp() : Number
      {
         return Number(this.getTextNodeValue(ENTRY_PROFILE_TIMESTAMP));
      }
      
      private function updateEntry(param1:String, param2:String) : void
      {
         this.nodesCreated[param1] = this.replaceTextNode(this.getNode(),this.nodesCreated[param1],param1,param2);
      }
      
      public function getLeagueDivision() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_RANKED_LEAGUE_DIVISION);
      }
      
      public function setOdinWins(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_ODIN_WINS,param1);
      }
      
      public function getQueueType() : String
      {
         return this.getTextNodeValue(ENTRY_QUEUE_TYPE);
      }
      
      public function getLeagueTier() : String
      {
         return this.getTextNodeValue(ENTRY_PROFILE_RANKED_LEAGUE_TIER);
      }
      
      public function setOdinLeaves(param1:String) : void
      {
         this.updateEntry(ENTRY_PROFILE_ODIN_LEAVES,param1);
      }
      
      public function setStatusMessage(param1:String) : void
      {
         this.updateEntry(ENTRY_STATUS_MSG,param1);
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
      
      public function getSkinname() : String
      {
         return this.getTextNodeValue(ENTRY_CHAMPION_SKINNAME);
      }
      
      public function getStatusMessage() : String
      {
         return this.getTextNodeValue(ENTRY_STATUS_MSG);
      }
   }
}

