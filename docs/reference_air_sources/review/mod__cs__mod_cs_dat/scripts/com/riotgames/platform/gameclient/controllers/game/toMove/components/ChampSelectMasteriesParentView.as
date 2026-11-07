package com.riotgames.platform.gameclient.controllers.game.toMove.components
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.MasteriesProviderProxy;
   import flash.events.Event;
   import mx.core.UIComponent;
   
   public class ChampSelectMasteriesParentView extends UIComponent
   {
      
      private var masteriesProvider:IMasteriesProvider;
      
      public function ChampSelectMasteriesParentView()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.masteriesProvider = MasteriesProviderProxy.instance;
         this.masteriesProvider.showMasteries(0,new DisplayAdapter(this));
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.masteriesProvider = MasteriesProviderProxy.instance;
         this.masteriesProvider.closeMasteries();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
   }
}

