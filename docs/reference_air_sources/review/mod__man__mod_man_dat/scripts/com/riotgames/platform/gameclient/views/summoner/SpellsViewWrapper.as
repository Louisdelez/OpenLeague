package com.riotgames.platform.gameclient.views.summoner
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.pvpnet.spells.SpellsProviderProxy;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import flash.events.Event;
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   
   public class SpellsViewWrapper extends Canvas
   {
      
      private var isShowing:Boolean = false;
      
      private var displayAdapter:DisplayAdapter;
      
      private var _summonerProfileController:SummonerProfileController;
      
      public function SpellsViewWrapper()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.invalidatePropertiesHandler);
         this.addEventListener(Event.ADDED_TO_STAGE,this.invalidatePropertiesHandler);
      }
      
      private function refreshView() : void
      {
         if(this._summonerProfileController == null || this._summonerProfileController.summonerLevel == null)
         {
            return;
         }
         var _loc1_:Boolean = stage != null && this._summonerProfileController.currentState == ProfilePagesEnum.SPELLS_PAGE;
         if(this.isShowing == _loc1_)
         {
            return;
         }
         if(this.isShowing)
         {
            SpellsProviderProxy.instance.hide();
         }
         this.isShowing = _loc1_;
         if(this.isShowing)
         {
            SpellsProviderProxy.instance.show(this.displayAdapter,this._summonerProfileController.summonerLevel);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         this.refreshView();
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         this._summonerProfileController = param1;
         this._summonerProfileController.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.invalidatePropertiesHandler);
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:UIComponent = new UIComponent();
         addChild(_loc1_);
         this.displayAdapter = new DisplayAdapter(_loc1_);
      }
      
      private function invalidatePropertiesHandler(param1:Event) : void
      {
         invalidateProperties();
      }
   }
}

