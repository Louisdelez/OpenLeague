package com.riotgames.pvpnet.chat
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.chat.utils.RiotPresence;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.IConfigurationRegistry;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.data.Presence;
   
   public class ChatBuddyTooltipView extends StatefulView implements IDataRenderer
   {
      
      private static const ORANGE:String = "#ee9501";
      
      private static const WHITE:String = "#ffffff";
      
      private static const BUDDY_LEAGUE_COLOR:String = ORANGE;
      
      private static const BUDDY_STATUS_COLOR:String = ORANGE;
      
      private static const BUDDY_LEVEL_AND_WINS_COLOR:String = WHITE;
      
      private static const STATE_DEFAULT:String = "default";
      
      private static const STATE_NO_PRESENCE:String = "noPresence";
      
      private var _buddy:Buddy;
      
      private var summonerNameText:Text;
      
      private var descriptionText:Text;
      
      private var background:SpriteProxy;
      
      private var panelTop:SpriteProxy;
      
      private var panelMid:SpriteProxy;
      
      private var panelBot:SpriteProxy;
      
      private var summonerIconBox:SpriteProxy;
      
      private var summonerIcon:BitmapProxy;
      
      private var isMobileEnabled:Boolean;
      
      private var assetSizeDefault:Point;
      
      private var assetSizeNoPresence:Point;
      
      private var textSizeDefault:Point;
      
      private var textSizeNoPresence:Point;
      
      private var backgroundSizeOffset:Point;
      
      public function ChatBuddyTooltipView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("chat.BuddyTooltip");
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         var _loc1_:IConfigurationRegistry = this.getDependency(IConfigurationRegistry);
         var _loc2_:ConfigurationModel = _loc1_.getConfigurationModel(ChatConfig.NAMESPACE,ChatConfig.MOBILE_ENABLED);
         this.isMobileEnabled = _loc2_.getValue();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.summonerNameText = new Text(this);
         setTimelineChildByName("summonerNameText",this.summonerNameText);
         this.descriptionText = new Text(this);
         setTimelineChildByName("descriptionText",this.descriptionText);
         this.background = new SpriteProxy(this);
         setTimelineChildByName("background",this.background);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         this.panelTop = new SpriteProxy(this);
         setTimelineChildByName("panelTop",this.panelTop);
         this.panelTop.setTransformBehavior(new ScalingTransformBehavior());
         this.panelMid = new SpriteProxy(this);
         setTimelineChildByName("panelMid",this.panelMid);
         this.panelMid.setTransformBehavior(new ScalingTransformBehavior());
         this.panelBot = new SpriteProxy(this);
         setTimelineChildByName("panelBot",this.panelBot);
         this.panelBot.setTransformBehavior(new ScalingTransformBehavior());
         this.summonerIconBox = new SpriteProxy(this);
         setTimelineChildByName("iconContainer",this.summonerIconBox);
         this.summonerIcon = new BitmapProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         this.summonerIcon.setTransformBehavior(_loc1_);
         this.summonerIcon.setSmoothing(true);
         addChild(this.summonerIcon);
      }
      
      public function getData() : *
      {
         return this._buddy;
      }
      
      public function setData(param1:*) : void
      {
         if(this._buddy != null)
         {
            this._buddy.getBuddyChanged().remove(this.refreshBuddy);
         }
         this._buddy = param1;
         if(this._buddy != null)
         {
            this._buddy.getBuddyChanged().add(this.refreshBuddy);
            this.refreshBuddy();
         }
      }
      
      private function refreshBuddy() : void
      {
         var _loc2_:BitmapData = null;
         if(this._buddy.getPresence())
         {
            setCurrentState(STATE_DEFAULT);
            _loc2_ = BuddyImages.getSummonerIconSafely(this._buddy.getPresence().profileIconId);
            this.summonerIcon.setBitmapData(_loc2_);
            this.updateAllBuddyDescriptionText();
         }
         else
         {
            setCurrentState(STATE_NO_PRESENCE);
            this.summonerIcon.setBitmapData(null);
            if(this._buddy.getNote())
            {
               this.descriptionText.setHtmlText(this._buddy.getNote().replace(/</g,"&lt;"));
            }
            else
            {
               this.descriptionText.setHtmlText("");
            }
         }
         this.summonerNameText.setText(this._buddy.getName());
         var _loc1_:Number = this.summonerNameText.getTextWidth() + Text.TEXT_WIDTH_PADDING;
         if(_loc1_ > this.summonerNameText.getWidth() + 1e-14)
         {
            this.summonerNameText.setWidth(_loc1_);
         }
         invalidateLayout();
      }
      
      private function updateAllBuddyDescriptionText() : void
      {
         var _loc1_:String = "<font face=\'ApplicationFont2\'>";
         _loc1_ += this.getBuddyStatusText();
         _loc1_ += this.getBuddyLevelText();
         _loc1_ += this.getBuddyWinsText();
         _loc1_ += this.getBuddyLeagueStandingText();
         _loc1_ += this.getBuddyLeagueNameText();
         _loc1_ += this.getBuddyNoteText();
         _loc1_ += this.getBuddyGameStatusText();
         _loc1_ += this.getBuddyGameDetailsText();
         _loc1_ += this.getBuddyGameMinutesElapsedText();
         _loc1_ += "</font>";
         this.descriptionText.setHtmlText(_loc1_);
      }
      
      private function getBuddyLevelText() : String
      {
         return "<font color=\'" + BUDDY_LEVEL_AND_WINS_COLOR + "\'>" + ResourceManager.getInstance().getString("resources","BuddyListTooltip_summonerLevel",[this._buddy.getPresence().level]) + "</font>\n";
      }
      
      private function getBuddyStatusText() : String
      {
         if(this._buddy.getPresence().statusMsg == "")
         {
            return "";
         }
         return "<font color=\'" + BUDDY_STATUS_COLOR + "\'>" + this._buddy.getPresence().statusMsg.substr(0,25).replace(/</g,"&lt;") + "</font>\n\n";
      }
      
      private function getBuddyWinsText() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = int(this._buddy.getPresence().wins);
         var _loc3_:int = int(this._buddy.getPresence().rankedWins);
         if(_loc3_ > 0)
         {
            _loc1_ = RiotResourceLoader.getString("customGame_RankedWins",null,[_loc3_.toString()]);
         }
         else
         {
            if(_loc2_ <= 0)
            {
               return "";
            }
            _loc1_ = RiotResourceLoader.getString("customGame_NormalWins",null,[_loc2_.toString()]);
         }
         return "<font color=\'" + BUDDY_LEVEL_AND_WINS_COLOR + "\'>" + _loc1_ + "</font>\n";
      }
      
      private function getBuddyLeagueStandingText() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(!ClientConfig.instance.leagueServiceEnabled || this._buddy.getPresence().rankedLeagueTier == "")
         {
            return "";
         }
         _loc1_ = "<font color=\'" + BUDDY_LEAGUE_COLOR + "\'>";
         if(this._buddy.getPresence().rankedLeagueTier == "CHALLENGER")
         {
            _loc1_ += RiotResourceLoader.getString("leagues_rank_CHALLENGER_NODIV");
         }
         else
         {
            _loc2_ = RiotResourceLoader.getString("leagues_rank_" + this._buddy.getPresence().rankedLeagueTier);
            _loc1_ += RiotResourceLoader.getString("profile_devision_display","**profile_devision_display",[_loc2_,this._buddy.getPresence().rankedLeagueDivision]);
         }
         return _loc1_ + "</font>\n";
      }
      
      private function getBuddyLeagueNameText() : String
      {
         var _loc1_:String = null;
         if(!ClientConfig.instance.leagueServiceEnabled || this._buddy.getPresence().rankedLeagueTier == "" || this._buddy.getPresence().rankedLeagueName == "")
         {
            return "";
         }
         _loc1_ = "<font color=\'" + BUDDY_LEAGUE_COLOR + "\'>";
         if(this._buddy.getPresence().rankedLeagueTier == "CHALLENGER" || this._buddy.getPresence().rankedLeagueTier == "MASTER")
         {
            _loc1_ += RiotResourceLoader.getString("league_queue_" + this._buddy.getPresence().rankedLeagueQueueType);
         }
         else
         {
            _loc1_ += ServiceProxy.instance.leagueService.cache.parseLeagueName(this._buddy.getPresence().rankedLeagueName);
         }
         return _loc1_ + "</font>\n";
      }
      
      private function getBuddyNoteText() : String
      {
         if(Boolean(this._buddy) && Boolean(this._buddy.getNote()) && this._buddy.getNote() != "")
         {
            return "\n" + this._buddy.getNote().substr(0,140).replace(/</g,"&lt;") + "\n\n";
         }
         return "\n";
      }
      
      private function getBuddyGameStatusText() : String
      {
         var _loc3_:String = null;
         var _loc1_:String = this._buddy.getBusyStatus();
         var _loc2_:PresenceStatusData = this._buddy.getPresence();
         var _loc4_:String = RiotPresence.fromXiffPresence(_loc1_,this.isMobileEnabled).colorHex;
         if(_loc1_ == Presence.SHOW_DND)
         {
            _loc3_ = _loc2_.gameType;
         }
         else if(this.isMobileEnabled && _loc1_ == Presence.SHOW_CHAT_MOBILE)
         {
            _loc3_ = "onMobile";
         }
         else if(_loc1_ == Presence.SHOW_AWAY || _loc1_ == Presence.SHOW_CHAT_MOBILE)
         {
            _loc3_ = Presence.SHOW_AWAY;
         }
         else if(Boolean(_loc2_) && Boolean(PresenceStatusXML.isGameLobbyStatus(_loc2_.gameType)))
         {
            _loc3_ = _loc2_.gameType;
         }
         else
         {
            _loc3_ = "outOfGame";
         }
         return "<font color=\'" + _loc4_ + "\'>" + RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_" + _loc3_,"*" + _loc3_) + "</font>\n";
      }
      
      private function getBuddyGameDetailsText() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this._buddy.getPresence().gameType == PresenceStatusXML.GAME_STATUS_IN_GAME)
         {
            if(this._buddy.getPresence().skinname == Champion.RANDOM_SKIN_NAME)
            {
               _loc1_ = RiotResourceLoader.getString("championSelection_randomChampion_displayName");
            }
            else
            {
               _loc1_ = RiotResourceLoader.getChampionResourceString("name",this._buddy.getPresence().skinname,"");
            }
            _loc2_ = RiotResourceLoader.getString("BuddyListTooltip_inGameInfo",null,[_loc1_]);
            if(_loc2_ == null)
            {
               _loc2_ = RiotResourceLoader.getString("BuddyListTreeRenderer_gameStatus_playingAs") + _loc1_;
            }
            return "<font color=\'" + RiotPresence.DND.colorHex + "\'>" + _loc2_ + "</font>\n";
         }
         return "";
      }
      
      private function getBuddyGameMinutesElapsedText() : String
      {
         var _loc1_:String = null;
         var _loc2_:Date = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(this._buddy.getPresence().gameType == PresenceStatusXML.GAME_STATUS_IN_QUEUE || this._buddy.getPresence().gameType == PresenceStatusXML.GAME_STATUS_IN_GAME)
         {
            _loc1_ = "";
            _loc2_ = new Date();
            _loc3_ = int((_loc2_.time - this._buddy.getPresence().timeStamp) / 60000);
            _loc4_ = _loc3_ < 120 && _loc3_ >= 0;
            if(_loc4_)
            {
               if(_loc3_ == 0)
               {
                  _loc1_ = RiotResourceLoader.getString("BuddyListTooltip_elapsedtime_zero");
               }
               else if(_loc3_ == 1)
               {
                  _loc1_ = RiotResourceLoader.getString("BuddyListTooltip_elapsedtime_singluar");
               }
               else
               {
                  _loc1_ = RiotResourceLoader.getString("BuddyListTooltip_elapsedtime",null,[_loc3_]);
               }
               if(_loc1_ == null)
               {
                  _loc1_ = "**for " + _loc3_.toString() + " minutes.";
               }
               return "<font color=\'" + RiotPresence.DND.colorHex + "\'>" + _loc1_ + "</font>\n";
            }
            return "";
         }
         return "";
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         this.summonerIcon.setExplicitSize(this.summonerIconBox.getWidth(),this.summonerIconBox.getHeight());
         this.summonerIcon.setExplicitPosition(this.summonerIconBox.getX(),this.summonerIconBox.getY());
         if(Boolean(this._buddy) && Boolean(this._buddy.getPresence()))
         {
            _loc3_ = Math.round(this.assetSizeDefault.x + Math.max(this.summonerNameText.getWidth() - this.textSizeDefault.x,0));
            _loc4_ = Math.round(this.assetSizeDefault.y + Math.max(this.descriptionText.getHeight() - this.textSizeDefault.y,0));
         }
         else
         {
            _loc3_ = Math.round(this.assetSizeNoPresence.x + Math.max(this.summonerNameText.getWidth() - this.textSizeNoPresence.x,0));
            _loc4_ = Math.round(this.assetSizeNoPresence.y + Math.max(this.descriptionText.getHeight() - this.textSizeNoPresence.y,0));
         }
         this.background.setWidth(_loc3_ + this.backgroundSizeOffset.x);
         this.background.setHeight(_loc4_ + this.backgroundSizeOffset.y);
         this.panelTop.setWidth(_loc3_);
         this.panelMid.setWidth(_loc3_);
         this.panelBot.setWidth(_loc3_);
         this.panelMid.setHeight(_loc4_ - this.panelTop.getHeight() - this.panelBot.getHeight());
         this.panelBot.setY(this.panelMid.getY() + this.panelMid.getHeight());
         return new Rectangle(0,0,_loc3_,_loc4_);
      }
      
      override public function setAsset(param1:DisplayObject) : void
      {
         super.setAsset(param1);
         var _loc2_:MovieClip = param1 as MovieClip;
         if(_loc2_ != null)
         {
            _loc2_.gotoAndStop(STATE_DEFAULT);
            this.assetSizeDefault = new Point(getWidth(),getHeight());
            this.textSizeDefault = new Point(this.summonerNameText.getWidth(),this.descriptionText.getHeight());
            this.backgroundSizeOffset = new Point(this.background.getWidth(),this.background.getHeight());
            this.backgroundSizeOffset = this.backgroundSizeOffset.subtract(this.assetSizeDefault);
            _loc2_.gotoAndStop(STATE_NO_PRESENCE);
            this.assetSizeNoPresence = new Point(getWidth(),getHeight());
            this.textSizeNoPresence = new Point(this.summonerNameText.getWidth(),this.descriptionText.getHeight());
            _loc2_.gotoAndStop(1);
            this.descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         }
      }
      
      override public function destroy() : void
      {
         this.setData(null);
         super.destroy();
      }
   }
}

