package com.riotgames.pvpnet.system.product
{
   import blix.signals.IOnceSignal;
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.util.logging.getLogger;
   import flash.utils.Dictionary;
   
   public class MultiProductController implements IMultiProductProvider, IProvider
   {
      
      private static const PRODUCT_LOAD_STATUS_LOADING:String = "loading";
      
      private static const PRODUCT_LOAD_STATUS_READY:String = "ready";
      
      private static const PRODUCT_LOAD_STATUS_LOADED:String = "loaded";
      
      private static const PRODUCT_LOAD_STATUS_INVALID:String = "invalid";
      
      private static const PRODUCT_LOAD_STATUS_FAILED_LOAD:String = "failed";
      
      private var loadingModules:Dictionary;
      
      private var _initialized:OnceSignal = new OnceSignal();
      
      private var _products:Vector.<IProductProvider> = new Vector.<IProductProvider>();
      
      private var _currentProduct:IProductProvider;
      
      private var _currentProductChanged:Signal = new Signal();
      
      public function MultiProductController()
      {
         super();
      }
      
      public function initialize(param1:Vector.<RiotModuleInfo>) : void
      {
         var _loc2_:RiotModuleInfo = null;
         SharedNavigationMenu.initialize();
         this.loadingModules = new Dictionary();
         for each(_loc2_ in param1)
         {
            this.loadingModules[_loc2_] = PRODUCT_LOAD_STATUS_LOADING;
            _loc2_.getCompleted().add(this.moduleLoadCompleted);
            _loc2_.getErred().add(this.moduleLoadErred);
            _loc2_.load();
         }
      }
      
      public function getInitialized() : IOnceSignal
      {
         return this._initialized;
      }
      
      public function getCurrentProduct() : IProductProvider
      {
         return this._currentProduct;
      }
      
      public function setCurrentProduct(param1:IProductProvider) : void
      {
         var _loc2_:IProductProvider = null;
         if(param1 != this._currentProduct)
         {
            _loc2_ = this._currentProduct;
            this._currentProduct = param1;
            this._currentProductChanged.dispatch(_loc2_,this._currentProduct);
         }
      }
      
      public function setCurrentProductByName(param1:String) : Boolean
      {
         var _loc2_:IProductProvider = null;
         for each(_loc2_ in this._products)
         {
            if(_loc2_.getName() == param1)
            {
               this.setCurrentProduct(_loc2_);
               return true;
            }
         }
         return false;
      }
      
      public function getCurrentProductChanged() : ISignal
      {
         return this._currentProductChanged;
      }
      
      public function getProducts() : Vector.<IProductProvider>
      {
         return this._products;
      }
      
      private function moduleLoadCompleted(param1:ProviderModuleInfo) : void
      {
         var module:ProviderModuleInfo = param1;
         var instance:IProductProvider = module.getModuleInstance() as IProductProvider;
         if(instance != null)
         {
            instance.initializeProduct(this);
            this.loadingModules[module] = PRODUCT_LOAD_STATUS_LOADED;
            instance.getProductInitialized().add(function(param1:IProductProvider):void
            {
               productInitializedHandler(module,param1);
            });
         }
         else
         {
            this.loadingModules[module] = PRODUCT_LOAD_STATUS_INVALID;
            getLogger(this).warn("The module " + module.getFileName() + "\'s definition includes a product but no product provider was found.");
         }
      }
      
      private function productInitializedHandler(param1:ProviderModuleInfo, param2:IProductProvider) : void
      {
         if(param2 != null)
         {
            this._products[this._products.length] = param2;
            this.loadingModules[param1] = PRODUCT_LOAD_STATUS_READY;
            getLogger(this).info("Product module " + param2.getName() + " ready.");
         }
         else
         {
            this.loadingModules[param1] = PRODUCT_LOAD_STATUS_INVALID;
            getLogger(this).warn("The module " + param1.getFileName() + "\'s definition includes a product but no product provider was found.");
         }
         this.checkForAllModulesLoaded();
      }
      
      private function moduleLoadErred(param1:RiotModuleInfo) : void
      {
         this.loadingModules[param1] = PRODUCT_LOAD_STATUS_FAILED_LOAD;
         getLogger(this).warn("The product module " + param1.getFileName() + "\'does not appear to exist.");
         this.checkForAllModulesLoaded();
      }
      
      private function checkForAllModulesLoaded() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.loadingModules)
         {
            if(_loc1_ == PRODUCT_LOAD_STATUS_LOADING || _loc1_ == PRODUCT_LOAD_STATUS_LOADED)
            {
               return;
            }
         }
         this._initialized.dispatch(this);
      }
   }
}

