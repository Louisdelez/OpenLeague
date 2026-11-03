package
{
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.gameclient.championselection.GameEvent;
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.championselection.IChampionSelection;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.ChatProviderProxy;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.controllers.game.builders.ChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.builders.ChampionSelectionControllerGenerator;
   import com.riotgames.platform.gameclient.controllers.game.builders.ChampionSelectionViewGenerator;
   import com.riotgames.platform.gameclient.controllers.game.builders.ChampionSelectionViewModelGenerator;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.controllers.ChampionSelectionControllerNew;
   import com.riotgames.platform.gameclient.controllers.game.mediators.ChampionSelectionViewMediator;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.IChampionSelectionView;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.ITipPopupManager;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.TipPopupManager;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tips.ITipsProvider;
   import com.riotgames.rust.module.RiotModuleRoot;
   import flash.display.DisplayObjectContainer;
   import flash.errors.IllegalOperationError;
   import flash.net.URLRequest;
   import mx.managers.CursorManager;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleChampionSelection extends RiotModuleRoot implements IProviderModule, IChampionSelection
   {
      
      private var commandFactory:IChampionSelectionCommandFactory;
      
      private var rootViewProxy:DisplayObjectContainerProxy;
      
      private var startupAction:SequenceAction;
      
      private var model:ChampionSelectionModel;
      
      private var championView:IChampionSelectionView;
      
      private var mediator:ChampionSelectionViewMediator;
      
      private var spectatorChampionView:IChampionSelectionView;
      
      public function ClientModuleChampionSelection()
      {
         super();
      }
      
      private function loadChampionSelectionAssets() : void
      {
         this.championView.rootContext = this;
         this.spectatorChampionView.rootContext = this;
         var _loc1_:IAction = this.loadAssets(new URLRequest("mod/cs/assets/champSelectAssets.swf"));
         _loc1_.getCompleted().add(this.onChampionSelectionAssetsLoaded);
      }
      
      private function getPresenceProvider() : void
      {
         ProviderLookup.getProvider(IPresenceProvider,this.onPresenceProvider);
      }
      
      private function onTipsProvider(param1:ITipsProvider) : void
      {
         this.rootViewProxy = new DisplayObjectContainerProxy(this,this.championView as DisplayObjectContainer);
         var _loc2_:ITipsProvider = param1;
         var _loc3_:IToolTipManager = _loc2_.createWindowToolTipManager(this.rootViewProxy);
         registerDependency(IToolTipManager,_loc3_);
         this.startupAction.completeFunction(this.getTipsProvider);
      }
      
      private function onPresenceProvider(param1:IPresenceProvider) : void
      {
         registerDependency(IPresenceProvider,param1);
         this.startupAction.completeFunction(this.getPresenceProvider);
      }
      
      private function onChampionSelectionAssetsLoaded(param1:IAction) : void
      {
         this.startupAction.completeFunction(this.loadChampionSelectionAssets);
      }
      
      private function createMediator(param1:GameSelectionData) : void
      {
         this.model = this.getModel(param1);
         var _loc2_:IChampionSelectionView = param1.isSpectating ? this.spectatorChampionView : this.championView;
         var _loc3_:ChampionSelectionControllerNew = this.getChampionController(param1,this.model);
         this.mediator = new ChampionSelectionViewMediator(_loc3_,_loc2_,this.model,this,this);
         this.mediator.addEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.dispatchGameEvent);
         this.mediator.addEventListener(GameEvent.BROWSE_REQUESTED,this.dispatchGameEvent);
         this.mediator.addEventListener(GameEvent.COMPLETE_CHAMPION_SELECT,this.dispatchGameEvent);
         this.mediator.addEventListener(GameEvent.END_CHAMPION_SELECTION,this.dispatchGameEvent);
      }
      
      private function getMasteriesProvider() : void
      {
         ProviderLookup.getProvider(IMasteriesProvider,this.masteriesHandler);
      }
      
      private function getDockedNotificationsProvider() : void
      {
         ProviderLookup.getProvider(INotificationsProvider,this.onDockedNotificationsProvider);
      }
      
      private function destroyMediator() : void
      {
         this.model = null;
         if(this.mediator != null)
         {
            this.mediator.destroy();
            this.mediator.removeEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.dispatchGameEvent);
            this.mediator.removeEventListener(GameEvent.BROWSE_REQUESTED,this.dispatchGameEvent);
            this.mediator.removeEventListener(GameEvent.COMPLETE_CHAMPION_SELECT,this.dispatchGameEvent);
            this.mediator.removeEventListener(GameEvent.END_CHAMPION_SELECTION,this.dispatchGameEvent);
            this.mediator = null;
         }
      }
      
      private function masteriesHandler(param1:IMasteriesProvider) : void
      {
         registerDependency(IMasteriesProvider,param1);
         this.startupAction.completeFunction(this.getMasteriesProvider);
      }
      
      private function getChatRoomProvider() : void
      {
         ProviderLookup.getProvider(IChatRoomProvider,this.onChatRoomProvider);
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         registerDependency(IInventory,param1.getInventory());
         registerDependency(IInventoryController,param1.getInventoryController());
         this.startupAction.completeFunction(this.getInventory);
      }
      
      public function startChampionSelect(param1:GameSelectionData) : void
      {
         if(Boolean(this.mediator) && this.mediator.isSameGame(param1.game))
         {
            return;
         }
         registerDependency(ChatController,param1.chatController);
         this.destroyMediator();
         this.createMediator(param1);
         this.mediator.startChampionSelect(param1);
      }
      
      private function getModel(param1:GameSelectionData) : ChampionSelectionModel
      {
         return ChampionSelectionViewModelGenerator.generateChampionSelectionViewModel(param1,getDependency(IInventory).championRegistry,getDependency(IInventory).runeBook,getDependency(IInventoryController));
      }
      
      private function getChampionController(param1:GameSelectionData, param2:ChampionSelectionModel) : ChampionSelectionControllerNew
      {
         return ChampionSelectionControllerGenerator.generateChampionSelectionController(this,param1,param2);
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.championView = ChampionSelectionViewGenerator.generatePlayerView();
         this.spectatorChampionView = ChampionSelectionViewGenerator.generateSpectatorView();
         this.startupAction = new SequenceAction();
         this.startupAction.andCall(this.getPresenceProvider);
         this.startupAction.andCall(this.getInventory);
         this.startupAction.andCall(this.getDockedNotificationsProvider);
         this.startupAction.andCall(this.getMasteriesProvider);
         this.startupAction.andCall(this.loadChampionSelectionAssets);
         this.startupAction.andCall(this.getTipsProvider);
         this.startupAction.getCompleted().addOnce(this.onInitializationComplete);
         this.startupAction.invoke();
         this.getChatRoomProvider();
      }
      
      private function dispatchGameEvent(param1:GameEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onDockedNotificationsProvider(param1:INotificationsProvider) : void
      {
         registerDependency(INotificationsProvider,param1);
         this.startupAction.completeFunction(this.getDockedNotificationsProvider);
      }
      
      private function onChatRoomProvider(param1:IChatRoomProvider) : void
      {
         registerDependency(IChatRoomProvider,param1);
         if(this.commandFactory)
         {
            this.commandFactory.setChatRoomProvider(param1);
         }
      }
      
      private function getInventory() : void
      {
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
      }
      
      public function getCommandFactory() : IChampionSelectionCommandFactory
      {
         return this.commandFactory;
      }
      
      private function onInitializationComplete() : void
      {
         registerDependency(IAlerterProvider,AlerterProviderProxy.instance);
         registerDependency(IChatProvider,ChatProviderProxy.instance);
         registerDependency(ISoundProvider,SoundProviderProxy.instance);
         registerDependency(ServiceProxy,ServiceProxy.instance);
         registerDependency(Session,Session.instance);
         registerDependency(ClientConfig,ClientConfig.instance);
         registerDependency(IResourceManager,ResourceManager.getInstance());
         registerDependency(ICursorManager,CursorManager.getInstance());
         this.commandFactory = new ChampionSelectionCommandFactory(getDependency(IAlerterProvider),getDependency(ServiceProxy).chatService,getDependency(ServiceProxy).gameService,getDependency(IInventory),getDependency(IInventoryController),getDependency(IChatRoomProvider),getDependency(IPresenceProvider),getDependency(INotificationsProvider),getDependency(ISoundProvider),getDependency(IResourceManager),getDependency(ICursorManager));
         registerDependency(IChampionSelectionCommandFactory,this.commandFactory);
         registerDependency(ITipPopupManager,new TipPopupManager());
         ProviderLookup.publishProvider(IChampionSelection,this);
      }
      
      public function getChampionSelectionScreen(param1:IContext) : IMainScreen
      {
         throw new IllegalOperationError("Not Implemented.");
      }
      
      public function getChampionSelectionModel() : ChampionSelectionModel
      {
         return this.model;
      }
      
      private function getTipsProvider() : void
      {
         ProviderLookup.getProvider(ITipsProvider,this.onTipsProvider);
      }
   }
}

