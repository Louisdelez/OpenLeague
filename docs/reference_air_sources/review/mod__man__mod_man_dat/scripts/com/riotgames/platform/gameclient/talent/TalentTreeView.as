package com.riotgames.platform.gameclient.talent
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.MasteriesProviderProxy;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   
   public class TalentTreeView extends UIComponent
   {
      
      private var masteriesProvider:IMasteriesProvider;
      
      private var summonerId:Number = 0;
      
      private var _summonerProfileController:SummonerProfileController;
      
      private var isShowing:Boolean = false;
      
      private var parentDisplay:DisplayAdapter;
      
      public function TalentTreeView()
      {
         super();
         this.masteriesProvider = MasteriesProviderProxy.instance;
         this.parentDisplay = new DisplayAdapter(this);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.invalidatePropertiesHandler);
         this.addEventListener(Event.ADDED_TO_STAGE,this.invalidatePropertiesHandler);
      }
      
      private function refreshView() : void
      {
         if(this._summonerProfileController == null)
         {
            return;
         }
         var _loc1_:Boolean = stage != null && this._summonerProfileController.currentState == ProfilePagesEnum.MASTERIES_PAGE;
         var _loc2_:Number = this._summonerProfileController.isLocalSummoner == true ? 0 : Number(this._summonerProfileController.baseSummoner.summonerId);
         if(this.isShowing == _loc1_ && _loc2_ == this.summonerId)
         {
            return;
         }
         if(this.isShowing)
         {
            this.masteriesProvider.closeMasteries();
         }
         this.isShowing = _loc1_;
         this.summonerId = _loc2_;
         if(this.isShowing)
         {
            this.masteriesProvider.showMasteries(this.summonerId,this.parentDisplay);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         this.refreshView();
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._summonerProfileController = param1;
         this._summonerProfileController.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.invalidatePropertiesHandler);
         this.refreshView();
      }
      
      private function invalidatePropertiesHandler(param1:Event) : void
      {
         invalidateProperties();
      }
      
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._summonerProfileController;
      }
   }
}

