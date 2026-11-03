package com.riotgames.pvpnet.CLS.views.yourrankedstats
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.inventory.InventoryUtils;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   
   public class TopPlayedItemRenderer extends StatefulView
   {
      
      public static const ENABLED_STATE:String = "played";
      
      public static const DISABLED_STATE:String = "notPlayed";
      
      private const AVATAR_WIDTH:Number = 25;
      
      private const AVATAR_HEIGHT:Number = 25;
      
      private var _rendererText:TextFieldProxy;
      
      private var _avatarContainer:SpriteProxy;
      
      private var _avatarBitmap:BitmapProxy;
      
      private var _championIdMapping:Array;
      
      public function TopPlayedItemRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setCurrentState(DISABLED_STATE);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._championIdMapping = InventoryProviderProxy.instance.getInventory().championIdMapping;
         this._rendererText = new TextFieldProxy(this);
         setTimelineChildByName("championName",this._rendererText);
         this._avatarBitmap = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this._avatarBitmap.setTransformBehavior(_loc1_);
         this._avatarBitmap.setSmoothing(true);
         this._avatarContainer = new SpriteProxy(this);
         setTimelineChildByName("avatarContainer",this._avatarContainer);
         this._avatarContainer.addChild(this._avatarBitmap);
      }
      
      override public function destroy() : void
      {
         this._avatarBitmap.destroy();
         this._avatarContainer.removeAllChildren();
         this._avatarContainer.destroy();
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._avatarBitmap.setExplicitSize(this.AVATAR_WIDTH,this.AVATAR_HEIGHT);
         return new Rectangle(0,0,this.AVATAR_WIDTH,this.AVATAR_HEIGHT);
      }
      
      public function clearData() : void
      {
         this._avatarContainer.removeAllChildren();
         this._avatarBitmap.setBitmapData(null);
         this._rendererText.setText(null);
         setCurrentState(DISABLED_STATE);
      }
      
      public function setChampionFromId(param1:uint, param2:int) : void
      {
         var champion:Champion = null;
         var id:uint = param1;
         var timeout:int = param2;
         this._avatarContainer.removeAllChildren();
         champion = InventoryUtils.findChampionById(id,this._championIdMapping);
         if(champion)
         {
            setTimeout(function():void
            {
               setChampion(champion.skinName,champion.displayName);
            },timeout);
         }
      }
      
      public function setPlayerFromId(param1:ListItemObjectModel, param2:int) : void
      {
         var player:ListItemObjectModel = param1;
         var timeout:int = param2;
         this._avatarContainer.removeAllChildren();
         setTimeout(function():void
         {
            _avatarContainer.setVisible(false);
            if(player.iconId >= 0)
            {
               _avatarBitmap.setBitmapData(BuddyImages.getSummonerIconSafely(player.iconId));
               _rendererText.setText(player.summonerName);
               if(_avatarBitmap)
               {
                  _avatarContainer.addChild(_avatarBitmap);
                  _avatarBitmap.setExplicitSize(AVATAR_WIDTH,AVATAR_HEIGHT);
               }
            }
            setCurrentState(ENABLED_STATE);
         },timeout);
      }
      
      public function setChampion(param1:String, param2:String) : void
      {
         this._avatarBitmap.setBitmapData(ChampionIconCacheUtil.instance.getIcon(param1));
         this._rendererText.setText(param2);
         if(this._avatarBitmap)
         {
            this._avatarContainer.addChild(this._avatarBitmap);
            this._avatarBitmap.setExplicitSize(this.AVATAR_WIDTH,this.AVATAR_HEIGHT);
            this._avatarContainer.setVisible(true);
         }
         else
         {
            this._avatarContainer.setVisible(false);
         }
         setCurrentState(ENABLED_STATE);
      }
   }
}

