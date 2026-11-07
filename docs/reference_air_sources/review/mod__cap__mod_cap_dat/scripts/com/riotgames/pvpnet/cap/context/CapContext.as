package com.riotgames.pvpnet.cap.context
{
   import blix.IDestructible;
   import blix.context.Context;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ChampionDetailProviderProxy;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.responses.factory.ILcdsProxyMessageActionFactory;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.common.utils.encode.JSONEncoder;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.pvpnet.cap.controllers.CapController;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.controllers.CapMmaController;
   import com.riotgames.pvpnet.cap.controllers.CapMusicController;
   import com.riotgames.pvpnet.cap.controllers.CapPlayerSpellController;
   import com.riotgames.pvpnet.cap.controllers.CapTimerController;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.controllers.IPlayerSpellController;
   import com.riotgames.pvpnet.cap.delegates.CapGamePreparationDelegate;
   import com.riotgames.pvpnet.cap.factory.CapActionFactory;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.factory.response.BaseCapMessageActionFactory;
   import com.riotgames.pvpnet.cap.factory.response.CapCaptainMessageActionFactory;
   import com.riotgames.pvpnet.cap.factory.response.CapInviteeMessageActionFactory;
   import com.riotgames.pvpnet.cap.factory.response.CapSoloMessageActionFactory;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTimeCache;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   import com.riotgames.pvpnet.cap.observers.InQueueObserver;
   import com.riotgames.pvpnet.cap.observers.MmaObserver;
   import com.riotgames.pvpnet.cap.observers.group.GroupUnreadyObserver;
   import com.riotgames.pvpnet.cap.observers.group.PenaltyTimeObserver;
   import com.riotgames.pvpnet.cap.observers.group.TimeToApproveObserver;
   import com.riotgames.pvpnet.cap.observers.observable.CapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.ICapObservableFactory;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.observers.observable.composite.captain.CaptainAbleToSearchCandidatesObserver;
   import com.riotgames.pvpnet.cap.observers.observable.composite.captain.CaptainAbleToSpecCandidatesObserver;
   import com.riotgames.pvpnet.cap.observers.observable.composite.captain.CaptainAbleToStartMatchmakingObserver;
   import com.riotgames.pvpnet.cap.observers.observable.composite.group.GroupAbleToMatchmakeObserver;
   import com.riotgames.pvpnet.cap.observers.observable.group.CapPlayerPresenceObserver;
   import com.riotgames.pvpnet.cap.observers.observable.player.PlayerFullySpeccedObserver;
   import com.riotgames.pvpnet.cap.services.CapLcdsMessageRouter;
   import com.riotgames.pvpnet.cap.services.CapService;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.RecommendedRoleResolver;
   import com.riotgames.pvpnet.cap.views.popups.champselect.CapClassicChampSelectPopup;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class CapContext extends Context implements IDestructible
   {
      
      private var _externalDependenciesLoaded:Signal = new Signal();
      
      private var _observers:Array = [];
      
      public function CapContext(param1:Dictionary = null)
      {
         super(null,param1);
      }
      
      protected function registerObserver(param1:Class, param2:IObserver, param3:Boolean = true) : Boolean
      {
         if(registerDependency(param1,param2,param3))
         {
            this._observers.push(param2);
            return true;
         }
         return false;
      }
      
      private function getDestructibles() : Array
      {
         return [ICapController,CapMusicController,IPlayerSpellController,CapViewMediator,CaptainAbleToSpecCandidatesObserver,CapModel,ILcdsProxyServiceMessenger,CapPlayerPresenceObserver,GroupUnreadyObserver,TimeToApproveObserver,PenaltyTimeObserver,CaptainAbleToStartMatchmakingObserver,MmaObserver,InQueueObserver,CapLobbyTimerController,GroupAbleToMatchmakeObserver,CapService];
      }
      
      public function getObservers() : Array
      {
         return this._observers;
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         var _loc1_:IInviteController = getDependency(IInviteController);
         var _loc2_:InviteGroup = getDependency(InviteGroup);
         var _loc3_:IInviteProvider = getDependency(IInviteProvider);
         var _loc4_:ISoundProvider = getDependency(ISoundProvider);
         var _loc5_:ILobbyViewController = getDependency(ILobbyViewController);
         var _loc6_:IRuneBookController = getDependency(IRuneBookController);
         var _loc7_:IMasteriesProvider = getDependency(IMasteriesProvider);
         var _loc8_:INotificationsProvider = getDependency(INotificationsProvider);
         var _loc9_:IGameQueueManager = getDependency(IGameQueueManager);
         var _loc10_:IBaseLcdsService = ServiceProxy.instance.lcdsService;
         var _loc11_:IInventoryProvider = getDependency(IInventoryProvider);
         var _loc12_:IInventoryController = _loc11_.getInventoryController();
         registerDependency(IInventoryController,_loc12_);
         var _loc13_:MasterGameController = getDependency(IMasterGameController);
         registerDependency(MasterGameController,_loc13_);
         var _loc14_:IChatProvider = getDependency(IChatProvider);
         var _loc15_:IChatRoomProvider = _loc14_ as IChatRoomProvider;
         var _loc16_:ChatController = _loc15_ as ChatController;
         var _loc17_:IPresenceProvider = getDependency(IPresenceProvider);
         registerDependency(IChatRoomProvider,_loc15_);
         registerDependency(ChatController,_loc16_);
         registerDependency(IInventory,_loc12_.inventory);
         registerDependency(IChampionDetailProvider,ChampionDetailProviderProxy.instance);
         var _loc18_:ISuggestedPlayersProvider = getDependency(ISuggestedPlayersProvider);
         var _loc19_:CapModel = getDependency(CapModel);
         var _loc20_:CapPlayAgainModel = getDependency(CapPlayAgainModel);
         var _loc21_:CapViewMediator = new CapViewMediator(this);
         registerDependency(CapViewMediator,_loc21_);
         var _loc22_:RecommendedRoleResolver = new RecommendedRoleResolver();
         registerDependency(RecommendedRoleResolver,_loc22_);
         var _loc23_:CapLobbyTimerController = new CapLobbyTimerController(_loc19_);
         registerDependency(CapLobbyTimerController,_loc23_);
         var _loc24_:CapTimerController = new CapTimerController(new Timer(200));
         registerDependency(CapTimerController,_loc24_);
         var _loc25_:IDecode = new JSONDecoder(true);
         var _loc26_:CapEstimatedWaitTimeCache = new CapEstimatedWaitTimeCache();
         var _loc27_:CapService = new CapService(ServiceProxy.instance.lcdsService,_loc25_);
         registerDependency(CapService,_loc27_);
         var _loc28_:CapMusicController = new CapMusicController(_loc4_);
         registerDependency(CapMusicController,_loc28_);
         var _loc29_:CapGamePreparationDelegate = new CapGamePreparationDelegate(_loc28_,_loc19_);
         registerDependency(IGamePreparationDelegate,_loc29_);
         var _loc30_:ICapActionFactory = new CapActionFactory(_loc19_,_loc27_,_loc12_.inventory,_loc13_,_loc5_,_loc3_,_loc14_,new JSONEncoder(),_loc25_,_loc7_,ServiceProxy.instance.spellBookService,_loc8_,_loc29_);
         registerDependency(ICapActionFactory,_loc30_);
         var _loc31_:CapPlayerSpellController = new CapPlayerSpellController(_loc19_.localPlayerSelection,_loc30_,_loc19_);
         registerDependency(IPlayerSpellController,_loc31_);
         registerDependency(CapPlayerSpellController,_loc31_);
         var _loc32_:CapController = new CapController(_loc19_,_loc20_,_loc30_,_loc31_,_loc13_,_loc13_.masterGameViewController,_loc13_.lobbyController,_loc1_,_loc2_,_loc4_,_loc23_,_loc9_,_loc26_,_loc12_,_loc16_,_loc17_,_loc18_);
         registerDependency(ICapController,_loc32_);
         registerDependency(CapController,_loc32_);
         var _loc33_:ILcdsProxyMessageActionFactory = this.createLcdsProxyResponseFactory(_loc19_,_loc20_,_loc5_,_loc25_,_loc12_,_loc1_,_loc2_,_loc4_,_loc21_,_loc8_,_loc23_,_loc24_,_loc26_,_loc14_,_loc32_);
         var _loc34_:CapLcdsMessageRouter = new CapLcdsMessageRouter(_loc33_ as BaseCapMessageActionFactory);
         registerDependency(CapLcdsMessageRouter,_loc34_);
         var _loc35_:CapMmaController = new CapMmaController(_loc19_);
         registerDependency(CapMmaController,_loc35_);
         var _loc36_:CapClassicChampSelectPopup = new CapClassicChampSelectPopup(this);
         registerDependency(CapClassicChampSelectPopup,_loc36_);
         var _loc37_:GroupUnreadyObserver = new GroupUnreadyObserver(_loc19_,_loc32_);
         this.registerObserver(GroupUnreadyObserver,_loc37_);
         var _loc38_:MmaObserver = new MmaObserver(_loc19_.localPlayerSelection,_loc35_);
         this.registerObserver(MmaObserver,_loc38_);
         var _loc39_:InQueueObserver = new InQueueObserver(_loc19_,_loc5_);
         this.registerObserver(InQueueObserver,_loc39_);
         var _loc40_:TimeToApproveObserver = new TimeToApproveObserver(_loc19_);
         this.registerObserver(TimeToApproveObserver,_loc40_);
         var _loc41_:PenaltyTimeObserver = new PenaltyTimeObserver(_loc19_);
         this.registerObserver(PenaltyTimeObserver,_loc41_);
         var _loc42_:ICapObservableFactory = new CapObservableFactory(_loc19_,_loc30_);
         registerDependency(ICapObservableFactory,_loc42_);
         this.registerObserver(CapPlayerPresenceObserver,_loc42_.createCapPlayerPresenceObserver());
         var _loc43_:IObservable = _loc42_.createPlayerFullySpeccedObserver(_loc19_.localPlayerSelection);
         this.registerObserver(PlayerFullySpeccedObserver,_loc43_);
         var _loc44_:CaptainAbleToSpecCandidatesObserver = new CaptainAbleToSpecCandidatesObserver(_loc19_,_loc42_);
         this.registerObserver(CaptainAbleToSpecCandidatesObserver,_loc44_);
         var _loc45_:IObservable = new GroupAbleToMatchmakeObserver(_loc19_.playerSelections,_loc42_);
         this.registerObserver(GroupAbleToMatchmakeObserver,_loc45_);
         var _loc46_:CaptainAbleToStartMatchmakingObserver = new CaptainAbleToStartMatchmakingObserver(_loc19_.playerSelections,_loc42_);
         this.registerObserver(CaptainAbleToStartMatchmakingObserver,_loc46_);
         var _loc47_:CaptainAbleToSearchCandidatesObserver = new CaptainAbleToSearchCandidatesObserver(_loc19_.playerSelections,_loc42_);
         this.registerObserver(CaptainAbleToSearchCandidatesObserver,_loc47_);
      }
      
      public function destroy() : void
      {
         var _loc2_:Class = null;
         var _loc3_:IDestructible = null;
         var _loc1_:Array = this.getDestructibles();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = getDependency(_loc2_);
            if(_loc3_)
            {
               _loc3_.destroy();
            }
         }
      }
      
      private function createLcdsProxyResponseFactory(param1:CapModel, param2:CapPlayAgainModel, param3:ILobbyViewController, param4:IDecode, param5:IInventoryController, param6:IInviteController, param7:InviteGroup, param8:ISoundProvider, param9:CapViewMediator, param10:INotificationsProvider, param11:CapLobbyTimerController, param12:CapTimerController, param13:CapEstimatedWaitTimeCache, param14:IChatProvider, param15:ICapController) : ILcdsProxyMessageActionFactory
      {
         var _loc16_:ILcdsProxyMessageActionFactory = null;
         if(CapFlowUtil.isCaptain(param1))
         {
            return new CapCaptainMessageActionFactory(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
         }
         if(CapFlowUtil.isInvitee(param1))
         {
            return new CapInviteeMessageActionFactory(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
         }
         return new CapSoloMessageActionFactory(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
      }
   }
}

