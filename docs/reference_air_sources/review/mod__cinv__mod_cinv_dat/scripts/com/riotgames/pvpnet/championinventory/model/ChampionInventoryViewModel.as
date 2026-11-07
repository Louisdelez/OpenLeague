package com.riotgames.pvpnet.championinventory.model
{
   import blix.ds.IListX;
   import blix.ds.ListX;
   import mx.resources.IResourceManager;
   
   public class ChampionInventoryViewModel
   {
      
      private var _championList:IListX;
      
      private var _roles:IListX;
      
      private var _showRentals:Boolean;
      
      private var _resourceManager:IResourceManager;
      
      private var _ownedStates:IListX;
      
      public function ChampionInventoryViewModel(param1:IResourceManager, param2:IListX, param3:IListX, param4:Boolean)
      {
         super();
         this._resourceManager = param1;
         this._showRentals = param4;
         this._roles = param3;
         this._championList = param2;
         this.createOwnedStates();
      }
      
      public function getChampionList() : IListX
      {
         return this._championList;
      }
      
      public function getRoles() : IListX
      {
         return this._roles;
      }
      
      private function createOwnedStates() : void
      {
         var _loc1_:ListX = new ListX();
         _loc1_.addItem(this.createAvailabilityItem("championFilter_owned_all",ChampionAvailabilityEnums.FILTER_ALL));
         _loc1_.addItem(this.createAvailabilityItem("championFilter_available",ChampionAvailabilityEnums.FILTER_AVAILABLE));
         _loc1_.addItem(this.createAvailabilityItem("championFilter_owned_owned",ChampionAvailabilityEnums.FILTER_OWNED));
         if(this._showRentals)
         {
            _loc1_.addItem(this.createAvailabilityItem("championFilter_owned_rented",ChampionAvailabilityEnums.FILTER_RENTED));
            _loc1_.addItem(this.createAvailabilityItem("championFilter_owned_rented_expired",ChampionAvailabilityEnums.FILTER_RENTED_EXPIRED));
         }
         _loc1_.addItem(this.createAvailabilityItem("championFilter_owned_notOwned",ChampionAvailabilityEnums.FILTER_NOT_OWNED));
         _loc1_.addItem(this.createAvailabilityItem("championFilter_recentlyPurchased",ChampionAvailabilityEnums.FILTER_RECENT_PURCHASE));
         if(this._showRentals)
         {
            _loc1_.addItem(this.createAvailabilityItem("championFilter_pending_expiration",ChampionAvailabilityEnums.FILTER_PENDING_EXPIRATION));
         }
         this._ownedStates = _loc1_;
      }
      
      public function getOwnedStates() : IListX
      {
         return this._ownedStates;
      }
      
      private function createAvailabilityItem(param1:String, param2:int) : ChampionAvailabilityStatus
      {
         return new ChampionAvailabilityStatus(this._resourceManager.getString("resources",param1),param2);
      }
   }
}

