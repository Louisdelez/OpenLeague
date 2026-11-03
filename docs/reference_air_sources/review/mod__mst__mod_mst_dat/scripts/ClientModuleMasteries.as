package
{
   import blix.action.IAction;
   import com.riotgames.platform.common.resource.FlatFileResourceLoader;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.module.masteries.controller.MasteriesController;
   import com.riotgames.platform.module.masteries.controller.MasteriesViewMediator;
   import com.riotgames.platform.module.masteries.provider.MasteriesProviderImpl;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.rust.context.RustContext;
   import com.riotgames.rust.resource.IRustResourceLoader;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleMasteries extends Sprite implements IProviderModule
   {
      
      private var resourceLoader:IRustResourceLoader;
      
      private var _masteriesProvider:IMasteriesProvider;
      
      private var _context:RustContext;
      
      private var _masteriesController:MasteriesController;
      
      private var hasRegistered:Boolean = false;
      
      public function ClientModuleMasteries()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.resourceLoader = new FlatFileResourceLoader();
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[MasteriesController] = this.masteriesController;
         _loc2_[IRustResourceLoader] = this.resourceLoader;
         this._context = new RustContext();
         this._context.enableAutoLocalization("masteries_resources");
         this.loadResources();
         this._masteriesController = new MasteriesController(this._context,MasteriesViewMediator);
         this._masteriesProvider = new MasteriesProviderImpl(this._masteriesController);
      }
      
      public function get masteriesProvider() : IMasteriesProvider
      {
         return this._masteriesProvider;
      }
      
      private function registerModule() : void
      {
         if(!this.hasRegistered)
         {
            this.hasRegistered = true;
            ProviderLookup.publishProvider(IMasteriesProvider,this._masteriesProvider);
         }
      }
      
      public function get masteriesController() : MasteriesController
      {
         return this._masteriesController;
      }
      
      private function onAssetsLoaded() : void
      {
         this.registerModule();
      }
      
      public function loadResources() : void
      {
         var _loc1_:IAction = this._context.loadAssets("/assets/masteries/MasteriesView.swf");
         _loc1_.getCompleted().addOnce(this.onAssetsLoaded);
         this.resourceLoader.init("masteries_resources","/assets/locale/masteries","/masteries_{0}.properties");
      }
   }
}

