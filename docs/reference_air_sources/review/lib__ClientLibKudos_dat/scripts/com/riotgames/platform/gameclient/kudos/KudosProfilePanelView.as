package com.riotgames.platform.gameclient.kudos
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import flash.display.Sprite;
   
   public class KudosProfilePanelView extends SpriteProxy
   {
      
      private var friendlyIcon:SpriteProxy;
      
      private var friendlyTextBackground:MovieClipProxy;
      
      private var teamworkIcon:SpriteProxy;
      
      private var teamworkTextBackground:MovieClipProxy;
      
      public var honorableText:TextFieldProxy;
      
      private var honorableIcon:SpriteProxy;
      
      private var honorableTextBackground:MovieClipProxy;
      
      private var defaultTooltipHandler:ToolTipHandler;
      
      public var helpfulText:TextFieldProxy;
      
      private var helpfulIcon:SpriteProxy;
      
      private var helpfulTextBackground:MovieClipProxy;
      
      public var friendlyText:TextFieldProxy;
      
      public var teamworkText:TextFieldProxy;
      
      public function KudosProfilePanelView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("kudos.KudosProfilePanel");
      }
      
      public function setFriendlyText(param1:String) : void
      {
         this.friendlyText.setText(param1);
      }
      
      public function setHonorableText(param1:String) : void
      {
         this.honorableText.setText(param1);
      }
      
      override protected function createChildren() : void
      {
         this.friendlyText = new TextFieldProxy(this);
         setTimelineChildByName("friendlyText",this.friendlyText);
         this.helpfulText = new TextFieldProxy(this);
         setTimelineChildByName("helpfulText",this.helpfulText);
         this.teamworkText = new TextFieldProxy(this);
         setTimelineChildByName("teamworkText",this.teamworkText);
         this.honorableText = new TextFieldProxy(this);
         setTimelineChildByName("honorableText",this.honorableText);
         this.friendlyTextBackground = new MovieClipProxy(this);
         setTimelineChildByName("friendlyTextBackground",this.friendlyTextBackground);
         this.helpfulTextBackground = new MovieClipProxy(this);
         setTimelineChildByName("helpfulTextBackground",this.helpfulTextBackground);
         this.teamworkTextBackground = new MovieClipProxy(this);
         setTimelineChildByName("teamworkTextBackground",this.teamworkTextBackground);
         this.honorableTextBackground = new MovieClipProxy(this);
         setTimelineChildByName("honorableTextBackground",this.honorableTextBackground);
         this.friendlyIcon = new SpriteProxy(this);
         setTimelineChildByName("friendlyIcon",this.friendlyIcon);
         this.helpfulIcon = new SpriteProxy(this);
         setTimelineChildByName("helpfulIcon",this.helpfulIcon);
         this.teamworkIcon = new SpriteProxy(this);
         setTimelineChildByName("teamworkIcon",this.teamworkIcon);
         this.honorableIcon = new SpriteProxy(this);
         setTimelineChildByName("honorableIcon",this.honorableIcon);
         this.friendlyText.setMouseEnabled(false);
         this.helpfulText.setMouseEnabled(false);
         this.teamworkText.setMouseEnabled(false);
         this.honorableText.setMouseEnabled(false);
         assignToolTip(this.friendlyTextBackground,RiotResourceLoader.getString("kudosEndOfGameFriendlyTooltip"));
         assignToolTip(this.friendlyIcon,RiotResourceLoader.getString("kudosEndOfGameFriendlyTooltip"));
         assignToolTip(this.helpfulTextBackground,RiotResourceLoader.getString("kudosEndOfGameHelpfulTooltip"));
         assignToolTip(this.helpfulIcon,RiotResourceLoader.getString("kudosEndOfGameHelpfulTooltip"));
         assignToolTip(this.teamworkTextBackground,RiotResourceLoader.getString("kudosEndOfGameTeamworkTooltip"));
         assignToolTip(this.teamworkIcon,RiotResourceLoader.getString("kudosEndOfGameTeamworkTooltip"));
         assignToolTip(this.honorableTextBackground,RiotResourceLoader.getString("kudosEndOfGameHonorableTooltip"));
         assignToolTip(this.honorableIcon,RiotResourceLoader.getString("kudosEndOfGameHonorableTooltip"));
         var _loc1_:ToolTip = new ToolTip(this);
         _loc1_.setLinkage("assets.ToolTipAsset");
         this.defaultTooltipHandler.setView(_loc1_);
         this.defaultTooltipHandler.showDelay = 0;
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.defaultTooltipHandler = new ToolTipHandler();
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.showDelay = 0;
         var _loc2_:IToolTipManager = TipsProviderProxy.instance.createWindowToolTipManager(this,_loc1_);
         registerDependency(IToolTipManager,_loc2_);
      }
      
      public function setHelpfulText(param1:String) : void
      {
         this.helpfulText.setText(param1);
      }
      
      public function setTeamworkText(param1:String) : void
      {
         this.teamworkText.setText(param1);
      }
   }
}

