package com.riotgames.pvpnet.CLS.views.promotionCeremony
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.leagues.LeagueUpdateItem;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class PromotionCeremonyPopup extends StatefulView
   {
      
      private static const UNRANKED:String = "UNRANKED";
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var titleText:TextFieldProxy;
      
      private var bodyText:TextFieldProxy;
      
      private var closeButton:LabelButtonX;
      
      private var videoClipContainer:MovieClipProxy;
      
      private var leagueName:String;
      
      private var playerOrTeamName:String;
      
      private var queueType:String;
      
      private var tier:LeagueTier;
      
      private var rank:LeagueRank;
      
      public function PromotionCeremonyPopup(param1:IContext, param2:Boolean, param3:LeagueUpdateItem)
      {
         this.leagueName = param3.leagueName;
         this.playerOrTeamName = param3.playerOrTeamName;
         this.queueType = param3.queueType;
         this.tier = LeagueTier.valueOf(param3.tier);
         this.rank = LeagueRank.valueOf(param3.rank);
         super(param1,null);
         getAssetChanged().add(this.onAssetChanged);
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         if(param2)
         {
            switch(this.tier)
            {
               case LeagueTier.SILVER:
                  setLinkage(LeagueTier.BRONZE.value() + "_" + LeagueTier.SILVER.value());
                  break;
               case LeagueTier.GOLD:
                  setLinkage(LeagueTier.SILVER.value() + "_" + LeagueTier.GOLD.value());
                  break;
               case LeagueTier.PLATINUM:
                  setLinkage(LeagueTier.GOLD.value() + "_" + LeagueTier.PLATINUM.value());
                  break;
               case LeagueTier.DIAMOND:
                  setLinkage(LeagueTier.PLATINUM.value() + "_" + LeagueTier.DIAMOND.value());
                  break;
               case LeagueTier.MASTER:
                  setLinkage(LeagueTier.DIAMOND.value() + "_" + LeagueTier.MASTER.value());
                  break;
               case LeagueTier.CHALLENGER:
                  if(LeagueConfig.isMasterTierEnabled())
                  {
                     setLinkage(LeagueTier.MASTER.value() + "_" + LeagueTier.CHALLENGER.value());
                  }
                  else
                  {
                     setLinkage(LeagueTier.DIAMOND.value() + "_" + LeagueTier.CHALLENGER.value());
                  }
                  break;
               default:
                  this.logger.error("Unknown promotion tier received!: " + this.tier.value());
            }
         }
         else
         {
            switch(this.tier)
            {
               case LeagueTier.BRONZE:
                  setLinkage(UNRANKED + "_" + LeagueTier.BRONZE.value());
                  break;
               case LeagueTier.SILVER:
                  setLinkage(UNRANKED + "_" + LeagueTier.SILVER.value());
                  break;
               case LeagueTier.GOLD:
                  setLinkage(UNRANKED + "_" + LeagueTier.GOLD.value());
                  break;
               case LeagueTier.PLATINUM:
                  setLinkage(LeagueTier.GOLD.value() + "_" + LeagueTier.PLATINUM.value());
                  break;
               case LeagueTier.DIAMOND:
                  setLinkage(LeagueTier.PLATINUM.value() + "_" + LeagueTier.DIAMOND.value());
                  break;
               default:
                  this.logger.error("Unkown seeding tier received!: " + this.tier.value());
            }
         }
         setCurrentState("default");
         setCurrentState("intro");
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:String = null;
         this.titleText = new TextFieldProxy(this);
         setTimelineChildByName("messageBox.titleText",this.titleText);
         this.titleText.setText(RiotResourceLoader.getString("league_ceremonyPromoTitle"));
         this.bodyText = new TextFieldProxy(this);
         setTimelineChildByName("messageBox.bodyText",this.bodyText);
         if(this.tier == LeagueTier.CHALLENGER)
         {
            _loc1_ = RiotResourceLoader.getString("league_ceremonyPromoBody_" + this.queueType + "_Challenger",null,[this.playerOrTeamName]);
         }
         else if(this.tier == LeagueTier.MASTER)
         {
            _loc1_ = RiotResourceLoader.getString("league_ceremonyPromoBody_" + this.queueType + "_Master",null,[this.playerOrTeamName]);
         }
         else
         {
            _loc1_ = RiotResourceLoader.getString("league_ceremonyPromoBody_" + this.queueType,null,[this.leagueName,RiotResourceLoader.getString("leagues_rank_" + this.tier.value(),this.tier.value()),RiotResourceLoader.getString("leagues_tier_" + this.rank.value(),this.rank.value()),this.playerOrTeamName]);
         }
         this.bodyText.setText(_loc1_);
         this.closeButton = new LabelButtonX(this);
         setTimelineChildByName("messageBox.closeButton",this.closeButton);
         this.closeButton.setText(RiotResourceLoader.getString("common_button_ok"));
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this.videoClipContainer = new MovieClipProxy(this);
         this.videoClipContainer.play();
         setTimelineChildByName("videoContainer",this.videoClipContainer);
         this.videoClipContainer.setMouseEnabled(false);
         this.videoClipContainer.setMouseChildren(false);
      }
      
      private function onAssetChanged() : void
      {
         var _loc1_:MovieClip = getAsset() as MovieClip;
         if(_loc1_)
         {
            SoundProviderProxy.instance.applyVolumeToMovieClip(_loc1_);
         }
      }
      
      private function onCloseButtonClicked(param1:MouseEvent) : void
      {
         PopUpManager.removePopUp(this);
      }
   }
}

