package com.riotgames.pvpnet.CLS.views
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.ToolTipManager;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.avatarview.AvatarView;
   import com.riotgames.pvpnet.CLS.views.leagueFAQView.ShowLeagueFAQPopupAction;
   import com.riotgames.pvpnet.CLS.views.noleagues.NoLeaguesView;
   import com.riotgames.pvpnet.CLS.views.popupmenuview.PopUpMenuView;
   import com.riotgames.pvpnet.CLS.views.promotionseries.PromotionSeriesView;
   import com.riotgames.pvpnet.CLS.views.rankingview.RankingView;
   import com.riotgames.pvpnet.CLS.views.seemorestatsview.SeeMoreStatsView;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.yourrankedstats.YourRankedStatsView;
   import com.riotgames.rust.context.popup.IPopupContext;
   import com.riotgames.rust.context.popup.SimplePopupContextBehavior;
   import flash.events.MouseEvent;
   
   public class LeagueSystemMainView extends SpriteProxy implements IPopupContext
   {
      
      private var _avatarView:AvatarView;
      
      private var _seeMoreStatsView:SeeMoreStatsView;
      
      private var _noLeaguesView:NoLeaguesView;
      
      private var _noLeaguesViewContainer:SpriteProxy;
      
      private var _popUpMenuView:PopUpMenuView;
      
      private var _yourRankStats:YourRankedStatsView;
      
      private var _rankingView:RankingView;
      
      private var _promotionSeriesView:PromotionSeriesView;
      
      private var _popupBehavior:SimplePopupContextBehavior;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _defaultToolTipHandler:EmblemsToolTipHandler;
      
      private var _showLeagueFAQPopupAction:ShowLeagueFAQPopupAction = new ShowLeagueFAQPopupAction();
      
      private var _currentRankRowSelection:ListItemObjectModel;
      
      public function LeagueSystemMainView(param1:IContext)
      {
         super(param1);
         setLinkage("Main");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._popupBehavior = new SimplePopupContextBehavior(this);
         this._noLeaguesViewContainer = new SpriteProxy(this);
         setTimelineChildByName("noLeaguesContainer",this._noLeaguesViewContainer);
         this._noLeaguesView = new NoLeaguesView(this,this._showLeagueFAQPopupAction);
         this._noLeaguesViewContainer.addChild(this._noLeaguesView);
         this._noLeaguesView.setVisible(false);
         this._avatarView = new AvatarView(this);
         setTimelineChildByName("summonerAvatarContainer",this._avatarView);
         this._seeMoreStatsView = new SeeMoreStatsView(this);
         setTimelineChildByName("seeMoreStatsScreen",this._seeMoreStatsView);
         this._seeMoreStatsView.setVisible(false);
         this._popUpMenuView = new PopUpMenuView(this);
         setTimelineChildByName("popUpMenu",this._popUpMenuView);
         this._yourRankStats = new YourRankedStatsView(this);
         setTimelineChildByName("rankedStatsBoard",this._yourRankStats);
         this._rankingView = new RankingView(this);
         setTimelineChildByName("rankingContainer",this._rankingView);
         this._promotionSeriesView = new PromotionSeriesView(this);
         setTimelineChildByName("promotionSeriesContainer",this._promotionSeriesView);
         var _loc1_:ButtonX = new ButtonX(this);
         setTimelineChildByName("moreAboutLeaguesSystemButton",_loc1_);
         _loc1_.addEventListener(MouseEvent.CLICK,this.onMoreLeagueInfoButtonClick);
         var _loc2_:TextFieldProxy = new TextFieldProxy(this);
         _loc1_.setTimelineChildByName("textField",_loc2_);
         var _loc3_:ILocaleHelper = getDependency(ILocaleHelper);
         _loc2_.setHtmlText("<u>" + _loc3_.localeLookup("msMoreAbout") + "</u>");
         var _loc4_:ToolTip = new ToolTip(this);
         _loc4_.setLinkage("assets.ToolTipAsset");
         this._defaultToolTipHandler.setView(_loc4_);
         this._leagueSystemModuleNavigation.getOnLeagueSelectionUpdateSignal().add(this.onUpdateLeagueChange);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionUpdateSignal().add(this.onUpdateChallengerTierList);
         this._leagueSystemModuleNavigation.getOnRankRowSelectedUpdateSignal().add(this.onRankRowSelected);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._defaultToolTipHandler = new EmblemsToolTipHandler();
         var _loc1_:ToolTipManager = new ToolTipManager(this,this._defaultToolTipHandler);
         registerDependency(IToolTipManager,_loc1_);
      }
      
      private function onUpdateChallengerTierList(param1:Vector.<ListItemObjectModel>) : void
      {
         this._currentRankRowSelection = null;
         invalidateLayout();
      }
      
      private function onUpdateLeagueChange(param1:SummonerLeagueObjectModel) : void
      {
         this._currentRankRowSelection = null;
         invalidateLayout();
      }
      
      private function onRankRowSelected(param1:ListItemObjectModel, param2:Boolean) : void
      {
         this._currentRankRowSelection = param1;
      }
      
      public function addPopup(param1:IDisplayChild) : void
      {
         this._popupBehavior.addPopup(param1);
      }
      
      public function removePopup(param1:IDisplayChild) : void
      {
         this._popupBehavior.removePopup(param1);
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:int, param4:int) : void
      {
         this._popupBehavior.setPosition(param1,param2,param3,param4);
      }
      
      private function onMoreLeagueInfoButtonClick(param1:MouseEvent) : void
      {
         this._showLeagueFAQPopupAction.add(this);
      }
   }
}

