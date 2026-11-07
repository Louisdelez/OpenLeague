package com.riotgames.platform.gameclient.chat.mediator
{
   import blix.ds.IListX;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.provider.ISpectatorProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.DefaultChatRoomLoader;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.NotificationsProviderProxy;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.BuddyGroup;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomInfo;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomListViewModel;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chat.model.ChatWindowModel;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.queuerestriction.configurations.QueueRestrictionConfiguration;
   import com.riotgames.pvpnet.queuerestriction.controller.IQueueRestrictionController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
   import com.riotgames.rust.data.ListAdapter;
   import com.riotgames.util.json.jsonDecode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.swizframework.core.ISwiz;
   import org.swizframework.core.ISwizAware;
   
   public class ChatViewMediatorImpl implements ChatViewMediator, ISwizAware, IEventDispatcher
   {
      
      private var _totalChatModels:ArrayCollection = new ArrayCollection();
      
      private var _chatWindows:ArrayCollection = new ArrayCollection();
      
      private var _1648354035chatRoomListViewModel:ChatRoomListViewModel;
      
      private var _friendTracker:IFriendListBehaviorTracker;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _gameQueueManager:GameQueueManager;
      
      private var groupChatHandler:IGroupChatHandler;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var _masterGameController:IMasterGameController;
      
      private var _currentChatModelSignal:Signal = new Signal();
      
      private var _chatController:ChatController;
      
      private var _inviteGroup:InviteGroup;
      
      private var _recentChatPrompts:ArrayCollection = new ArrayCollection();
      
      private var _chatPrompts:ArrayCollection = new ArrayCollection();
      
      private var _swiz:ISwiz;
      
      private var _spectatorProvider:ISpectatorProvider;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _queueRestrictionController:IQueueRestrictionController;
      
      private var _currentChatModel:Object;
      
      private var personalMessageHandler:IPersonalMessageHandler;
      
      private var _navigationController:ILegacyProfileNavigationProvider;
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var resourceManager:IResourceManager;
      
      private var _inviteController:IInviteController;
      
      public function ChatViewMediatorImpl()
      {
         super();
         this.resourceManager = ResourceManager.getInstance();
         ProviderLookup.getProvider(IInviteProvider,this.onGetInviteController);
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
         ProviderLookup.getProvider(ILegacyProfileNavigationProvider,this.onGetLegacyProfileNavigationProvider);
         ProviderLookup.getProvider(IMasterGameController,this.onGotMasterGameController);
         ProviderLookup.getProvider(ISpectatorProvider,this.onGotSpectatorProvider);
         ProviderLookup.getProvider(IGameQueueManager,this.onGotGameQueueManager);
         ProviderLookup.getProvider(IChatRosterProvider,this.onGotChatRosterProvider);
         ProviderLookup.publishProvider(ChatViewMediator,this);
      }
      
      private function onGotMasterGameController(param1:IMasterGameController) : void
      {
         this._masterGameController = param1;
      }
      
      public function getTotalChatViews() : ArrayCollection
      {
         return this._totalChatModels;
      }
      
      public function getCurrentStatusChanged() : ISignal
      {
         return this._chatController.presenceController.getCurrentShowChanged();
      }
      
      public function inviteBuddyToChat(param1:Buddy, param2:String = "pu", param3:String = null) : void
      {
         if(!param1)
         {
            return;
         }
         if(param3 == null)
         {
            param3 = this._chatController.currentUserChatRoomName;
         }
         var _loc4_:RosterItemVO = RosterUtility.getRosterItemVoFromJID(param1.getJID());
         this._chatController.inviteToChatRoom([_loc4_],param3,param2,null,false);
         if(this._friendTracker != null)
         {
            this._friendTracker.incrementFriendChatInviteSent_InASession();
         }
      }
      
      public function getOnlineBuddyCount() : int
      {
         return this._chatController.getOnlineBuddyCount();
      }
      
      private function handleCheckIsEligibleQueuePartner(param1:Boolean, param2:RosterItemVO) : *
      {
         if(param1)
         {
            this._inviteController.checkAddInviteParticipants([param2]);
            if(this._friendTracker != null)
            {
               this._friendTracker.incrementFriendGameInviteSent_InASession();
            }
         }
      }
      
      public function ignoreBuddy(param1:Buddy) : void
      {
         if(!param1)
         {
            return;
         }
         this._chatController.privacyListController.blockAndConfirm(param1.getJID(),param1.getName(),this.onBlockAndConfirmCompleted,{"name":param1.getName()});
      }
      
      private function removeAllChatAndBuddyWindows() : void
      {
         this._chatController.chatTracker.setChatWindowsOpenedAtOnce(this._totalChatModels.length);
         this.removeChatWindows();
      }
      
      private function onGotChatRosterProvider(param1:IChatRosterProvider) : void
      {
         this._chatRosterProvider = param1;
      }
      
      public function getSummonerStatusMessageChanged() : ISignal
      {
         return this._chatController.presenceController.getCurrentStatusMsgChanged();
      }
      
      public function ignoreBuddyBySummonerName(param1:String) : void
      {
         this._chatController.privacyListController.blockSummonerNameAndConfirm(param1);
      }
      
      public function getCurrentChatModelChanged() : ISignal
      {
         return this._currentChatModelSignal;
      }
      
      private function onChatSpamError(param1:String) : void
      {
         this.groupChatHandler.handleChatSpamError(param1);
      }
      
      public function getCurrentPresenceData() : PresenceStatusData
      {
         return this._chatController.presenceController.selfPresenceData;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function getOnlineBuddyCountChanged() : ISignal
      {
         return this._chatController.buddyListModel.onlineBuddyCountChanged;
      }
      
      public function closePersonalPopupWindow(param1:UnescapedJID) : void
      {
         this.personalMessageHandler.closePersonalPopupWindow(param1);
      }
      
      public function getSummonerNameChanged() : ISignal
      {
         return this._chatController.getChatDisplayNameChangedSignal();
      }
      
      [Bindable(event="propertyChange")]
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this.chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function joinInitialize() : void
      {
         if(Boolean(this._swiz) && Boolean(this._chatController))
         {
            this.personalMessageHandler = new IronPersonalMessageHandler(this._chatWindows,this._totalChatModels);
            this.groupChatHandler = new IronGroupChatHandler(this._totalChatModels);
            this._chatController.getChatDisplayNameChangedSignal().add(this.onDisplayNameChanged);
            this._chatController.getChatDisplayInviteRecievedSignal().add(this.onChatRoomInviteReceived);
            this._chatController.getChatOpenChatRoomViewSignal().add(this.onChatRoomViewOpenRequest);
            this._chatController.getChatInviteToGroupChatSignal().add(this.onInviteToGroupChatRequest);
            this._chatController.getChatCloseChatRoomSignal().add(this.closeChatRoom);
            this._chatController.getChatCloseAllChatRoomsSignal().add(this.closeAllChatRooms);
            this._chatController.getChatCloseMatchmakingQueueChatRoomSignal().add(this.closeChatRoom);
            this._chatController.getChatRemoveAllChatDisplaysSignal().add(this.removeAllChatAndBuddyWindows);
            this._chatController.getChatLoggingOutSignal().add(this.reset);
            this._chatController.getChatSystemInitializedSignal().add(this.initialize);
            this._chatController.getChatSpammerErrorSignal().add(this.onChatSpamError);
            this._chatController.getChatMessageReceivedSignal().add(this.onPersonalChatMessageReceived);
            ClientConfig.instance.localeSpecificChatRoomsSet.add(this.initializeChatRoomList);
            ClientConfig.instance.localeSpecificChatRoomsEnabledChanged.add(this.initializeChatRoomList);
            this.initializeChatRoomList();
         }
      }
      
      public function canDropInSpectateBuddy(param1:Buddy) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:Boolean = Boolean(param1.getIsOnline());
         _loc2_ = _loc2_ && !this._chatController.inGame || !this._masterGameController.currentState == GameViewState.TEAM_SELECTION || !this._masterGameController.currentGame == GameViewState.JOIN_QUEUE;
         return _loc2_ && Boolean(this._spectatorProvider.canDropInSpectate(param1.getPresence()));
      }
      
      private function closeChatRoom(param1:ChatRoom) : void
      {
         this.groupChatHandler.closeChatRoom(param1);
      }
      
      public function moveGroupUp(param1:BuddyGroup) : void
      {
         var _loc2_:String = param1.getLabel();
         this._chatController.moveGroupUp(_loc2_);
      }
      
      public function isCustomRosterGroup(param1:BuddyGroup) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:RosterGroup = this._chatController.roster.getGroup(param1.getLabel());
         return this._chatController.isCustomRosterGroup(_loc2_);
      }
      
      public function getOfflineGroupName() : String
      {
         return this._chatController.getOfflineGroupName();
      }
      
      public function cycleStatus() : void
      {
         this._chatController.presenceController.cycleShowMode();
      }
      
      public function updateRosterNoteOnBuddy(param1:Buddy, param2:String) : void
      {
         if(!param1)
         {
            return;
         }
         this._chatController.updateRosterNote(RosterUtility.getRosterItemVoFromJID(param1.getJID()),param2);
      }
      
      private function onBlockAndConfirmCompleted(param1:Boolean, param2:Object) : void
      {
         var _loc3_:DockedPrompt = null;
         if(!param1)
         {
            _loc3_ = new DockedPrompt();
            _loc3_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_close");
            _loc3_.title = RiotResourceLoader.getString("chat_buddyWindow_errorOnIgnoreUserAlertTitle","**Ignore error");
            _loc3_.message = RiotResourceLoader.getString("chat_buddyWindow_errorOnAddBuddyAlertMessage","**Ignore Error",[param2.name]);
            _loc3_.timeStamp = new Date();
            _loc3_.isPersistent = true;
            NotificationsProviderProxy.instance.showDockedPrompt(_loc3_);
         }
      }
      
      private function onInviteToGroupChatRequest(param1:String, param2:Array, param3:String, param4:String) : void
      {
         this.groupChatHandler.inviteToChat(param1,param2,param3,param4);
      }
      
      private function onGetInviteController(param1:IInviteProvider) : void
      {
         this._inviteController = param1.getInviteController();
         this._inviteGroup = param1.getInviteGroup();
         this._queueRestrictionController = param1.getQueueRestrictionController();
      }
      
      public function openChatRoomByName(param1:String, param2:String) : void
      {
         this._chatController.openChatRoom(param1,param2);
      }
      
      public function removeBuddy(param1:Buddy) : void
      {
         if(!param1)
         {
            return;
         }
         this.chatController.removeBuddyWithJID(new UnescapedJID(param1.getJID()));
         if(this._friendTracker != null)
         {
            this._friendTracker.incrementFriendRemoved_InASession();
         }
      }
      
      public function addBuddy(param1:String, param2:String = null) : void
      {
         this._chatController.addBuddy(param1,param2);
      }
      
      public function inviteBuddyToGame(param1:Buddy) : void
      {
         if(!param1)
         {
            return;
         }
         if(this._inviteController != null && Boolean(param1.getIsOnline()))
         {
            this._queueRestrictionController.checkIsEligibleQueuePartner(RosterUtility.getRosterItemVoFromJID(param1.getJID()),this.handleCheckIsEligibleQueuePartner);
         }
      }
      
      public function getCurrentChatModel() : Object
      {
         return this._currentChatModel;
      }
      
      public function emptyAndRemoveGroup(param1:String) : void
      {
         this._chatController.emptyAndRemoveGroup(param1);
         if(this._friendTracker != null)
         {
            this._friendTracker.incrementBuddyGroupDeleted_InASession();
         }
      }
      
      public function closeChatRoomBySubject(param1:String, param2:String = "pu") : void
      {
         this._chatController.closeChatRoomBySubject(param1,param2);
      }
      
      public function canInviteBuddyToGame(param1:Buddy) : Boolean
      {
         var _loc2_:Boolean = Boolean(this._inviteGroup.allowedToInvite) && Boolean(this._inviteGroup.isInviteActive) && Boolean(param1.isAvailableForInvite());
         if(this._gameQueueManager.selectedGameQueueConfig)
         {
            _loc2_ = _loc2_ && !this._gameQueueManager.selectedGameQueueConfig.teamOnly && this.isBuddyEligibleQueuePartner(param1);
         }
         return _loc2_;
      }
      
      public function updateChatRoomOccupantCounts() : void
      {
         this.chatRoomListViewModel.updateChatRoomOccupantCounts();
      }
      
      private function onGotGameQueueManager(param1:GameQueueManager) : void
      {
         this._gameQueueManager = param1;
      }
      
      public function spectateGameByBuddy(param1:Buddy) : void
      {
         var _loc2_:PresenceStatusData = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(!this._spectatorProvider || !this._masterGameController || !param1)
         {
            return;
         }
         if(param1.getIsOnline())
         {
            this._masterGameController.cancelGameFlow();
            _loc2_ = param1.getPresence();
            _loc3_ = _loc2_.dropInSpectateId;
            if(_loc2_.gameType == PresenceStatusXML.GAME_STATUS_IN_SPECTATING && Boolean(_loc3_))
            {
               if(_loc3_.search(/^featured_game_/) == 0)
               {
                  _loc4_ = jsonDecode(_loc2_.featuredGameData);
                  this._spectatorProvider.spectateFeaturedGame(_loc4_.gameId,_loc4_.platformId,_loc4_.encryptionKey,_loc4_.mapId,_loc4_.gameType);
               }
               else
               {
                  this._spectatorProvider.spectateSummoner(_loc3_);
               }
            }
            else
            {
               this._spectatorProvider.spectateSummoner(param1.getName());
            }
            if(this._friendTracker != null)
            {
               this._friendTracker.incrementFriendGameSpectate_InASession();
            }
         }
      }
      
      public function openChatRoom(param1:ChatRoomInfo) : void
      {
         var _loc3_:Object = null;
         var _loc2_:String = this._chatController.openChatRoom(param1.subject,param1.roomType);
         for each(_loc3_ in this._totalChatModels)
         {
            if(_loc3_ is ChatRoom && ChatRoom(_loc3_).roomName == _loc2_)
            {
               this.setCurrentChatModel(_loc3_);
               break;
            }
         }
      }
      
      private function onPersonalChatMessageReceived(param1:RosterItemVO, param2:Message) : void
      {
         this.personalMessageHandler.personalChatMessageReceived(param1,param2);
      }
      
      public function getPrivacyListController() : PrivacyListController
      {
         return this._chatController.privacyListController;
      }
      
      public function createPersonalPopUp(param1:String, param2:Boolean = false) : void
      {
         this.personalMessageHandler.createPersonalPopUp(RosterUtility.getRosterItemVoFromJID(param1),param2);
      }
      
      public function reconnectToChat() : void
      {
         this._chatController.reconnect();
      }
      
      private function removeChatWindows() : void
      {
         this.closeAllChatRooms();
      }
      
      public function deleteChatPrompt(param1:Object) : void
      {
         var _loc2_:int = int(this.chatPrompts.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.chatPrompts.removeItemAt(_loc2_);
         }
         this.deleteRecentChatPrompt(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get chatRoomListViewModel() : ChatRoomListViewModel
      {
         return this._1648354035chatRoomListViewModel;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function moveGroupDown(param1:BuddyGroup) : void
      {
         var _loc2_:String = param1.getLabel();
         this._chatController.moveGroupDown(_loc2_);
      }
      
      public function getBuddyGroups() : IListX
      {
         var _loc1_:ListCollectionView = this._chatRosterProvider.getBuddyGroups();
         return new ListAdapter(_loc1_);
      }
      
      public function inviteGroupToChat(param1:BuddyGroup) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:RosterGroup = this._chatController.roster.getGroup(param1.getLabel());
         this._chatController.inviteToChat(_loc2_.toArray(),true);
         if(this._friendTracker != null)
         {
            this._friendTracker.incrementBuddyGroupChatInviteSent_InASession();
         }
      }
      
      public function getPresenceUpdated() : ISignal
      {
         return this._chatController.presenceController.getPresenceUpdated();
      }
      
      [Inject]
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      public function getCurrentStatus() : String
      {
         return this._chatController.presenceController.currentShow;
      }
      
      public function get chatPrompts() : ArrayCollection
      {
         return this._chatPrompts;
      }
      
      public function closePersonalPopupWindowAndTabs(param1:UnescapedJID) : void
      {
         this.closePersonalPopupWindow(param1);
      }
      
      public function getPrivacyList() : ArrayCollection
      {
         if(this._chatController.privacyListController.activePrivacyList)
         {
            return this._chatController.privacyListController.activePrivacyList.items;
         }
         return null;
      }
      
      public function set swiz(param1:ISwiz) : void
      {
         this._swiz = param1;
         this.joinInitialize();
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._friendTracker = param1.getFriendListBehaviorTracker();
      }
      
      private function initializeChatRoomList() : void
      {
         var _loc2_:String = null;
         var _loc3_:ChatRoomInfo = null;
         if(this.resourceManager == null)
         {
            return;
         }
         this.chatRoomListViewModel = new ChatRoomListViewModel(this._chatController,RiotServiceConfig.instance,ServiceProxy.instance);
         var _loc1_:* = new DefaultChatRoomLoader(this.resourceManager).getLocalizedDefaultChatRooms();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = new ChatRoomInfo(_loc2_,false,0,ChatRoomType.PUBLIC,true,this._chatController.obfuscateChatRoom(_loc2_,ChatRoomType.PUBLIC));
            this.chatRoomListViewModel.addPersonalChatRoomToPublicList(_loc3_);
         }
      }
      
      public function viewProfile(param1:Buddy) : void
      {
         var _loc2_:String = null;
         if(!param1)
         {
            return;
         }
         if(this._navigationController != null)
         {
            _loc2_ = RosterUtility.getRosterItemVoFromJID(param1.getJID()).displayName;
            this._navigationController.searchForSummoner(_loc2_,null);
            if(this._friendTracker != null)
            {
               this._friendTracker.incrementFriendProfileViewed_InASession();
            }
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function getChatRoomListViewModel() : ChatRoomListViewModel
      {
         return this.chatRoomListViewModel;
      }
      
      private function onChatRoomViewOpenRequest(param1:ChatRoom, param2:String) : void
      {
         this.groupChatHandler.openChatRoom(param1);
      }
      
      public function getRecentlyPlayedList() : ArrayCollection
      {
         return this._chatController.buddyListModel.recentPlayersList;
      }
      
      public function getSummonerStatusMessage() : String
      {
         return this._chatController.presenceController.currentStatusMsg;
      }
      
      private function onGotSpectatorProvider(param1:ISpectatorProvider) : void
      {
         this._spectatorProvider = param1;
      }
      
      public function openBuddyList() : void
      {
         if(this.chatController.currentState != null && this.chatController.currentState != ChatController.ONLINE)
         {
            return;
         }
         this.chatController.buddyListOpen = true;
      }
      
      public function deleteRecentChatPrompt(param1:Object) : void
      {
         var _loc2_:int = int(this.recentChatPrompts.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.recentChatPrompts.removeItemAt(_loc2_);
         }
      }
      
      private function handleAlreadyInChatPromptList(param1:DockedPrompt) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DockedPrompt = null;
         _loc2_ = 0;
         while(_loc2_ < this.chatPrompts.length)
         {
            _loc3_ = this.chatPrompts[_loc2_];
            if(_loc3_.message == param1.message && _loc3_.title == param1.title && _loc3_.fromName == param1.fromName && _loc3_.type == param1.type)
            {
               this.chatPrompts.removeItemAt(_loc2_);
               break;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.recentChatPrompts.length)
         {
            _loc3_ = this.recentChatPrompts[_loc2_];
            if(_loc3_.message == param1.message && _loc3_.title == param1.title && _loc3_.fromName == param1.fromName && _loc3_.type == param1.type)
            {
               this.recentChatPrompts.removeItemAt(_loc2_);
               break;
            }
            _loc2_++;
         }
      }
      
      public function closeBuddyList() : void
      {
         if(this.chatController.currentState != null && this.chatController.currentState != ChatController.ONLINE)
         {
            return;
         }
         this.chatController.buddyListOpen = false;
      }
      
      public function getSummonerName() : String
      {
         return this._chatController.currentUserDisplayName;
      }
      
      public function reset() : void
      {
         var _loc1_:Object = null;
         this.removeChatWindows();
         this._chatWindows.removeAll();
         this._totalChatModels.removeAll();
         this.chatController.buddyListOpen = false;
         for each(_loc1_ in this.chatPrompts)
         {
            this.deleteChatPrompt(_loc1_);
         }
      }
      
      public function createBuddyGroup(param1:String) : Boolean
      {
         var _loc2_:RosterGroup = this._chatController.addGroup(param1);
         return _loc2_ != null;
      }
      
      public function getPrivacyListChanged() : ISignal
      {
         return this._chatController.privacyListController.getActivePrivacyListChanged();
      }
      
      public function unblockUser(param1:PrivacyListItem) : void
      {
         if(param1)
         {
            this._chatController.privacyListController.unblock(param1.value);
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function moveBuddyToGroup(param1:Buddy, param2:String) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:RosterItemVO = RosterUtility.getRosterItemVoFromJID(param1.getJID());
         this._chatController.roster.updateContactGroups(_loc3_,[param2]);
         if(this._friendTracker != null)
         {
            this._friendTracker.incrementFriendMovedToGroup_InASession();
         }
      }
      
      public function initialize() : void
      {
      }
      
      private function set _1019249940chatController(param1:ChatController) : void
      {
         if(this._chatController != null)
         {
            this._chatController.getChatDisplayNameChangedSignal().remove(this.onDisplayNameChanged);
            this._chatController.getChatDisplayInviteRecievedSignal().remove(this.onChatRoomInviteReceived);
            this._chatController.getChatOpenChatRoomViewSignal().remove(this.onChatRoomViewOpenRequest);
            this._chatController.getChatInviteToGroupChatSignal().remove(this.onInviteToGroupChatRequest);
            this._chatController.getChatCloseChatRoomSignal().remove(this.closeChatRoom);
            this._chatController.getChatCloseAllChatRoomsSignal().remove(this.closeAllChatRooms);
            this._chatController.getChatCloseMatchmakingQueueChatRoomSignal().remove(this.closeChatRoom);
            this._chatController.getChatRemoveAllChatDisplaysSignal().remove(this.removeAllChatAndBuddyWindows);
            this._chatController.getChatLoggingOutSignal().remove(this.reset);
            this._chatController.getChatSystemInitializedSignal().remove(this.initialize);
            this._chatController.getChatSpammerErrorSignal().remove(this.onChatSpamError);
            this._chatController.getChatMessageReceivedSignal().remove(this.onPersonalChatMessageReceived);
         }
         this._chatController = param1;
         if(this._chatController != null)
         {
            this.joinInitialize();
         }
      }
      
      public function setCurrentChatModel(param1:Object) : void
      {
         if(param1 == null || param1 is ChatWindowModel || param1 is ChatRoom)
         {
            if(this._currentChatModel != param1 && this.getChatControllerStartFocused())
            {
               this._currentChatModel = param1;
               this._currentChatModelSignal.dispatch();
            }
         }
         else
         {
            this.logger.error("Invalid type " + getQualifiedClassName(param1) + " set on \'currentChatModel\'");
         }
      }
      
      public function get recentChatPrompts() : ArrayCollection
      {
         return this._recentChatPrompts;
      }
      
      public function setSummonerStatusMessage(param1:String) : void
      {
         this._chatController.presenceController.setStatusMessage(param1);
      }
      
      private function onDisplayNameChanged(param1:String) : void
      {
         this.chatController.updateNicknameInRooms(param1);
         var _loc2_:String = this.resourceManager.getString("resources","chat_buddyWindow_userChatRoomName",[param1]);
         var _loc3_:String = this._chatController.obfuscateChatRoom(_loc2_,ChatRoomType.PRIVATE);
         var _loc4_:ChatRoomInfo = new ChatRoomInfo(_loc2_,false,0,ChatRoomType.PRIVATE,false,_loc3_);
         this.chatRoomListViewModel.addPersonalChatRoomToPrivateList(_loc4_);
      }
      
      public function isBuddyEligibleQueuePartner(param1:Buddy) : Boolean
      {
         if(QueueRestrictionConfiguration.isQueueRestrictionRequired(this._gameQueueManager.selectedGameQueueConfig))
         {
            return param1.isEligibleQueuePartner();
         }
         return true;
      }
      
      public function markChatPromptAsRead(param1:DockedPrompt) : void
      {
         var _loc2_:int = int(this.chatPrompts.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.chatPrompts[_loc2_].unread = false;
         }
      }
      
      public function getDefaultGroupName() : String
      {
         return this._chatController.getDefaultGroupName();
      }
      
      public function renameGroup(param1:BuddyGroup, param2:String) : Boolean
      {
         var _loc3_:String = param1.getLabel();
         var _loc4_:int = int(this._chatController.getGroupPriority(_loc3_));
         var _loc5_:RosterGroup = this._chatController.addGroup(param2,_loc4_);
         if(_loc5_ != null)
         {
            this._chatController.moveBuddies(_loc3_,param2);
            this._chatController.removeGroup(_loc3_);
            param1.setLabel(param2);
            return true;
         }
         return false;
      }
      
      public function set chatRoomListViewModel(param1:ChatRoomListViewModel) : void
      {
         var _loc2_:Object = this._1648354035chatRoomListViewModel;
         if(_loc2_ !== param1)
         {
            this._1648354035chatRoomListViewModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoomListViewModel",_loc2_,param1));
         }
      }
      
      public function getChatControllerStartFocused() : Boolean
      {
         return this._chatController.chatRoomsStartFocused;
      }
      
      private function closeAllChatRooms() : void
      {
         this.groupChatHandler.closeAllRooms();
      }
      
      private function onChatRoomInviteReceived(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String = null, param8:String = "friendInvite", param9:Function = null, param10:Object = null, param11:Boolean = true) : void
      {
         if(this.groupChatHandler.hasRoom(param1))
         {
            return;
         }
         var _loc12_:String = this.resourceManager.getString(param2,param4);
         var _loc13_:String = this.resourceManager.getString(param2,param6);
         var _loc14_:String = null;
         if(param7 != null)
         {
            _loc14_ = this.resourceManager.getString(param2,param7);
         }
         var _loc15_:DockedPrompt = DockedPrompt.create(param3,_loc12_,param5,_loc13_,_loc14_,param8,param9,param10,param11);
         NotificationsProviderProxy.instance.showDockedPrompt(_loc15_);
      }
      
      private function onGetLegacyProfileNavigationProvider(param1:ILegacyProfileNavigationProvider) : void
      {
         this._navigationController = param1;
      }
   }
}

