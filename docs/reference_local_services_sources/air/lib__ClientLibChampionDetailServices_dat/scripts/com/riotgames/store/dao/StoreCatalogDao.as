package com.riotgames.store.dao
{
   import blix.action.BasicAction;
   import blix.action.SequenceAction;
   import blix.action.UrlLoaderAction;
   import com.riotgames.platform.common.provider.IStoreProvider;
   import com.riotgames.platform.common.provider.StoreProviderProxy;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.store.model.CatalogResult;
   import com.riotgames.store.model.PurchaseItemParams;
   import com.riotgames.util.logging.getLogger;
   import com.riotgames.util.parseJson;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import mx.logging.ILogger;
   
   public class StoreCatalogDao implements IStoreCatalogDao
   {
      
      private static var catalogCache:CatalogResult;
      
      private var storeUrlAction:BasicAction;
      
      private var logger:ILogger = getLogger(this);
      
      private var storeProvider:IStoreProvider;
      
      public function StoreCatalogDao()
      {
         super();
         this.storeProvider = StoreProviderProxy.instance;
         this.storeUrlAction = new BasicAction(false);
         this.storeUrlAction.getInvoked().add(this.storeUrlActionInvokedHandler);
      }
      
      private static function convertGetParametersToPost(param1:URLRequest) : void
      {
         var _loc3_:String = null;
         var _loc4_:URLVariables = null;
         var _loc5_:String = null;
         param1.method = URLRequestMethod.POST;
         var _loc2_:int = param1.url.indexOf("?");
         if(_loc2_ != -1)
         {
            _loc3_ = param1.url.substr(_loc2_ + 1);
            _loc4_ = new URLVariables(_loc3_);
            if(param1.data == null)
            {
               param1.data = _loc4_;
            }
            else
            {
               for(_loc5_ in _loc4_)
               {
                  param1.data[_loc5_] = _loc4_[_loc5_];
               }
            }
            param1.url = param1.url.substr(0,_loc2_);
         }
      }
      
      private function storeUrlActionInvokedHandler() : void
      {
         this.storeProvider.refreshStoreUrl();
         this.storeProvider.getStoreUrlReadyChanged().add(this.storeUrlReadyChangedHandler);
      }
      
      private function storeUrlReadyChangedHandler() : void
      {
         if(!this.storeProvider.getStoreUrlReady())
         {
            return;
         }
         if(this.storeProvider.getIsStoreAvailable())
         {
            this.logger.info("Store url retrieved.");
            this.storeUrlAction.complete();
         }
         else
         {
            this.storeUrlAction.err(new Error("Store is unavailable."));
         }
      }
      
      public function getCatalogForUser(param1:Function, param2:Function) : void
      {
         var sequence:SequenceAction;
         var urlLoaderAction:UrlLoaderAction = null;
         var successCallback:Function = param1;
         var failCallback:Function = param2;
         if(catalogCache != null)
         {
            this.logger.info("CDP Returning cached catalog.");
            successCallback(catalogCache);
            return;
         }
         urlLoaderAction = new UrlLoaderAction();
         sequence = new SequenceAction();
         sequence.then(this.storeUrlAction);
         sequence.thenCall(function():void
         {
            var _loc1_:String = storeProvider.getCurrentStoreUrl("catalog/getCatalogForUser/" + ClientConfig.instance.locale);
            storeProvider.discardToken();
            var _loc2_:URLRequest = new URLRequest(_loc1_);
            convertGetParametersToPost(_loc2_);
            urlLoaderAction.urlRequest = _loc2_;
         },null,true);
         urlLoaderAction.unmarshallDataFunction = this.unmarshallCatalogResult;
         urlLoaderAction.unmarshallErrorFunction = this.unmarshallError;
         sequence.getCompleted().addOnce(function():void
         {
            successCallback(urlLoaderAction.unmarshalledData);
         });
         sequence.getErred().addOnce(function():void
         {
            failCallback(urlLoaderAction.getError());
         });
         sequence.then(urlLoaderAction);
         this.logger.info("Loading CDP Catalog");
         sequence.invoke();
      }
      
      private function unmarshallCatalogResult(param1:String) : CatalogResult
      {
         var _loc2_:Object = parseJson(param1);
         if(Boolean(_loc2_.error))
         {
            throw new Error(_loc2_.error_message);
         }
         var _loc3_:CatalogResult = CatalogResult.unmarshall(_loc2_);
         catalogCache = _loc3_;
         return _loc3_;
      }
      
      public function purchaseItem(param1:PurchaseItemParams, param2:Function, param3:Function) : void
      {
         var sequence:SequenceAction;
         var urlLoaderAction:UrlLoaderAction = null;
         var purchaseItemParams:PurchaseItemParams = param1;
         var successCallback:Function = param2;
         var failCallback:Function = param3;
         this.logger.info("CDP purchasing item: " + purchaseItemParams.catalog.item.id);
         sequence = new SequenceAction();
         sequence.then(this.storeUrlAction);
         urlLoaderAction = new UrlLoaderAction();
         sequence.thenCall(function():void
         {
            var _loc1_:String = storeProvider.getCurrentStoreUrl("catalog/purchaseItem");
            storeProvider.discardToken();
            var _loc2_:URLRequest = new URLRequest(_loc1_);
            var _loc3_:URLVariables = new URLVariables();
            _loc3_["duration"] = purchaseItemParams.duration;
            _loc3_["duration_type"] = purchaseItemParams.durationType;
            _loc3_["quantity"] = purchaseItemParams.quantity;
            _loc3_["item_id"] = purchaseItemParams.catalog.item.id;
            _loc3_["currency_type"] = purchaseItemParams.currencyType;
            _loc3_["rp"] = purchaseItemParams.catalog.item.rpCost;
            _loc3_["ip"] = purchaseItemParams.catalog.item.ipCost;
            _loc2_.data = _loc3_;
            _loc2_.method = URLRequestMethod.POST;
            convertGetParametersToPost(_loc2_);
            urlLoaderAction.urlRequest = _loc2_;
            logger.info("CDP sending purchase request");
         },null,true);
         urlLoaderAction.unmarshallDataFunction = this.unmarshallPurchaseItem;
         urlLoaderAction.unmarshallErrorFunction = this.unmarshallError;
         sequence.getCompleted().addOnce(function():void
         {
            successCallback(urlLoaderAction.unmarshalledData);
         });
         sequence.getErred().addOnce(function():void
         {
            failCallback(urlLoaderAction.getError());
         });
         sequence.then(urlLoaderAction);
         sequence.invoke();
      }
      
      private function unmarshallPurchaseItem(param1:String) : Object
      {
         var _loc2_:Object = parseJson(param1);
         if(Boolean(_loc2_.error))
         {
            throw new Error(_loc2_.error_message);
         }
         return _loc2_;
      }
      
      private function unmarshallError(param1:String) : Error
      {
         var _loc2_:Object = parseJson(param1);
         return new Error(_loc2_.error_message);
      }
   }
}

