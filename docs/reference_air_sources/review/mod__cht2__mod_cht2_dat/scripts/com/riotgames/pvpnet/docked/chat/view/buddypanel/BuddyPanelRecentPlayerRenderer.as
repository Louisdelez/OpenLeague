package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.chat.domain.RecentPlayerItem;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.tips.ITipsProvider;
   import flash.display.MovieClip;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class BuddyPanelRecentPlayerRenderer extends ButtonX implements IItemRenderer
   {
      
      private var _index:uint;
      
      private var _recentPlayerInfo:RecentPlayerItem;
      
      private var _championBitmap:BitmapProxy;
      
      private var _championIconContainer:SpriteProxy;
      
      private var _summonerNameText:TextFieldProxy;
      
      public function BuddyPanelRecentPlayerRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("RecentPlayerRenderer");
      }
      
      override protected function createChildren() : void
      {
         this._championIconContainer = new SpriteProxy(this);
         setTimelineChildByName("iconContainer",this._championIconContainer);
         this._championBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._championBitmap.setTransformBehavior(_loc1_);
         this._championBitmap.setSmoothing(true);
         addChild(this._championBitmap);
         this._summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         addEventListener(MouseEvent.RIGHT_CLICK,this.handleContextMenu);
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._championBitmap.setExplicitSize(this._championIconContainer.getWidth(),this._championIconContainer.getHeight());
         this._championBitmap.setExplicitPosition(this._championIconContainer.getX(),this._championIconContainer.getY());
         return _asset.getBounds(null);
      }
      
      private function handleContextMenu(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._recentPlayerInfo || !this._recentPlayerInfo.playerStats)
         {
            return;
         }
         var _loc2_:NativeMenu = new NativeMenu();
         var _loc3_:Point = this.localToGlobal(new Point(param1.localX,param1.localY));
         this.buildMenuItem(_loc2_,ResourceManager.getInstance().getString("resources","BuddyListTreeRenderer_viewProfile"),this.handleViewProfile,true);
         this.buildMenuItem(_loc2_,ResourceManager.getInstance().getString("resources","BuddyListTreeRenderer_groupAddBuddy"),this.handleAddFriend,true);
         _loc2_.display(this.getStage(),_loc3_.x,_loc3_.y);
      }
      
      private function buildMenuItem(param1:NativeMenu, param2:String, param3:Function, param4:Boolean) : void
      {
         var _loc5_:NativeMenuItem = new NativeMenuItem(param2);
         _loc5_.enabled = param4;
         param1.addItem(_loc5_);
         if(param3 != null)
         {
            _loc5_.addEventListener(Event.SELECT,param3,false,0,true);
         }
      }
      
      private function handleViewProfile(param1:Event) : void
      {
         var _loc2_:ILegacyProfileNavigationProvider = getDependency(ILegacyProfileNavigationProvider);
         _loc2_.searchForSummoner(this._recentPlayerInfo.playerStats.summonerName,null);
      }
      
      private function handleAddFriend(param1:Event) : void
      {
         var _loc2_:ChatViewMediator = getDependency(ChatViewMediator);
         _loc2_.addBuddy(this._recentPlayerInfo.playerStats.summonerName);
      }
      
      private function setRecentPlayer(param1:RecentPlayerItem) : void
      {
         var _loc2_:ITipsProvider = getDependency(ITipsProvider);
         this._recentPlayerInfo = param1;
         if(Boolean(this._recentPlayerInfo) && Boolean(this._recentPlayerInfo.playerStats))
         {
            _loc2_.assignCustomToolTip(this,this._recentPlayerInfo,BuddyPanelRecentPlayerTooltip);
            this._summonerNameText.setText(this._recentPlayerInfo.playerStats.summonerName);
            if(this._recentPlayerInfo.playerStats.skinName)
            {
               this._championBitmap.setBitmapData(ChampionIconCacheUtil.instance.getIcon(this._recentPlayerInfo.playerStats.skinName));
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
            unassignToolTip(this);
         }
      }
      
      override public function getData() : *
      {
         return null;
      }
      
      override public function setData(param1:*) : void
      {
         this.setRecentPlayer(param1);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
   }
}

