package com.riotgames.newplayerlanding.views.carousel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import com.riotgames.newplayerlanding.metrics.NPLPTracker;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class CommunityPage extends SpriteProxy
   {
      
      private var _header:NPLPHeader;
      
      private var _likeUsText:TextFieldProxy;
      
      private var _likeUsDescription:TextFieldProxy;
      
      private var _likeUsButton:LabelButtonX;
      
      private var _subscribeText:TextFieldProxy;
      
      private var _subscribeDescription:TextFieldProxy;
      
      private var _subscribeButton:LabelButtonX;
      
      private var _statTracker:NPLPTracker;
      
      public function CommunityPage(param1:IContext, param2:NPLPTracker)
      {
         super(param1);
         this._statTracker = param2;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._header = new NPLPHeader(this);
         setTimelineChildByName("header",this._header);
         this._header.setTextFromKeys("nplp.community.heading","nplp.community.subheading");
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this._likeUsText = new TextFieldProxy(this);
         setTimelineChildByName("facebookTitle.template.mask.text",this._likeUsText);
         this._likeUsText.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.community.facebooktitle"));
         this._likeUsDescription = new TextFieldProxy(this);
         setTimelineChildByName("facebookDescription.innerText",this._likeUsDescription);
         this._likeUsDescription.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.community.facebookdescription"));
         this._likeUsButton = new LabelButtonX(this);
         this._likeUsButton.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.community.facebookbuttontext"));
         setTimelineChildByName("facebookButton",this._likeUsButton);
         this._likeUsButton.addEventListener(MouseEvent.CLICK,this.onLikeUs);
         this._subscribeText = new TextFieldProxy(this);
         setTimelineChildByName("youtubeTitle.template.mask.text",this._subscribeText);
         this._subscribeText.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.community.youtubetitle"));
         this._subscribeDescription = new TextFieldProxy(this);
         setTimelineChildByName("youtubeDescription.innerText",this._subscribeDescription);
         this._subscribeDescription.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.community.youtubedescription"));
         this._subscribeButton = new LabelButtonX(this);
         this._subscribeButton.setText(_loc1_.getString(NewPlayerLandingConfig.LOCALIZATION_NAMESPACE,"nplp.community.youtubebuttontext"));
         setTimelineChildByName("youtubeButton",this._subscribeButton);
         this._subscribeButton.addEventListener(MouseEvent.CLICK,this.onSubscribe);
      }
      
      private function onLikeUs(param1:MouseEvent) : void
      {
         var _loc3_:URLRequest = null;
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(NewPlayerLandingConfig.NAMESPACE,NewPlayerLandingConfig.LIKE_US_URL,"");
         if(_loc2_.getString().length > 0)
         {
            _loc3_ = new URLRequest(_loc2_.getString());
            navigateToURL(_loc3_);
         }
         if(this._statTracker)
         {
            this._statTracker.onLike();
         }
      }
      
      private function onSubscribe(param1:MouseEvent) : void
      {
         var _loc3_:URLRequest = null;
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(NewPlayerLandingConfig.NAMESPACE,NewPlayerLandingConfig.SUBSCRIBE_URL,"");
         if(_loc2_.getString().length > 0)
         {
            _loc3_ = new URLRequest(_loc2_.getString());
            navigateToURL(_loc3_);
         }
         if(this._statTracker)
         {
            this._statTracker.onSubscribe();
         }
      }
   }
}

