package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ChromeSummonerInfoView extends SpriteProxy
   {
      
      private var _summonerNameText:TextFieldProxy;
      
      private var _summonerNameTextWidth:Number;
      
      private var _summonerNameTextMiddle:Number;
      
      private var _rpText:TextFieldProxy;
      
      private var _ipText:TextFieldProxy;
      
      private var _xpMeter:SpriteProxy;
      
      private var _rpTooltipTarget:SpriteProxy;
      
      private var _ipTooltipTarget:SpriteProxy;
      
      private var _boostIP:SpriteProxy;
      
      private var _boostXP:SpriteProxy;
      
      private var _inventoryProvider:IInventoryProvider;
      
      public function ChromeSummonerInfoView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         ProviderLookup.getProvider(IInventoryProvider,this.handleInventoryProvider);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         this._rpText = new TextFieldProxy(this);
         setTimelineChildByName("rpText",this._rpText);
         this._ipText = new TextFieldProxy(this);
         setTimelineChildByName("ipText",this._ipText);
         this._xpMeter = new SpriteProxy(this);
         setTimelineChildByName("xpMeter",this._xpMeter);
         this._xpMeter.setTransformBehavior(new ScalingTransformBehavior());
         this._boostIP = new SpriteProxy(this);
         setTimelineChildByName("boostIP",this._boostIP);
         this._boostXP = new SpriteProxy(this);
         setTimelineChildByName("boostXP",this._boostXP);
         this._rpTooltipTarget = new SpriteProxy(this);
         setTimelineChildByName("rpTooltipTarget",this._rpTooltipTarget);
         assignToolTip(this._rpTooltipTarget,ResourceManager.getInstance().getString("resources","navigator_rp_tooltip"));
         this._ipTooltipTarget = new SpriteProxy(this);
         setTimelineChildByName("ipTooltipTarget",this._ipTooltipTarget);
         assignToolTip(this._ipTooltipTarget,ResourceManager.getInstance().getString("resources","navigator_ip_tooltip"));
         LobbyConfig.instance.levelUpInfoChanged.add(this.handleLevelUpInfoChanged);
         this.handleLevelUpInfoChanged();
      }
      
      private function handleInventoryProvider(param1:IInventoryProvider) : void
      {
         this._inventoryProvider = param1;
         this._inventoryProvider.getInventory().addEventListener("riotPointsChanged",this.updateCurrency);
         this._inventoryProvider.getInventory().addEventListener("influencePointsChanged",this.updateCurrency);
         this._inventoryProvider.getInventory().addEventListener("activeBoostsChanged",this.updateActiveBoosts);
         this.updateCurrency();
         this.updateActiveBoosts();
      }
      
      private function updateCurrency(param1:Event = null) : void
      {
         if(Boolean(this._inventoryProvider) && Boolean(this._inventoryProvider.getInventory()))
         {
            this._rpText.setText(String(this._inventoryProvider.getInventory().riotPoints));
            this._ipText.setText(String(this._inventoryProvider.getInventory().influencePoints));
         }
      }
      
      private function updateActiveBoosts(param1:Event = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(Boolean(this._inventoryProvider) && Boolean(this._inventoryProvider.getInventory()))
         {
            _loc2_ = Boolean(this._inventoryProvider.getInventory().activeBoosts.ipBoostEnabled);
            this._boostIP.setVisible(_loc2_);
            if(_loc2_)
            {
               _loc4_ = "<font size=\'18\'><bold>" + ResourceManager.getInstance().getString("resources","summonerProfile_info_ipBoostTitle_tooltip") + "</bold></font>\n\n<font size=\'14\'><font color=\'#009CFF\'>" + ResourceManager.getInstance().getString("resources","summonerProfile_info_perWiBoostsSubTitle_tooltip") + "</font>\n" + this._inventoryProvider.getInventory().activeBoosts.displayIpBoostPerWinCount + "\n\n<font color=\'#009CFF\'>" + ResourceManager.getInstance().getString("resources","summonerProfile_info_timeeBasedBoostsSubTitle_tooltip") + "</font>\n" + this._inventoryProvider.getInventory().activeBoosts.displayIpEndDate + "</font>";
               assignToolTip(this._boostIP,_loc4_);
            }
            _loc3_ = Boolean(this._inventoryProvider.getInventory().activeBoosts.xpBoostEnabled);
            this._boostXP.setVisible(_loc3_);
            if(_loc3_)
            {
               _loc5_ = "<font size=\'18\'><bold>" + ResourceManager.getInstance().getString("resources","summonerProfile_info_xpBoostTitle_tooltip") + "</bold></font>\n\n<font size=\'14\'><font color=\'#009CFF\'>" + ResourceManager.getInstance().getString("resources","summonerProfile_info_perWiBoostsSubTitle_tooltip") + "</font>\n" + this._inventoryProvider.getInventory().activeBoosts.displayXpBoostPerWinCount + "\n\n<font color=\'#009CFF\'>" + ResourceManager.getInstance().getString("resources","summonerProfile_info_timeeBasedBoostsSubTitle_tooltip") + "</font>\n" + this._inventoryProvider.getInventory().activeBoosts.displayXpEndDate + "</font>";
               assignToolTip(this._boostXP,_loc5_);
            }
         }
      }
      
      private function handleLevelUpInfoChanged() : void
      {
         var _loc1_:LevelUpInfo = LobbyConfig.instance.levelUpInfo;
         if(_loc1_)
         {
            this._summonerNameText.setText(_loc1_.summonerName);
            invalidateLayout();
            if(_loc1_.currentLevel == 30)
            {
               this._xpMeter.setScaleX(1);
            }
            else
            {
               this._xpMeter.setScaleX(_loc1_.percentCompleteForNextLevel);
            }
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(!this._summonerNameTextWidth)
         {
            this._summonerNameTextWidth = this._summonerNameText.getWidth() / this._summonerNameText.getScaleX() - 4;
            this._summonerNameTextMiddle = this._summonerNameText.getY() + this._summonerNameText.getHeight() / 2;
         }
         var _loc3_:Number = 1;
         if(this._summonerNameTextWidth < this._summonerNameText.getTextWidth())
         {
            _loc3_ = this._summonerNameTextWidth / this._summonerNameText.getTextWidth();
         }
         this._summonerNameText.setScaleX(_loc3_);
         this._summonerNameText.setScaleY(_loc3_);
         this._summonerNameText.setWidth(this._summonerNameTextWidth / _loc3_ + 4);
         this._summonerNameText.setY(this._summonerNameTextMiddle - this._summonerNameText.getHeight() / 2);
         return super.updateLayout(param1,param2);
      }
   }
}

