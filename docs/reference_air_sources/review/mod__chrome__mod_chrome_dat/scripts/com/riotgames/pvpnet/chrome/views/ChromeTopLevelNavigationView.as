package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.pvpnet.chrome.ChromeController;
   import com.riotgames.pvpnet.component.ScalingButtonX;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import mx.resources.ResourceManager;
   
   public class ChromeTopLevelNavigationView extends SpriteProxy
   {
      
      private var _buttonStore:ScalingButtonX;
      
      private var _buttonProfile:ScalingButtonX;
      
      private var _buttonLore:ScalingButtonX;
      
      private var _buttonReplays:ScalingButtonX;
      
      private var _buttonHelp:ScalingButtonX;
      
      private var _sizer:SpriteProxy;
      
      private var _clientConfig:ClientConfig;
      
      public function ChromeTopLevelNavigationView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this._clientConfig = ClientConfig.instance;
         this._buttonStore = new ScalingButtonX(this,null,AudioKeys.SOUND_STORE_BUTTON_CLICK);
         setTimelineChildByName("buttonStore",this._buttonStore);
         this._buttonStore.addEventListener(MouseEvent.CLICK,this.onClickStore,false,0,true);
         this._clientConfig.getStoreEnabledChanged().add(this.onStoreEnabledChanged);
         this.updateStoreEnabled();
         this._buttonProfile = new ScalingButtonX(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         setTimelineChildByName("buttonProfile",this._buttonProfile);
         this._buttonProfile.addEventListener(MouseEvent.CLICK,this.onClickProfile,false,0,true);
         assignToolTip(this._buttonProfile,ResourceManager.getInstance().getString("resources","navigator_summonerProfile_tooltip"));
         this._buttonLore = new ScalingButtonX(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         setTimelineChildByName("buttonLore",this._buttonLore);
         this._buttonLore.addEventListener(MouseEvent.CLICK,this.onClickLore,false,0,true);
         this._buttonLore.setVisible(false);
         assignToolTip(this._buttonLore,ResourceManager.getInstance().getString("resources","navigator_story_tooltip"));
         this._buttonReplays = new ScalingButtonX(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         setTimelineChildByName("buttonReplays",this._buttonReplays);
         this._buttonReplays.addEventListener(MouseEvent.CLICK,this.onClickReplays,false,0,true);
         this._clientConfig.getReplaySystemStatesChanged().add(this.onReplaySystemStatesChanged);
         this.onReplaySystemStatesChanged();
         assignToolTip(this._buttonReplays,ResourceManager.getInstance().getString("resources","navigator_replay_tooltip"));
         this._buttonHelp = new ScalingButtonX(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         setTimelineChildByName("buttonHelp",this._buttonHelp);
         this._buttonHelp.addEventListener(MouseEvent.CLICK,this.onClickHelp,false,0,true);
         assignToolTip(this._buttonHelp,ResourceManager.getInstance().getString("resources","helpOverlay_openButton_tooltip"));
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         super.createChildren();
      }
      
      private function onReplaySystemStatesChanged() : void
      {
         this.setReplayButtonIsVisible(this._clientConfig.replaySystemStates.replayServiceEnabled);
      }
      
      public function setReplayButtonIsVisible(param1:Boolean) : void
      {
         this._buttonReplays.setVisible(param1);
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc5_:ScalingButtonX = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Vector.<ScalingButtonX> = new Vector.<ScalingButtonX>();
         _loc3_.push(this._buttonStore,this._buttonProfile,this._buttonLore,this._buttonReplays,this._buttonHelp);
         var _loc4_:uint = 0;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.getVisible())
            {
               _loc4_++;
            }
         }
         _loc6_ = 0;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.getVisible())
            {
               _loc7_ = Number(_loc5_.getWidth());
               _loc5_.setExplicitSize(Math.round(_loc7_ + _loc6_) - _loc6_,NaN);
               _loc5_.setExplicitPosition(Math.round(_loc6_),NaN);
               _loc6_ += _loc7_;
            }
         }
         return new Rectangle(0,0,this._sizer.getWidth(),this._sizer.getHeight());
      }
      
      private function get controller() : ChromeController
      {
         return getDependency(ChromeController);
      }
      
      private function onClickStore(param1:MouseEvent) : void
      {
         this.controller.navigateToStore();
      }
      
      private function onClickProfile(param1:MouseEvent) : void
      {
         this.controller.navigateToProfile();
      }
      
      private function onClickLore(param1:MouseEvent) : void
      {
         this.controller.navigateToLore();
      }
      
      private function onClickReplays(param1:MouseEvent) : void
      {
         this.controller.navigateToReplays();
      }
      
      private function onClickHelp(param1:MouseEvent) : void
      {
         this.controller.openHelpDialog();
      }
      
      private function onStoreEnabledChanged(param1:Boolean, param2:Boolean) : void
      {
         this.updateStoreEnabled();
      }
      
      private function updateStoreEnabled() : void
      {
         if(this._clientConfig.storeEnabled)
         {
            this._buttonStore.setEnabled(true);
            assignToolTip(this._buttonStore,ResourceManager.getInstance().getString("resources","navigator_store_tooltip"));
         }
         else
         {
            this._buttonStore.setEnabled(false);
            this._buttonStore.setMouseEnabled(true);
            assignToolTip(this._buttonStore,ResourceManager.getInstance().getString("resources","store_unavailable_message"));
         }
      }
      
      public function getButtonHorizontalCenterByAlertLocation(param1:String) : int
      {
         switch(param1)
         {
            case AlertLocation.STORE_BUTTON:
               return this.getButtonHorizontalCenter(this._buttonStore);
            case AlertLocation.PROFILE_BUTTON:
               return this.getButtonHorizontalCenter(this._buttonProfile);
            case AlertLocation.WATCH_BUTTON:
               return this.getButtonHorizontalCenter(this._buttonReplays);
            case AlertLocation.JOURNAL_OF_JUSTICE_BUTTON:
               return this.getButtonHorizontalCenter(this._buttonLore);
            default:
               return 0;
         }
      }
      
      private function getButtonHorizontalCenter(param1:SpriteProxy) : int
      {
         if(!param1.getAsset())
         {
            return -1;
         }
         var _loc2_:Matrix = param1.getTransform().concatenatedMatrix;
         var _loc3_:Number = param1.getWidth() / 2;
         return _loc3_ + _loc2_.tx / _loc2_.a;
      }
   }
}

