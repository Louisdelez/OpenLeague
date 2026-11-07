package com.riotgames.platform.gameclient.items
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.profile.IOldProfileScreenProvider;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.provider.ProviderLookup;
   import flash.events.Event;
   import mx.core.UIComponent;
   
   public class ItemBrowserViewWrapper extends UIComponent
   {
      
      private var screenProvider:IOldProfileScreenProvider;
      
      private var showing:Boolean = false;
      
      private var shown:Boolean = false;
      
      public var summonerProfileController:SummonerProfileController;
      
      public function ItemBrowserViewWrapper()
      {
         super();
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         ProviderLookup.instance.getSpecificProviderPublished("com.riotgames.pvpnet.itembrowser::IItemBrowserProvider").add(this.gotModule);
         ProviderLookup.instance.requestProvider("com.riotgames.pvpnet.itembrowser::IItemBrowserProvider");
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
      }
      
      private function gotModule(param1:IOldProfileScreenProvider) : void
      {
         this.screenProvider = param1;
         if(this.showing)
         {
            this.showItemBrowser();
         }
      }
      
      public function closeItemBrowser() : void
      {
         if(this.screenProvider != null && this.shown)
         {
            this.screenProvider.hide();
            this.shown = false;
         }
         this.showing = false;
      }
      
      public function showItemBrowser() : void
      {
         this.showing = true;
         if(this.screenProvider != null && !this.shown)
         {
            if(this.summonerProfileController.isLocalSummoner == true)
            {
               this.screenProvider.show(0,new DisplayAdapter(this));
            }
            else
            {
               this.screenProvider.show(this.summonerProfileController.baseSummoner.summonerId,new DisplayAdapter(this));
            }
            this.showing = false;
            this.shown = true;
         }
      }
   }
}

