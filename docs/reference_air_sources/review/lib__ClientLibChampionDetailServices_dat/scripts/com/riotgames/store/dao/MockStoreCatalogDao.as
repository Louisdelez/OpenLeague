package com.riotgames.store.dao
{
   import blix.action.UrlLoaderAction;
   import blix.context.Context;
   import blix.logger.Logger;
   import com.riotgames.store.model.CatalogResult;
   import com.riotgames.store.model.PurchaseItemParams;
   import com.riotgames.util.parseJson;
   import flash.net.URLRequest;
   
   public class MockStoreCatalogDao extends Context implements IStoreCatalogDao
   {
      
      public static var catalogCache:CatalogResult;
      
      private var mockDataUrl:String;
      
      private var logger:Logger;
      
      public function MockStoreCatalogDao(param1:String, param2:Context)
      {
         super(param2);
         this.logger = new Logger(this);
         this.mockDataUrl = param1;
      }
      
      public function getCatalogForUser(param1:Function, param2:Function) : void
      {
         var urlLoaderAction:UrlLoaderAction = null;
         var successCallback:Function = param1;
         var failCallback:Function = param2;
         if(catalogCache != null)
         {
            this.logger.logInfo("Returning cached catalog.");
            successCallback(catalogCache);
            return;
         }
         urlLoaderAction = new UrlLoaderAction(new URLRequest(this.mockDataUrl + "catalogForUser.txt"));
         urlLoaderAction.unmarshallDataFunction = this.unmarshallCatalogResult;
         urlLoaderAction.unmarshallErrorFunction = this.unmarshallError;
         urlLoaderAction.getCompleted().addOnce(function():void
         {
            successCallback(urlLoaderAction.unmarshalledData);
         });
         urlLoaderAction.getErred().addOnce(function():void
         {
            failCallback(urlLoaderAction.getError());
         });
         urlLoaderAction.invoke();
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
         var urlLoaderAction:UrlLoaderAction = null;
         var purchaseItemParams:PurchaseItemParams = param1;
         var successCallback:Function = param2;
         var failCallback:Function = param3;
         urlLoaderAction = new UrlLoaderAction(new URLRequest(this.mockDataUrl + "purchaseItem.txt"));
         urlLoaderAction.unmarshallDataFunction = this.unmarshallPurchaseItem;
         urlLoaderAction.unmarshallErrorFunction = this.unmarshallError;
         urlLoaderAction.getCompleted().addOnce(function():void
         {
            successCallback(urlLoaderAction.unmarshalledData);
         });
         urlLoaderAction.getErred().addOnce(function():void
         {
            failCallback(urlLoaderAction.getError());
         });
         urlLoaderAction.invoke();
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

