package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import com.riotgames.newplayerlanding.metrics.NPLPTracker;
   import com.riotgames.platform.common.module.championdetail.ChampionDetailContext;
   import com.riotgames.platform.common.provider.ChampionDetailProviderProxy;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.MovieClip;
   import flash.globalization.StringTools;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ChampionButton extends ButtonX
   {
      
      private var _buttonIndex:int;
      
      private var _champId:int;
      
      private var _nameText:TextFieldProxy;
      
      private var _descriptionText:TextFieldProxy;
      
      private var _splashWindow:MovieClipProxy;
      
      public function ChampionButton(param1:int, param2:int, param3:IContext, param4:MovieClip = null)
      {
         super(param3,param4);
         this._buttonIndex = param1;
         this._champId = param2;
      }
      
      public function getButtonIndex() : int
      {
         return this._buttonIndex;
      }
      
      public function getChampionId() : int
      {
         return this._champId;
      }
      
      override protected function createChildren() : void
      {
         this._nameText = new TextFieldProxy(this);
         setTimelineChildByName("championName.template.mask.text",this._nameText);
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this._descriptionText = new TextFieldProxy(this);
         setTimelineChildByName("description",this._descriptionText);
         this._splashWindow = new MovieClipProxy(this);
         setTimelineChildByName("splashWindow",this._splashWindow);
         super.createChildren();
      }
      
      private function getChampion(param1:IInventoryController) : Champion
      {
         return param1.findChampionById(this._champId);
      }
      
      public function onClick(param1:IInventoryController, param2:NPLPTracker) : void
      {
         if(param2)
         {
            param2.onChampClicked(this._buttonIndex);
         }
         var _loc3_:Champion = this.getChampion(param1);
         if(_loc3_ == null)
         {
            return;
         }
         ChampionDetailProviderProxy.instance.displayChampionDetailView(ChampionDetailContext.LANDING_PAGE,_loc3_);
      }
      
      public function loadChampionData(param1:IInventoryController, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:StringTools = null;
         var _loc6_:String = null;
         var _loc7_:IResourceManager = null;
         var _loc3_:Champion = this.getChampion(param1);
         if(_loc3_ != null)
         {
            _loc4_ = ClientConfig.instance.locale.replace("_","-");
            _loc5_ = new StringTools(_loc4_);
            this._nameText.setText(_loc5_.toUpperCase(_loc3_.displayName));
            _loc6_ = "nplp.champions.descriptions." + _loc3_.skinName.toLowerCase();
            _loc7_ = ResourceManager.getInstance();
            this._descriptionText.setText(_loc7_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,_loc6_));
         }
      }
   }
}

