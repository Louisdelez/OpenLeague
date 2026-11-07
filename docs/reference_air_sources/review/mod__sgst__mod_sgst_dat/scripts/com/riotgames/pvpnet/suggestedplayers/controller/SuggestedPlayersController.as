package com.riotgames.pvpnet.suggestedplayers.controller
{
   import blix.action.IAction;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.invite.validator.SendInviteValidator;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import com.riotgames.pvpnet.suggestedplayers.factory.SuggestedPlayersServiceCallFactory;
   import com.riotgames.pvpnet.suggestedplayers.model.FriendOfFriendEntry;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayersModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class SuggestedPlayersController implements ISuggestedPlayersProvider
   {
      
      private var _session:Session;
      
      private var _model:SuggestedPlayersModel;
      
      private var _inviteGroup:InviteGroup;
      
      private var _serviceCallFactory:SuggestedPlayersServiceCallFactory;
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var _inviteValidator:SendInviteValidator;
      
      private var _currentListIndex:int;
      
      private var _whitespaceRegex:RegExp = /[\s\r\n]+/gi;
      
      private var _currentSuggestedPlayersList:Array;
      
      private var _gameQueueConfig:GameQueueConfig;
      
      private var _callback:Function;
      
      public function SuggestedPlayersController(param1:Session, param2:SuggestedPlayersModel, param3:InviteGroup, param4:SuggestedPlayersServiceCallFactory)
      {
         super();
         this._session = param1;
         this._model = param2;
         this._inviteGroup = param3;
         this._inviteValidator = new SendInviteValidator();
         this._model.maxNumVisibleSuggestedPlayers = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","MaxNumSuggestedPlayers",8).getInt();
         this._model.maxNumReplacements = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","MaxNumReplacements",22).getInt();
         this._model.maxNumPreviousPremades = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","PreviousPremadesLimit",4).getInt();
         this._model.maxNumOnlineFriends = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","OnlineFriendsLimit",4).getInt();
         this._model.maxNumHonoredPlayers = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","HonoredPlayersLimit",4).getInt();
         this._model.maxNumVictoriousComrades = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","VictoriousComradesLimit",4).getInt();
         this._model.maxNumFriendsOfFriends = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","FriendsOfFriendsLimit",4).getInt();
         this._serviceCallFactory = param4;
      }
      
      public function setChatRosterProvider(param1:IChatRosterProvider) : void
      {
         this._chatRosterProvider = param1;
      }
      
      public function getSuggestedPlayerModels(param1:GameQueueConfig, param2:Function) : void
      {
         var _loc5_:IAction = null;
         var _loc3_:Number = -1;
         this._gameQueueConfig = param1;
         this._callback = param2;
         if(this._gameQueueConfig)
         {
            _loc3_ = Number(this._gameQueueConfig.id);
         }
         var _loc4_:Boolean = Boolean(DynamicClientConfigManager.getConfiguration("SuggestedPlayers","FriendsOfFriendsEnabled",false).getBoolean());
         if(_loc4_)
         {
            _loc5_ = this._serviceCallFactory.getFriendsOfFriendsAction(_loc3_);
            _loc5_.getErred().addOnce(this.handleFriendsOfFriendsUnavailable);
            _loc5_.getCompleted().addOnce(this.handleFriendsOfFriendsData);
            _loc5_.invoke();
         }
         else
         {
            this.buildAndSendList();
         }
      }
      
      private function handleFriendsOfFriendsUnavailable() : void
      {
         this.buildAndSendList();
      }
      
      private function handleFriendsOfFriendsData(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:FriendOfFriendEntry = null;
         var _loc4_:Vector.<FriendOfFriendEntry> = new Vector.<FriendOfFriendEntry>();
         for each(_loc2_ in param1)
         {
            _loc3_ = new FriendOfFriendEntry();
            _loc3_.summonerName = _loc2_.summonerName;
            _loc3_.summonerId = _loc2_.summonerId;
            _loc3_.commonFriendName = _loc2_.commonFriendName;
            _loc3_.commonFriendId = _loc2_.commonFriendId;
            _loc4_.push(_loc3_);
         }
         this._model.friendsOfFriends = _loc4_;
         this.buildAndSendList();
      }
      
      private function buildAndSendList() : void
      {
         var _loc1_:ArrayCollection = null;
         if(this._callback != null)
         {
            _loc1_ = this.buildList();
            this._callback.call(this,_loc1_);
            this._callback = null;
         }
      }
      
      private function buildList() : ArrayCollection
      {
         var _loc1_:ArrayCollection = new ArrayCollection();
         this._currentListIndex = 0;
         this.addPreviousPremades(_loc1_);
         this.addOnlineFriends(_loc1_);
         this.addHonoredPlayers(_loc1_);
         this.addFriendsOfFriends(_loc1_);
         this.addVictoriousComradePlayers(_loc1_);
         _loc1_.filterFunction = this.suggestedPlayersFilterFunction;
         _loc1_.refresh();
         this._currentSuggestedPlayersList = _loc1_.source;
         return _loc1_;
      }
      
      private function addPreviousPremades(param1:ArrayCollection) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._model.previousPremadeNames)
         {
            if(_loc2_ == this._model.maxNumPreviousPremades)
            {
               return;
            }
            if(this.addSuggestedPlayer(param1,_loc3_,SuggestedPlayer.REASON_PREVIOUS_PREMADE))
            {
               _loc2_++;
               ++this._currentListIndex;
            }
         }
      }
      
      private function addOnlineFriends(param1:ArrayCollection) : void
      {
         var _loc4_:RosterItemVO = null;
         if(!this._chatRosterProvider)
         {
            return;
         }
         var _loc2_:Array = this.randomizeArray(this._chatRosterProvider.getAllRosterItems().concat());
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            if(_loc3_ == this._model.maxNumOnlineFriends)
            {
               return;
            }
            if(Boolean(_loc4_.online) && _loc4_.show == Presence.SHOW_CHAT)
            {
               if(this.addSuggestedPlayer(param1,_loc4_.displayName,SuggestedPlayer.REASON_ONLINE_FRIEND))
               {
                  _loc3_++;
                  ++this._currentListIndex;
               }
            }
         }
      }
      
      private function addFriendsOfFriends(param1:ArrayCollection) : void
      {
         var _loc3_:FriendOfFriendEntry = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._model.friendsOfFriends)
         {
            if(_loc2_ == this._model.maxNumFriendsOfFriends)
            {
               return;
            }
            if(this.addSuggestedPlayer(param1,_loc3_.summonerName,SuggestedPlayer.REASON_FRIEND_OF_FRIEND,_loc3_.commonFriendName,_loc3_.commonFriendId))
            {
               _loc2_++;
               ++this._currentListIndex;
            }
         }
      }
      
      private function addHonoredPlayers(param1:ArrayCollection) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._model.honoredNames)
         {
            if(_loc2_ == this._model.maxNumHonoredPlayers)
            {
               return;
            }
            if(this.addSuggestedPlayer(param1,_loc3_,SuggestedPlayer.REASON_HONORED))
            {
               _loc2_++;
               ++this._currentListIndex;
            }
         }
      }
      
      private function addVictoriousComradePlayers(param1:ArrayCollection) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._model.victoriousComradeNames)
         {
            if(_loc2_ == this._model.maxNumVictoriousComrades)
            {
               return;
            }
            if(this.addSuggestedPlayer(param1,_loc3_,SuggestedPlayer.REASON_VICTORIOUS_COMRADE))
            {
               _loc2_++;
               ++this._currentListIndex;
            }
         }
      }
      
      private function addSuggestedPlayer(param1:ArrayCollection, param2:String, param3:int, param4:String = null, param5:Number = -1) : Boolean
      {
         var _loc6_:SuggestedPlayer = null;
         if(param1.source.length >= this._model.maxNumVisibleSuggestedPlayers + this._model.maxNumReplacements)
         {
            return false;
         }
         if(this.playerIsEligibleForSuggestion(param1,param2))
         {
            _loc6_ = new SuggestedPlayer();
            _loc6_.summonerName = param2;
            _loc6_.suggestionReason = param3;
            _loc6_.commonFriendName = param4;
            _loc6_.commonFriendId = param5;
            _loc6_.visible = param1.source.length < this._model.maxNumVisibleSuggestedPlayers;
            param1.addItem(_loc6_);
            return true;
         }
         return false;
      }
      
      private function playerIsEligibleForSuggestion(param1:ArrayCollection, param2:String) : Boolean
      {
         return !this.playerHasBeenDeclined(param2) && !this.playerIsKnownToBeOffline(param2) && !this.playerIsAlreadySuggested(param1,param2) && !this.playerHasBeenReported(param2) && !this.playerDoesNotMeetQueueRequirements(param2);
      }
      
      private function playerHasBeenDeclined(param1:String) : Boolean
      {
         return this._model.declinedNamesDictionary[param1] != null;
      }
      
      private function playerIsKnownToBeOffline(param1:String) : Boolean
      {
         if(!this._chatRosterProvider)
         {
            return false;
         }
         var _loc2_:RosterItemVO = this._chatRosterProvider.findBuddyRosterItemByName(param1);
         if(_loc2_)
         {
            return Boolean(_loc2_) && !_loc2_.online;
         }
         return false;
      }
      
      private function playerDoesNotMeetQueueRequirements(param1:String) : Boolean
      {
         if(!this._chatRosterProvider)
         {
            return false;
         }
         var _loc2_:RosterItemVO = this._chatRosterProvider.findBuddyRosterItemByName(param1);
         if(!_loc2_)
         {
            return false;
         }
         if(Boolean(this._gameQueueConfig) && !this._inviteValidator.rosterItemMeetsLevelRequirement(_loc2_,this._gameQueueConfig))
         {
            return true;
         }
         return false;
      }
      
      private function playerIsAlreadySuggested(param1:ArrayCollection, param2:String) : Boolean
      {
         var _loc4_:SuggestedPlayer = null;
         var _loc3_:String = this.removeWhitespaceAndCase(param2);
         for each(_loc4_ in param1)
         {
            if(_loc3_ == this.removeWhitespaceAndCase(_loc4_.summonerName))
            {
               return true;
            }
         }
         return false;
      }
      
      private function playerHasBeenReported(param1:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:String = this.removeWhitespaceAndCase(param1);
         for each(_loc3_ in this._model.reportedPlayerNames)
         {
            if(_loc2_ == this.removeWhitespaceAndCase(_loc3_))
            {
               return true;
            }
         }
         return false;
      }
      
      private function removeWhitespaceAndCase(param1:String) : String
      {
         if(param1)
         {
            return param1.replace(this._whitespaceRegex,"").toLowerCase();
         }
         return "";
      }
      
      private function randomizeArray(param1:Array) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:* = int(param1.length - 1);
         while(_loc4_ >= 0)
         {
            _loc3_ = Math.random() * _loc4_;
            _loc2_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc3_];
            param1[_loc3_] = _loc2_;
            _loc4_--;
         }
         return param1;
      }
      
      public function declineSuggestedPlayerAndGetReplacement(param1:ArrayCollection, param2:SuggestedPlayer) : void
      {
         param2.visible = false;
         param2.declined = true;
         this._model.declinedNamesDictionary[param2.summonerName] = true;
         this.updateSuggestedPlayerVisibility(param1);
      }
      
      public function updateSuggestedPlayerVisibility(param1:ArrayCollection) : void
      {
         var _loc3_:SuggestedPlayer = null;
         param1.disableAutoUpdate();
         param1.filterFunction = null;
         param1.refresh();
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(!_loc3_.declined && !_loc3_.invited)
            {
               _loc3_.visible = _loc2_ < this._model.maxNumVisibleSuggestedPlayers;
               _loc2_++;
            }
         }
         param1.filterFunction = this.suggestedPlayersFilterFunction;
         param1.enableAutoUpdate();
         param1.refresh();
      }
      
      private function suggestedPlayersFilterFunction(param1:SuggestedPlayer) : Boolean
      {
         return param1.visible;
      }
      
      public function handleEndOfGameEvent(param1:EndOfGameStats) : void
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:Boolean = false;
         var _loc4_:PlayerParticipantStatsSummary = null;
         var _loc5_:PlayerParticipantStatsSummary = null;
         for each(_loc2_ in this._inviteGroup.acceptedParticipants)
         {
            if(!_loc2_.isOwner)
            {
               this._model.previousPremadeNames.unshift(_loc2_.name);
            }
         }
         _loc3_ = false;
         for each(_loc5_ in param1.teamPlayerParticipantStats)
         {
            if(_loc5_.userId == this._session.summoner.sumId)
            {
               _loc4_ = _loc5_;
               break;
            }
         }
         if(_loc4_)
         {
            _loc3_ = _loc4_.statistics != null && PlayerStat.findStat(RawStatType.WINS,_loc4_.statistics) != null;
            if(_loc3_)
            {
               for each(_loc5_ in param1.teamPlayerParticipantStats)
               {
                  if(_loc5_ != _loc4_ && !_loc5_.isBotPlayer())
                  {
                     if(this._model.victoriousComradeNames.indexOf(_loc5_.summonerName) == -1)
                     {
                        this._model.victoriousComradeNames.splice(0,0,_loc5_.summonerName);
                     }
                  }
               }
            }
         }
      }
      
      public function handlePlayerHonored(param1:String) : void
      {
         this._model.honoredNames.unshift(param1);
      }
      
      public function handlePlayerReported(param1:String) : void
      {
         this._model.reportedPlayerNames.push(param1);
      }
      
      public function notifyGameLaunched(param1:Number, param2:Number) : void
      {
         if(!this._currentSuggestedPlayersList)
         {
            return;
         }
         this.trackSuggestedPlayerMetrics(true,this._currentSuggestedPlayersList,param1,param2);
         this._currentSuggestedPlayersList = null;
      }
      
      public function notifyLobbyDisbanded(param1:Number) : void
      {
         if(!this._currentSuggestedPlayersList)
         {
            return;
         }
         this.trackSuggestedPlayerMetrics(false,this._currentSuggestedPlayersList,-1,param1);
         this._currentSuggestedPlayersList = null;
      }
      
      private function trackSuggestedPlayerMetrics(param1:Boolean, param2:Array, param3:Number = -1, param4:Number = -1) : void
      {
         var _loc5_:IAction = this._serviceCallFactory.getTrackSuggestedPlayersMetricsAction(param1,param2,this._inviteGroup.participants,param3,param4);
         _loc5_.invoke();
      }
   }
}

