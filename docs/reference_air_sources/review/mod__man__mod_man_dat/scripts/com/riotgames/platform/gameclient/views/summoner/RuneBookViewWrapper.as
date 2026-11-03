package com.riotgames.platform.gameclient.views.summoner
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.runes.IRunesProvider;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   
   public class RuneBookViewWrapper extends UIComponent
   {
      
      private var _summonerProfileController:SummonerProfileController;
      
      private var accountId:Number;
      
      private var parentDisplay:DisplayAdapter;
      
      private var isShowing:Boolean = false;
      
      private var screenProvider:IRunesProvider;
      
      public function RuneBookViewWrapper()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.invalidatePropertiesHandler);
         this.addEventListener(Event.ADDED_TO_STAGE,this.invalidatePropertiesHandler);
      }
      
      private function refreshView() : void
      {
         var _loc1_:Boolean = stage != null && this._summonerProfileController.currentState == ProfilePagesEnum.RUNES_PAGE;
         var _loc2_:Number = Number(this._summonerProfileController.baseSummoner.acctId);
         if(this.isShowing == _loc1_ && _loc2_ == this.accountId)
         {
            return;
         }
         if(this.isShowing)
         {
            this.screenProvider.hide();
         }
         this.isShowing = _loc1_;
         this.accountId = _loc2_;
         if(this.isShowing)
         {
            this.screenProvider.show(this.accountId,this.parentDisplay);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.parentDisplay = new DisplayAdapter(this);
         ProviderLookup.getProvider(IRunesProvider,this.gotRunesProvider);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this._summonerProfileController == null)
         {
            throw new Error("Dependency summonerProfilerController not set.");
         }
         this.refreshView();
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         this._summonerProfileController = param1;
         this._summonerProfileController.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.invalidatePropertiesHandler);
      }
      
      private function invalidatePropertiesHandler(param1:Event) : void
      {
         invalidateProperties();
      }
      
      private function gotRunesProvider(param1:IRunesProvider) : void
      {
         this.screenProvider = param1;
         invalidateProperties();
      }
   }
}

