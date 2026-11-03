package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import com.riotgames.newplayerlanding.metrics.NPLPTracker;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.MouseEvent;
   
   public class ChampionsPage extends SpriteProxy
   {
      
      private var _header:NPLPHeader;
      
      private var _buttons:Vector.<ChampionButton> = new Vector.<ChampionButton>();
      
      private var _championSplashMetaData:Object = null;
      
      private var _inventoryController:IInventoryController;
      
      private var _statTracker:NPLPTracker;
      
      public function ChampionsPage(param1:IContext, param2:NPLPTracker)
      {
         super(param1);
         this._statTracker = param2;
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ChampionButton = null;
         this._header = new NPLPHeader(this);
         setTimelineChildByName("header",this._header);
         this._header.setTextFromKeys("nplp.champions.heading","nplp.champions.subheading");
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(NewPlayerLandingConfig.NAMESPACE,NewPlayerLandingConfig.CHAMP_DISPLAY_LIST,"");
         if(_loc1_.getString().length > 0)
         {
            _loc2_ = _loc1_.getString().split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = parseInt(_loc2_[_loc3_]);
               _loc5_ = new ChampionButton(_loc3_,_loc4_,this);
               setTimelineChildByName("btnChamp" + (_loc3_ + 1),_loc5_);
               _loc5_.addEventListener(MouseEvent.CLICK,this.onChampClick,false,0,true);
               this._buttons.push(_loc5_);
               _loc3_++;
            }
         }
         super.createChildren();
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this._inventoryController = param1.getInventoryController();
         var _loc2_:* = 0;
         while(_loc2_ < this._buttons.length)
         {
            this._buttons[_loc2_].loadChampionData(this._inventoryController,this._championSplashMetaData);
            _loc2_++;
         }
      }
      
      private function onChampClick(param1:MouseEvent) : void
      {
         if(this._inventoryController == null)
         {
            return;
         }
         var _loc2_:ChampionButton = param1.currentTarget as ChampionButton;
         _loc2_.onClick(this._inventoryController,this._statTracker);
      }
   }
}

