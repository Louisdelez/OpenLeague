package com.riotgames.pvpnet.CLS.views.yourrankedstats
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.inventory.InventoryUtils;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.models.ChampionSummaryStatsData;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.display.Sprite;
   
   public class SummonerChampsStats extends SpriteProxy
   {
      
      private const AVATAR_WIDTH:Number = 49;
      
      private const AVATAR_HEIGHT:Number = 49;
      
      private var _titleText:TextFieldProxy;
      
      private var _championName:TextFieldProxy;
      
      private var _kdaTitle:TextFieldProxy;
      
      private var _kdaValue:TextFieldProxy;
      
      private var _goldMinTitle:TextFieldProxy;
      
      private var _goldMinValue:TextFieldProxy;
      
      private var _avatarContainer:SpriteProxy;
      
      private var _avatar:BitmapProxy;
      
      private var _titleTextStr:String;
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _errorString:String;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _championIdMappping:Array;
      
      public function SummonerChampsStats(param1:IContext, param2:String, param3:Sprite = null)
      {
         this._titleTextStr = param2;
         super(param1,param3);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._championIdMappping = InventoryProviderProxy.instance.getInventory().championIdMapping;
         this._titleText = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("titleTxt",this._titleText);
         this._titleText.setText(this._titleTextStr);
         this._championName = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("championName",this._championName);
         this._kdaTitle = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("kdaTitle",this._kdaTitle);
         this._kdaValue = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("kdaValue",this._kdaValue);
         this._goldMinTitle = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("goldMinTitle",this._goldMinTitle);
         this._goldMinValue = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("goldMinValue",this._goldMinValue);
         this._avatarContainer = new SpriteProxy(this);
         setTimelineChildByName("avatarContainer",this._avatarContainer);
         this._avatar = new BitmapProxy(this);
         this._avatar.setTransformBehavior(new ScalingTransformBehavior());
         this._avatar.setExplicitSize(this.AVATAR_WIDTH,this.AVATAR_HEIGHT);
         this._avatarContainer.addChild(this._avatar);
         this._localeHelper = getDependency(ILocaleHelper);
         var _loc1_:SingleLineToolTip = new SingleLineToolTip(this);
         this._tooltipHandler = new EmblemsToolTipHandler(_loc1_,1,0);
         var _loc2_:EmblemModel = new EmblemModel(this._localeHelper.localeLookup("ttKDALabel"),"");
         assignToolTip(this._kdaTitle,_loc2_,this._tooltipHandler);
         assignToolTip(this._kdaValue,_loc2_,this._tooltipHandler);
         var _loc3_:EmblemModel = new EmblemModel(this._localeHelper.localeLookup("ttGoldMinute"),"");
         assignToolTip(this._goldMinTitle,_loc3_,this._tooltipHandler);
         assignToolTip(this._goldMinValue,_loc3_,this._tooltipHandler);
         var _loc4_:ILocaleHelper = getDependency(ILocaleHelper);
         this._errorString = _loc4_.localeLookup("errInvalidChamp");
      }
      
      public function updateFromStats(param1:ChampionSummaryStatsData) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.setChampionFromId(param1.championId);
         this._kdaValue.setText(param1.kda.toFixed(1).toString());
         this._goldMinValue.setText(param1.goldPerMin.toFixed(1).toString());
      }
      
      public function setChampionFromId(param1:uint) : void
      {
         var _loc2_:Champion = InventoryUtils.findChampionById(param1,this._championIdMappping);
         if(_loc2_)
         {
            this._avatar.setBitmapData(ChampionIconCacheUtil.instance.getIcon(_loc2_.skinName));
            this._championName.setText(_loc2_.displayName);
         }
         else
         {
            this._championName.setText(this._errorString);
         }
      }
      
      override public function destroy() : void
      {
         this._avatarContainer.removeAllChildren();
         this._avatar.destroy();
         this._avatarContainer.destroy();
         super.destroy();
      }
   }
}

