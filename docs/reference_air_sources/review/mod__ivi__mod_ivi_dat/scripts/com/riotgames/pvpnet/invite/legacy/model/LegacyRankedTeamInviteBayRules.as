package com.riotgames.pvpnet.invite.legacy.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.configurations.GuestSlotsConfig;
   import com.riotgames.pvpnet.invite.legacy.controller.InviteBayController;
   import com.riotgames.pvpnet.invite.legacy.controller.LegacyRankedTeamInviteController;
   import com.riotgames.pvpnet.invite.legacy.enum.InviteSectionTypeEnums;
   import com.riotgames.pvpnet.invite.rules.IInviteBayRules;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class LegacyRankedTeamInviteBayRules extends EventDispatcher implements IInviteBayRules
   {
      
      private var _sectionLockedChangedSignal:Signal = new Signal();
      
      private var _availableInviteesChangedSignal:Signal = new Signal();
      
      private var _numGuestSlotsUsed:int = 0;
      
      private var _rankedTeamManagementController:LegacyRankedTeamInviteController;
      
      private var _sectionLocked:Boolean = false;
      
      private var availablePlayersCache:ArrayCollection;
      
      private var _numGuestSlots:int = 0;
      
      private var _teamNames:ArrayCollection;
      
      private var _numGuestSlotsChangedSignal:Signal = new Signal();
      
      private var _sectionChangedSignal:Signal = new Signal();
      
      private var _dataProvider:ArrayCollection;
      
      private var availablePlayersGuests:ArrayCollection;
      
      private var _logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var cachedTeams:Array = null;
      
      private var _numGuestSlotsUsedChangedSignal:Signal = new Signal();
      
      private var _sectionIndex:int = 0;
      
      private var _gameQueueManager:GameQueueManager;
      
      private var requestedTeamIdUpdate:TeamId = null;
      
      private var _inviteBay:ArrayCollection;
      
      private var _inviteController:IInviteController;
      
      private var _invitableBuddyListFilterString:String = "";
      
      private var _allowGuestInvites:Boolean = false;
      
      public function LegacyRankedTeamInviteBayRules(param1:ArrayCollection, param2:IChatRosterProvider, param3:IInviteController, param4:LegacyRankedTeamInviteController, param5:GameQueueManager)
      {
         super();
         this.availableInviteBay = param1;
         this._chatRosterProvider = param2;
         this._inviteController = param3;
         this._rankedTeamManagementController = param4;
         this._gameQueueManager = param5;
         this.populateTeamNames();
         this.updateSectionLocked();
         if(this.sectionIndex == 0)
         {
            this._rankedTeamManagementController.setLastSelectedTeam(this.findTeamSummaryByIndex(this._sectionIndex));
            this.createAvailableInvitees();
         }
      }
      
      private function set _630014189sectionIndex(param1:int) : void
      {
         if(this.sectionLocked || param1 == this._sectionIndex)
         {
            return;
         }
         this._sectionIndex = param1;
         this._rankedTeamManagementController.setLastSelectedTeam(this.findTeamSummaryByIndex(this._sectionIndex));
         this.createAvailableInvitees();
         this._sectionChangedSignal.dispatch();
      }
      
      public function isPlayerGuest(param1:Number) : Boolean
      {
         return this._rankedTeamManagementController.isPlayerGuest(param1);
      }
      
      private function updateSectionLocked() : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc1_:Boolean = false;
         if(this._gameQueueManager.rankedTeamName != GameQueueManager.TEAM_NAME_UNSELECTED)
         {
            _loc2_ = int(this.sectionNames.getItemIndex(this._gameQueueManager.rankedTeamName));
            if(_loc2_ > -1)
            {
               this.sectionIndex = _loc2_;
               _loc1_ = true;
               this._gameQueueManager.getRankedTeamNameChangedSignal().remove(this.onRankedTeamNameChanged);
               this.availableInviteBay.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onAvailableInviteBayCollectionChanged);
            }
            else
            {
               _loc3_ = "RankedTeamInviteBayRules::updateSectionLocked. We have selected a team we don\'t know about, shouldnt be possible! Team: " + this._gameQueueManager.rankedTeamName;
               this._logger.error(_loc3_);
            }
         }
         if(!_loc1_)
         {
            this._gameQueueManager.getRankedTeamNameChangedSignal().add(this.onRankedTeamNameChanged);
            if(this.availableInviteBay.length > 0)
            {
               _loc1_ = true;
            }
            this.availableInviteBay.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onAvailableInviteBayCollectionChanged);
         }
         if(this._sectionLocked != _loc1_)
         {
            this._sectionLocked = _loc1_;
            dispatchEvent(new Event("sectionLockedChanged"));
            this._sectionLockedChangedSignal.dispatch();
         }
      }
      
      public function getSectionChangedSignal() : ISignal
      {
         return this._sectionChangedSignal;
      }
      
      public function set availableInviteBay(param1:ArrayCollection) : void
      {
         if(this._inviteBay == param1)
         {
            return;
         }
         this._inviteBay = param1;
         dispatchEvent(new Event("availableInviteBayChanged"));
      }
      
      private function populateTeamNames() : void
      {
         var _loc2_:TeamInfo = null;
         var _loc1_:Array = new Array();
         if(this._rankedTeamManagementController.teamPlayer)
         {
            for each(_loc2_ in this._rankedTeamManagementController.teamPlayer.playerTeams)
            {
               if(_loc2_.memberStatusString == TeamMemberStatus.MEMBER)
               {
                  _loc1_.push(_loc2_.name);
               }
            }
         }
         this._teamNames = new ArrayCollection(_loc1_);
         this._sectionChangedSignal.dispatch();
      }
      
      private function onRankedTeamNameChanged(param1:String) : void
      {
         this.updateSectionLocked();
      }
      
      private function set _1937536867numGuestSlots(param1:int) : void
      {
         this._numGuestSlots = param1;
         this._numGuestSlotsChangedSignal.dispatch();
      }
      
      private function onAvailableInviteBayCollectionChanged(param1:CollectionEvent) : void
      {
         this.updateSectionLocked();
      }
      
      private function getRosterItemForPlayer(param1:String, param2:Number) : RosterItemVO
      {
         var _loc4_:UnescapedJID = null;
         var _loc3_:RosterItemVO = this._chatRosterProvider.getBuddyBySummonerId(param2);
         if(_loc3_ == null)
         {
            _loc4_ = ChatController.unescapedJIDFromSummonerId(param2);
            _loc3_ = RosterItemVO.get(_loc4_,true);
            _loc3_.online = true;
            _loc3_.displayName = param1;
            _loc3_.show = Presence.SHOW_CHAT;
         }
         return _loc3_;
      }
      
      private function fillBuddyList() : void
      {
         this.availablePlayersGuests.source = this._chatRosterProvider.getAllRosterItems();
      }
      
      public function get sectionLocked() : Boolean
      {
         return this._sectionLocked;
      }
      
      public function filterAvailableInviteList(param1:String) : void
      {
         this._invitableBuddyListFilterString = param1.toLowerCase();
         this.refreshAvailableInvitees();
      }
      
      public function get availableInvitees() : ArrayCollection
      {
         return this._dataProvider;
      }
      
      public function getSectionLockedChangedSignal() : ISignal
      {
         return this._sectionLockedChangedSignal;
      }
      
      public function invitePlayers(param1:ArrayCollection) : void
      {
         var _loc4_:TeamId = null;
         var _loc5_:Team = null;
         var _loc2_:String = this.sectionNames.getItemAt(this.sectionIndex) as String;
         var _loc3_:Boolean = false;
         if(this.cachedTeams)
         {
            for each(_loc5_ in this.cachedTeams)
            {
               if(_loc5_.name == _loc2_)
               {
                  _loc4_ = _loc5_.teamId;
                  _loc3_ = true;
                  break;
               }
            }
         }
         if(_loc3_)
         {
            this._inviteController.checkAddInviteParticipantsToRankedTeam(param1.toArray(),_loc2_,_loc4_);
         }
         else
         {
            this._logger.error("RankedTeamInviteBayRules.invitePlayers we could not find the cached team so we could invite the player! TeamName: " + _loc2_);
         }
      }
      
      public function get sectionNames() : ArrayCollection
      {
         return this._teamNames;
      }
      
      private function set _2061456517allowGuestInvites(param1:Boolean) : void
      {
         this._allowGuestInvites = param1;
         this.createAvailableInvitees();
      }
      
      public function get allowGuestInvites() : Boolean
      {
         return this._allowGuestInvites;
      }
      
      private function set _402362944numGuestSlotsUsed(param1:int) : void
      {
         this._numGuestSlotsUsed = param1;
         this._numGuestSlotsUsedChangedSignal.dispatch();
      }
      
      public function set numGuestSlotsUsed(param1:int) : void
      {
         var _loc2_:Object = this.numGuestSlotsUsed;
         if(_loc2_ !== param1)
         {
            this._402362944numGuestSlotsUsed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numGuestSlotsUsed",_loc2_,param1));
         }
      }
      
      private function calculateNumberOfGuestSlots(param1:String, param2:String) : void
      {
         var _loc3_:LeagueItemDTO = null;
         for each(_loc3_ in ServiceProxy.instance.leagueService.cache.myLeagueStandings)
         {
            if(_loc3_.queueType == param2 && _loc3_.playerOrTeamName == param1)
            {
               this.numGuestSlots = DynamicClientConfigManager.getConfiguration(GuestSlotsConfig.NAMESPACE,GuestSlotsConfig.getSlotCountEnumForQueueAndTier(param2,_loc3_.tier),0).getValue() as int;
               return;
            }
         }
         this.numGuestSlots = DynamicClientConfigManager.getConfiguration(GuestSlotsConfig.NAMESPACE,GuestSlotsConfig.getSlotCountEnumForQueueAndTier(param2,"NoSeeding"),0).getValue() as int;
      }
      
      private function findTeamSummaryByIndex(param1:int) : Team
      {
         var _loc3_:Team = null;
         var _loc2_:Team = null;
         if(Boolean(this.sectionNames) && Boolean(param1 < this.sectionNames.length) && Boolean(this._rankedTeamManagementController.teamPlayer))
         {
            for each(_loc3_ in this._rankedTeamManagementController.teamPlayer.teamsSummary)
            {
               if(_loc3_.name == this.sectionNames[param1])
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      private function onTeamUpdateSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         if(!_loc2_)
         {
            return;
         }
         if(!this.cachedTeams)
         {
            this.cachedTeams = new Array();
         }
         this.cachedTeams.push(_loc2_);
         if(_loc2_.teamId.fullId != this.requestedTeamIdUpdate.fullId)
         {
            return;
         }
         this.populateInviteesWithTeam(_loc2_);
      }
      
      public function get availableInviteBay() : ArrayCollection
      {
         return this._inviteBay;
      }
      
      public function getNumGuestSlotsUsedChangedSignal() : ISignal
      {
         return this._numGuestSlotsUsedChangedSignal;
      }
      
      private function populateAvailableInvitees(param1:TeamId) : void
      {
         var _loc3_:Team = null;
         var _loc2_:Boolean = false;
         if(this.cachedTeams)
         {
            for each(_loc3_ in this.cachedTeams)
            {
               if(_loc3_.teamId.fullId == param1.fullId)
               {
                  this.populateInviteesWithTeam(_loc3_);
                  _loc2_ = true;
                  break;
               }
            }
         }
         if(!_loc2_)
         {
            this.requestedTeamIdUpdate = param1;
            this._rankedTeamManagementController.findTeamById(param1,this.onTeamUpdateSuccess);
         }
      }
      
      private function findTeamInfoByIndex(param1:int) : TeamInfo
      {
         var _loc3_:TeamInfo = null;
         var _loc2_:TeamInfo = null;
         if(Boolean(this.sectionNames) && Boolean(this.sectionIndex < this.sectionNames.length) && Boolean(this._rankedTeamManagementController.teamPlayer))
         {
            for each(_loc3_ in this._rankedTeamManagementController.teamPlayer.playerTeams)
            {
               if(_loc3_.name == this.sectionNames[param1] && _loc3_.memberStatusString == TeamMemberStatus.MEMBER)
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function get numGuestSlots() : int
      {
         return this._numGuestSlots;
      }
      
      private function inCollection(param1:ArrayCollection, param2:RosterItemVO) : Boolean
      {
         var _loc3_:RosterItemVO = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.uid == param2.uid)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getInvitableBuddyListFilterString() : String
      {
         return this._invitableBuddyListFilterString;
      }
      
      public function get sectionType() : String
      {
         return InviteSectionTypeEnums.SECTION_TYPE_COMBOBOX;
      }
      
      public function set availableInvitees(param1:ArrayCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         this._dataProvider = param1;
         this._availableInviteesChangedSignal.dispatch();
         dispatchEvent(new Event("availableInviteesChanged"));
      }
      
      public function get sectionLockedTooltip() : String
      {
         return ResourceManager.getInstance().getString("resources","rankedGame_arrangedTeam_rankedTeam_sectionLocked");
      }
      
      private function createAvailableInvitees() : void
      {
         var _loc2_:ArrayCollection = null;
         var _loc1_:TeamInfo = this.findTeamInfoByIndex(this.sectionIndex);
         if(!_loc1_)
         {
            return;
         }
         if(!this.availableInvitees)
         {
            _loc2_ = new ArrayCollection();
            _loc2_.filterFunction = this.inviteesFilter;
            this.availableInvitees = _loc2_;
         }
         else
         {
            this.availableInvitees.source = [];
            this.availableInvitees.refresh();
         }
         this.availablePlayersCache = new ArrayCollection();
         this.availablePlayersCache.sort = new Sort();
         this.availablePlayersCache.sort.compareFunction = InviteBayController.alphabeticalCompareRosterItems;
         this.availablePlayersGuests = new ArrayCollection();
         this.availablePlayersGuests.sort = new Sort();
         this.availablePlayersGuests.sort.compareFunction = InviteBayController.alphabeticalCompareRosterItems;
         this.populateAvailableInvitees(_loc1_.teamId);
         if(DynamicClientConfigManager.getConfiguration(GuestSlotsConfig.NAMESPACE,GuestSlotsConfig.ENABLED,false).getValue() as Boolean)
         {
            this.calculateNumberOfGuestSlots(_loc1_.name,this._gameQueueManager.selectedGameQueueConfig.type);
         }
      }
      
      public function refreshAvailableInvitees() : void
      {
         if(this.availableInvitees)
         {
            this.createAvailableInvitees();
         }
      }
      
      public function get allowInviteByName() : Boolean
      {
         return false;
      }
      
      public function set numGuestSlots(param1:int) : void
      {
         var _loc2_:Object = this.numGuestSlots;
         if(_loc2_ !== param1)
         {
            this._1937536867numGuestSlots = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numGuestSlots",_loc2_,param1));
         }
      }
      
      private function mergeInvitees() : void
      {
         this.availablePlayersCache.refresh();
         this.availablePlayersGuests.refresh();
         this.addInviteeList(this.availablePlayersCache);
         if(this._allowGuestInvites)
         {
            this.addInviteeList(this.availablePlayersGuests);
         }
      }
      
      public function get numGuestSlotsUsed() : int
      {
         return this._numGuestSlotsUsed;
      }
      
      private function addInviteeList(param1:ArrayCollection) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            if(!this.inCollection(this.availableInvitees,param1[_loc2_]))
            {
               this.availableInvitees.addItem(param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function set sectionIndex(param1:int) : void
      {
         var _loc2_:Object = this.sectionIndex;
         if(_loc2_ !== param1)
         {
            this._630014189sectionIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sectionIndex",_loc2_,param1));
         }
      }
      
      public function getNumGuestSlotsChangedSignal() : ISignal
      {
         return this._numGuestSlotsChangedSignal;
      }
      
      private function inviteesFilter(param1:Object) : Boolean
      {
         var _loc2_:RosterItemVO = param1 as RosterItemVO;
         if(!_loc2_)
         {
            return false;
         }
         if(this.isPlayerFiltered(_loc2_))
         {
            return false;
         }
         if(this._inviteController.hasAlreadyInvited(_loc2_))
         {
            return false;
         }
         if(InviteBayController.isInAvailableList(_loc2_,this.availableInviteBay))
         {
            return false;
         }
         if(!RosterUtility.isOnlineAndAvailableForInvite(_loc2_))
         {
            return false;
         }
         return true;
      }
      
      public function isPlayerFiltered(param1:RosterItemVO) : Boolean
      {
         if(this.getInvitableBuddyListFilterString() != null && this.getInvitableBuddyListFilterString() != "" && param1.displayName.toLowerCase().search(this.getInvitableBuddyListFilterString()) < 0)
         {
            return true;
         }
         return false;
      }
      
      private function populateInviteesWithTeam(param1:Team) : void
      {
         var _loc2_:TeamMemberInfo = null;
         if(!this.availableInvitees)
         {
            return;
         }
         this.availableInvitees.source = [];
         this.availableInvitees.refresh();
         this.availablePlayersCache.removeAll();
         this.availablePlayersGuests.removeAll();
         for each(_loc2_ in param1.roster.memberList)
         {
            if(_loc2_.status == TeamMemberStatus.MEMBER && _loc2_.playerId != this._rankedTeamManagementController.teamPlayer.playerId)
            {
               this.availablePlayersCache.addItem(this.getRosterItemForPlayer(_loc2_.playerName,_loc2_.playerId));
            }
         }
         if(this._allowGuestInvites)
         {
            this.fillBuddyList();
         }
         this.mergeInvitees();
         this.availableInvitees.refresh();
      }
      
      public function get sectionIndex() : int
      {
         return this._sectionIndex;
      }
      
      public function getAvailableInviteesChangedSignal() : ISignal
      {
         return this._availableInviteesChangedSignal;
      }
      
      public function set allowGuestInvites(param1:Boolean) : void
      {
         var _loc2_:Object = this.allowGuestInvites;
         if(_loc2_ !== param1)
         {
            this._2061456517allowGuestInvites = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowGuestInvites",_loc2_,param1));
         }
      }
   }
}

