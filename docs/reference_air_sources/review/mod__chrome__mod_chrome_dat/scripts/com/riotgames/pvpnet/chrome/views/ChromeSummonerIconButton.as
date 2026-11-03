package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class ChromeSummonerIconButton extends ButtonX
   {
      
      private var _summonerIconBitmap:BitmapProxy;
      
      private var _summonerIconSizer:SpriteProxy;
      
      private var _summonerIconContainer:SpriteProxy;
      
      private var _summonerLevelText:TextFieldProxy;
      
      public function ChromeSummonerIconButton(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._summonerIconContainer = new SpriteProxy(this);
         setTimelineChildByName("summonerIconContainer",this._summonerIconContainer);
         this._summonerIconBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._summonerIconBitmap.setTransformBehavior(_loc1_);
         this._summonerIconBitmap.setSmoothing(true);
         this.updateSummonerIconBitmap();
         this._summonerIconContainer.addChild(this._summonerIconBitmap);
         AppConfig.instance.summonerIconSourceChanged.add(this.updateSummonerIconBitmap);
         this._summonerIconSizer = new SpriteProxy(this);
         setTimelineChildByName("hitAreaClip",this._summonerIconSizer);
         this._summonerLevelText = new TextFieldProxy(this);
         setTimelineChildByName("summonerLevelText",this._summonerLevelText);
         LobbyConfig.instance.levelUpInfoChanged.add(this.handleLevelUpInfoChanged);
         this.handleLevelUpInfoChanged();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._summonerIconBitmap.setExplicitSize(this._summonerIconSizer.getWidth(),this._summonerIconSizer.getHeight());
         return super.updateLayout(param1,param2);
      }
      
      private function handleLevelUpInfoChanged() : void
      {
         var _loc1_:LevelUpInfo = LobbyConfig.instance.levelUpInfo;
         if(_loc1_)
         {
            this._summonerLevelText.setText(String(_loc1_.currentLevel));
         }
      }
      
      private function updateSummonerIconBitmap() : void
      {
         this._summonerIconBitmap.setBitmapData(AppConfig.instance.summonerIconSource);
         invalidateLayout();
      }
   }
}

