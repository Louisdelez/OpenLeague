package com.riotgames.platform.module.masteries.provider
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.signals.ISignal;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.module.masteries.controller.MasteriesController;
   import mx.collections.ArrayCollection;
   
   public class MasteriesProviderImpl implements IMasteriesProvider
   {
      
      private var _masteriesController:MasteriesController;
      
      public function MasteriesProviderImpl(param1:MasteriesController)
      {
         super();
         this._masteriesController = param1;
         if(!this._masteriesController)
         {
            throw new Error("MasteriesController for Masteries Provider creation is null.");
         }
      }
      
      public function getPagesInfo() : ArrayCollection
      {
         return this._masteriesController.getMasteryPagesInfo();
      }
      
      public function showMasteries(param1:Number, param2:DisplayAdapter, param3:Boolean = false) : void
      {
         this._masteriesController.showMasteriesView(param1,param2,param3);
      }
      
      public function getSelectedPageID() : int
      {
         return 0;
      }
      
      public function closeMasteries() : void
      {
         this._masteriesController.closeMasteries();
      }
      
      public function setSelectedPageByID(param1:int) : void
      {
         this._masteriesController.setSelectedPageByID(param1);
      }
      
      public function getPagesInfoUpdated() : ISignal
      {
         return this._masteriesController.getMasteryPagesInfoUpdated();
      }
   }
}

