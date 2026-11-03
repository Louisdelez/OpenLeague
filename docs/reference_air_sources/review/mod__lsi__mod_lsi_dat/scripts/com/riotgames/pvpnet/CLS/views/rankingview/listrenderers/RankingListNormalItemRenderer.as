package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.LeaguePositionVariation;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemAvatar;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemChallengerData;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemDivisionData;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemEmblems;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemFriend;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemMiniSeriesGames;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.ListItemPlayerOrTeamName;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RankingListNormalItemRenderer extends ButtonX
   {
      
      private static const TOOLTIP_OFFSET_X:uint = 90;
      
      private static const TOOLTIP_OFFSET_Y:uint = 250;
      
      private static const FRIEND_ICON_PADDING_L:uint = 140;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _listItemObjectModel:ListItemObjectModel;
      
      private var _listItemAvatar:ListItemAvatar;
      
      private var _listItemPosLabel:TextFieldProxy;
      
      private var _leaguePositionVariation:LeaguePositionVariation;
      
      private var _playerOrTeamName:ListItemPlayerOrTeamName;
      
      private var _emblems:ListItemEmblems;
      
      private var _divisionData:ListItemDivisionData;
      
      private var _friendIcon:ListItemFriend;
      
      private var _listItemMiniSeriesGames:ListItemMiniSeriesGames;
      
      private var _oddStripe:SpriteProxy;
      
      private var _challengerData:ListItemChallengerData;
      
      private var _spectatableIcon:SpriteProxy;
      
      private var _localeHelper:ILocaleHelper;
      
      public function RankingListNormalItemRenderer(param1:IContext, param2:String)
      {
         super(param1);
         setLinkage(param2);
         setMouseChildren(true);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this._listItemPosLabel = new TextFieldProxy(this);
         setTimelineChildByName("listItemPosLabel",this._listItemPosLabel);
         this._listItemPosLabel.setMouseEnabled(false);
         this._leaguePositionVariation = new LeaguePositionVariation(this);
         setTimelineChildByName("leaguePositionVariation",this._leaguePositionVariation);
         this._listItemAvatar = new ListItemAvatar(this);
         setTimelineChildByName("avatarContainer",this._listItemAvatar);
         this._playerOrTeamName = new ListItemPlayerOrTeamName(this);
         setTimelineChildByName("playerOrTeamName",this._playerOrTeamName);
         this._friendIcon = new ListItemFriend(this);
         setTimelineChildByName("friendIcon",this._friendIcon);
         this._emblems = new ListItemEmblems(this);
         setTimelineChildByName("emblems",this._emblems);
         this._divisionData = new ListItemDivisionData(this);
         setTimelineChildByName("divisionData",this._divisionData);
         this._challengerData = new ListItemChallengerData(this);
         setTimelineChildByName("challengerData",this._challengerData);
         this._listItemMiniSeriesGames = new ListItemMiniSeriesGames(this);
         setTimelineChildByName("listItemMiniSeriesGames",this._listItemMiniSeriesGames);
         this._oddStripe = new SpriteProxy(this);
         setTimelineChildByName("oddStripe",this._oddStripe);
         this._spectatableIcon = new SpriteProxy(this);
         setTimelineChildByName("spectateIcon",this._spectatableIcon);
         this._spectatableIcon.setMouseEnabled(false);
         this._spectatableIcon.setMouseChildren(false);
         this._spectatableIcon.setVisible(false);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.RIGHT_CLICK,this.onRightMouseClick);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getCurrentSelectedRowIdUpdate().add(this.onGetCurrentSelectedRowIdUpdate);
         this._leagueSystemModuleNavigation.getOnRankRowSelectedUpdateSignal().add(this.onGetOnRankRowSelectedUpdateSignal);
      }
      
      override public function setData(param1:*) : void
      {
         setSelected(false);
         setMouseIsOver(false);
         refreshState();
         this._leagueSystemModuleNavigation.dispatchAskCurrentSelectedRowId();
         this._listItemObjectModel = param1 as ListItemObjectModel;
         if(this._listItemObjectModel.isInactive && !this._listItemObjectModel.tier.isApex())
         {
            this._listItemPosLabel.setText("");
         }
         else
         {
            this._listItemPosLabel.setText(this._listItemObjectModel.position.toString());
         }
         this._leaguePositionVariation.updateLeaguePosition(this._listItemObjectModel);
         this._listItemAvatar.setAvatar(this._listItemObjectModel);
         this._playerOrTeamName.setPlayerOrTeamName(this._listItemObjectModel);
         this._friendIcon.setFriend(this._listItemObjectModel);
         this._friendIcon.setX(this._playerOrTeamName.playerNameLabel.getTextWidth() + FRIEND_ICON_PADDING_L);
         this._emblems.setEmblems(this._listItemObjectModel.emblems);
         this._divisionData.updateData(this._listItemObjectModel);
         this._challengerData.updateData(this._listItemObjectModel);
         this._listItemMiniSeriesGames.updateRenderedData = this._listItemObjectModel;
         this._oddStripe.setVisible((this._listItemObjectModel.position - 1) % 2 != 0);
         this._spectatableIcon.setVisible(this._listItemObjectModel.isSpectatable);
         this._listItemObjectModel.getIsSpectatableChanged().add(this.onIsSpectatableChanged);
      }
      
      private function onIsSpectatableChanged() : void
      {
         this._spectatableIcon.setVisible(this._listItemObjectModel.isSpectatable);
      }
      
      override public function destroy() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         removeEventListener(MouseEvent.RIGHT_CLICK,this.onRightMouseClick);
         super.destroy();
      }
      
      override protected function addedToStageHandler(param1:Event) : void
      {
         super.addedToStageHandler(param1);
         rollOutHandler(null);
      }
      
      private function _setCurrentlySelected() : void
      {
         var _loc1_:uint = 0;
         if(!this.getSelected())
         {
            _loc1_ = this._listItemObjectModel.position - 1 >= 0 ? uint(this._listItemObjectModel.position - 1) : 0;
            this._leagueSystemModuleNavigation.dispatchOnRankRowSelected(_loc1_,this._listItemObjectModel);
         }
      }
      
      private function onGetCurrentSelectedRowIdUpdate(param1:int) : void
      {
         var _loc2_:Boolean = this._listItemObjectModel != null && this._listItemObjectModel.position - 1 == param1;
         setSelected(_loc2_);
      }
      
      private function onGetOnRankRowSelectedUpdateSignal(param1:ListItemObjectModel, param2:Boolean) : void
      {
         setSelected(param1 == this._listItemObjectModel);
      }
      
      private function onRightMouseClick(param1:MouseEvent) : void
      {
         if(this._listItemObjectModel != null)
         {
            this._leagueSystemModuleNavigation.dispatchOnRankRowClear();
            this._leagueSystemModuleNavigation.dispatchOnPopUpMenuView(this.getStage().mouseX - TOOLTIP_OFFSET_X,this.getStage().mouseY - TOOLTIP_OFFSET_Y,this._listItemObjectModel.name,this._listItemObjectModel.playerOrTeamId,this._listItemObjectModel.isTeam,this._listItemObjectModel.isSpectatable,this._listItemObjectModel.tier);
            this._setCurrentlySelected();
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         if(this._listItemObjectModel != null)
         {
            this._leagueSystemModuleNavigation.dispatchOnRankRowClear();
            this._setCurrentlySelected();
         }
      }
   }
}

