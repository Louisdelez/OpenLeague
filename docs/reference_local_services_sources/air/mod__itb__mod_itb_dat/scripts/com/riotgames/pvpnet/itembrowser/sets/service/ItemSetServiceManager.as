package com.riotgames.pvpnet.itembrowser.sets.service
{
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   
   public class ItemSetServiceManager implements IItemSetsService
   {
      
      private var config:ClientConfig;
      
      private var serviceEnabled:Boolean;
      
      private var remoteService:ItemSetsService;
      
      private var localService:LocalItemSetsService;
      
      public function ItemSetServiceManager(param1:IBaseLcdsService, param2:ClientConfig)
      {
         super();
         this.localService = new LocalItemSetsService(UserPreferencesManager.instance,UserPreferencesManager.userPrefs,Session.instance);
         this.remoteService = new ItemSetsService(param1);
         this.config = param2;
         this.serviceEnabled = this.config.itemSetServiceEnabled;
         this.config.getItemSetServiceEnabledChanged().add(this.serviceEnabledChangedHandler);
      }
      
      public function saveItemSets(param1:String, param2:Function) : void
      {
         this.localService.saveItemSets(param1,param2);
      }
      
      private function serviceEnabledChangedHandler() : void
      {
         this.serviceEnabled = this.config.itemSetServiceEnabled;
      }
      
      public function getAllItemSetsForPlayer(param1:Number, param2:Function) : void
      {
         this.localService.getAllItemSetsForPlayer(param1,param2);
      }
      
      public function getAllMyItemSets(param1:Function) : void
      {
         this.localService.getAllMyItemSets(param1);
      }
   }
}

