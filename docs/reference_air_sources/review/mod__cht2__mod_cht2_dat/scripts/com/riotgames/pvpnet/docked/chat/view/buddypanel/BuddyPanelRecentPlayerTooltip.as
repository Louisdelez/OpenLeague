package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.chat.domain.RecentPlayerItem;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelRecentPlayerTooltip extends SpriteProxy implements IDataRenderer
   {
      
      private var _recentPlayer:RecentPlayerItem;
      
      private var _iconSizer:SpriteProxy;
      
      private var _summonerNameText:TextFieldProxy;
      
      private var _summonerLevelText:TextFieldProxy;
      
      private var _lastSeenText:TextFieldProxy;
      
      private var _championBitmap:BitmapProxy;
      
      public function BuddyPanelRecentPlayerTooltip(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("RecentPlayerTooltip");
      }
      
      override protected function createChildren() : void
      {
         this._iconSizer = new SpriteProxy(this);
         setTimelineChildByName("iconContainer",this._iconSizer);
         this._summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         this._summonerLevelText = new TextFieldProxy(this);
         setTimelineChildByName("summonerLevelText",this._summonerLevelText);
         this._lastSeenText = new TextFieldProxy(this);
         setTimelineChildByName("lastSeenText",this._lastSeenText);
         this._championBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._championBitmap.setTransformBehavior(_loc1_);
         this._championBitmap.setSmoothing(true);
         addChild(this._championBitmap);
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._championBitmap.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         this._championBitmap.setExplicitPosition(this._iconSizer.getX(),this._iconSizer.getY());
         return _asset.getBounds(null);
      }
      
      private function setRecentPlayer(param1:RecentPlayerItem) : void
      {
         var _loc2_:String = null;
         if(this._recentPlayer != param1)
         {
            this._recentPlayer = param1;
            if(Boolean(this._recentPlayer) && Boolean(this._recentPlayer.playerStats))
            {
               this._summonerNameText.setText(this._recentPlayer.playerStats.summonerName);
               this._summonerLevelText.setText(ResourceManager.getInstance().getString("resources","BuddyList_recentlyplayed_level",[this._recentPlayer.playerStats.level]));
               _loc2_ = DateUtil.getDateAndTimeString(this._recentPlayer.timeStamp);
               this._lastSeenText.setText(ResourceManager.getInstance().getString("resources","BuddyList_recentlyplayed_lastseen_parameterized",[_loc2_]));
               if(this._recentPlayer.playerStats.skinName)
               {
                  this._championBitmap.setBitmapData(ChampionIconCacheUtil.instance.getIcon(this._recentPlayer.playerStats.skinName));
               }
               else
               {
                  this._championBitmap.setBitmapData(null);
               }
            }
            else
            {
               this._championBitmap.setBitmapData(null);
               this._summonerNameText.setText("");
               this._summonerLevelText.setText("");
               this._lastSeenText.setText("");
            }
         }
      }
      
      public function getData() : *
      {
         return this._recentPlayer;
      }
      
      public function setData(param1:*) : void
      {
         this.setRecentPlayer(param1);
      }
   }
}

