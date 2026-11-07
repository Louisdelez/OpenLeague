package com.riotgames.pvpnet.championinventory.views
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.module.championdetail.ChampionDetailContext;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ChampionInventoryListItemRenderer extends ButtonX implements IItemRenderer
   {
      
      private var _champion:Champion;
      
      private var image:BitmapProxy;
      
      private var imageSizer:SpriteProxy;
      
      private var grayscaleFilter:ColorMatrixFilter;
      
      private var championNameField:Text;
      
      private var _freeToPlayIcon:SpriteProxy;
      
      private var _index:uint;
      
      private var _rewardIcon:SpriteProxy;
      
      private var _championDetailProvider:IChampionDetailProvider;
      
      private var _border:StatefulView;
      
      public function ChampionInventoryListItemRenderer(param1:IContext)
      {
         super(param1);
         setTabEnabled(false);
         setLinkage("ChampionItem");
         addEventListener(MouseEvent.CLICK,this.selectionHandler);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._championDetailProvider = getDependency(IChampionDetailProvider);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:DisplayObjectContainerProxy = new DisplayObjectContainerProxy(this);
         setTimelineChildByName("imageHolder",_loc1_);
         this.image = new BitmapProxy(this);
         this.image.setTransformBehavior(new ScalingTransformBehavior());
         _loc1_.addChild(this.image);
         this._border = new StatefulView(this);
         setTimelineChildByName("border",this._border);
         this._border.setCurrentState("normal");
         this._rewardIcon = new SpriteProxy(this);
         setTimelineChildByName("rewardIcon",this._rewardIcon);
         this._rewardIcon.setVisible(false);
         this._freeToPlayIcon = new SpriteProxy(this);
         setTimelineChildByName("freeToPlayIcon",this._freeToPlayIcon);
         this._freeToPlayIcon.setVisible(false);
         this.imageSizer = new SpriteProxy(this);
         setTimelineChildByName("imageSizer",this.imageSizer);
         this.championNameField = new Text(this);
         this.championNameField.setAutoSize(TextFieldAutoSize.CENTER);
         setTimelineChildByName("championNameField",this.championNameField);
         this.grayscaleFilter = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,1,0]);
      }
      
      private function onChampionPropertyChanged() : void
      {
         this.updateChampionProperties();
      }
      
      private function updateChampionProperties() : void
      {
         this._freeToPlayIcon.setVisible(false);
         this._rewardIcon.setVisible(false);
         this._border.setCurrentState("normal");
         if(this._champion != null)
         {
            this.image.setFilters([]);
            this.championNameField.setText(this._champion.displayName);
            if(this._champion.freeToPlay)
            {
               this._freeToPlayIcon.setVisible(true);
            }
            if(!this._champion.owned && Boolean(this._champion.freeToPlayReward))
            {
               this._border.setCurrentState("reward");
               this._rewardIcon.setVisible(true);
            }
            if(!this._champion.isAvailable(true))
            {
               this.image.setFilters([this.grayscaleFilter]);
            }
            ChampionIconCacheUtil.instance.getIconWithCallback(this._champion.skinName,this.onChampionIconLoaded);
            this.setTooltip();
         }
      }
      
      private function setChampion(param1:Champion) : void
      {
         if(param1 == this._champion)
         {
            return;
         }
         if(this._champion != null)
         {
            this._champion.getChampionPropertiesChanged().remove(this.onChampionPropertyChanged);
         }
         this._champion = param1;
         if(this._champion != null)
         {
            this._champion.getChampionPropertiesChanged().add(this.onChampionPropertyChanged);
            this.updateChampionProperties();
         }
      }
      
      private function onChampionIconLoaded(param1:BitmapData = null) : void
      {
         if(param1)
         {
            this.image.setBitmapData(param1);
            this.image.setSmoothing(true);
         }
      }
      
      private function setTooltip() : void
      {
         var _loc3_:Array = null;
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:String = this._champion.displayName + " - ";
         if(this._champion.owned)
         {
            _loc2_ += _loc1_.getString("resources","summonerProfile_championsInfo_owned");
         }
         else if(Boolean(this._champion.freeToPlay) || Boolean(this._champion.freeToPlayReward))
         {
            _loc2_ += _loc1_.getString("resources","summonerProfile_championsInfo_freeToPlay");
         }
         else if(this._champion.isRented())
         {
            _loc3_ = [this._champion.rentalDaysRemaining(),this._champion.rentalHoursRemaining(),this._champion.winCountRemaining];
            _loc2_ += _loc1_.getString("resources","summonerProfile_championsInfo_rented",_loc3_);
         }
         else
         {
            _loc2_ += _loc1_.getString("resources","summonerProfile_championsInfo_notOwned");
         }
         assignToolTip(this,_loc2_);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = Number(this.imageSizer.getWidth());
         var _loc4_:Number = Number(this.imageSizer.getHeight());
         this.image.setExplicitSize(_loc3_,_loc4_);
         this.image.setExplicitPosition(this.imageSizer.getX(),this.imageSizer.getY());
         return new Rectangle(0,0,82,96);
      }
      
      protected function selectionHandler(param1:MouseEvent) : void
      {
         SoundProviderProxy.instance.play(AudioKeys.SOUND_CHAMPION_INVENTORY_CHAMP_CLICK);
         this._championDetailProvider.displayChampionDetailView(ChampionDetailContext.SUMMONER_PROFILE,this._champion);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         this.setChampion(param1 as Champion);
      }
   }
}

