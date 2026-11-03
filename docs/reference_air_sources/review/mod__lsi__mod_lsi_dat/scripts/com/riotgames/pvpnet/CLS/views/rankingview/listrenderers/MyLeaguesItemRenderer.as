package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components.LeaguePositionVariation;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.rust.components.list.List;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MyLeaguesItemRenderer extends StatefulView implements IDataRenderer
   {
      
      private var _data:SummonerLeagueObjectModel;
      
      private var tierBadge:StatefulView;
      
      private var badge:StatefulView;
      
      private var listItemPosLabel:TextFieldProxy;
      
      private var leaguePositionVariation:LeaguePositionVariation;
      
      private var tierName:TextFieldProxy;
      
      private var tierDetails:TextFieldProxy;
      
      private var pointsLabel:TextFieldProxy;
      
      private var button:ButtonX;
      
      private var buttonToTeam:ButtonX;
      
      private var _teamId:TeamId;
      
      private var _isProvisional:Boolean = false;
      
      private var _localeHelper:ILocaleHelper;
      
      private var rankedTeamProvider:IRankedTeamsProvider;
      
      public function MyLeaguesItemRenderer(param1:IContext)
      {
         super(param1);
         ProviderLookup.getProvider(IRankedTeamsProvider,this.onRankedTeamsProviderAvailable);
      }
      
      private function onRankedTeamsProviderAvailable(param1:IRankedTeamsProvider) : void
      {
         this.rankedTeamProvider = param1;
         this.refreshButtonToTeam(this._data);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this.tierBadge = new StatefulView(this);
         this.tierBadge.setMouseEnabled(false);
         this.tierBadge.setVisible(false);
         setTimelineChildByName("tierBadge",this.tierBadge);
         this.badge = new StatefulView(this);
         this.tierBadge.setTimelineChildByName("badge",this.badge);
         this.listItemPosLabel = new TextFieldProxy(this);
         setTimelineChildByName("listItemPosLabel",this.listItemPosLabel);
         this.listItemPosLabel.setMouseEnabled(false);
         this.leaguePositionVariation = new LeaguePositionVariation(this);
         setTimelineChildByName("leaguePositionVariation",this.leaguePositionVariation);
         this.leaguePositionVariation.setMouseEnabled(false);
         this.leaguePositionVariation.setMouseChildren(false);
         this.tierName = new TextFieldProxy(this);
         this.tierName.setText("");
         this.tierName.setMouseEnabled(false);
         setTimelineChildByName("tierName",this.tierName);
         this.tierDetails = new TextFieldProxy(this);
         this.tierDetails.setText("");
         this.tierDetails.setMouseEnabled(false);
         setTimelineChildByName("tierDetails",this.tierDetails);
         this.pointsLabel = new TextFieldProxy(this);
         setTimelineChildByName("pointsLabel",this.pointsLabel);
         this.pointsLabel.setMouseEnabled(false);
         this.button = new ButtonX(this);
         this.button.setHitArea(this);
         this.button.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         setTimelineChildByName("button",this.button);
         this.buttonToTeam = new ButtonX(this);
         this.buttonToTeam.setVisible(false);
         this.buttonToTeam.setHitArea(this.buttonToTeam);
         this.buttonToTeam.addEventListener(MouseEvent.CLICK,this.onButtonToTeamClick);
         assignToolTip(this.buttonToTeam,this._localeHelper.localeLookup("mlButtonToTeamTooltip"));
         setTimelineChildByName("buttonToTeam",this.buttonToTeam);
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         this._data = param1 as SummonerLeagueObjectModel;
         if(this._data)
         {
            this._isProvisional = this._data.tier == LeagueTier.PROVISIONAL;
            _loc2_ = List(getParentContext()).data;
            _loc3_ = _loc2_[_loc2_.length - 1];
            setCurrentState(param1 == _loc3_ ? "listEnd" : "listMiddle");
         }
         this.refreshButtonToTeam(this._data);
         this.updateView();
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      private function updateView() : void
      {
         if(this._data == null)
         {
            this.tierBadge.setVisible(false);
            this.tierName.setText("");
            this.tierDetails.setText("");
            return;
         }
         var _loc1_:ListItemObjectModel = this._data.elements.myRank;
         this.tierBadge.setVisible(true);
         this.badge.setCurrentState(this._data.rank.value());
         this.tierName.setText(this._data.teamName);
         if(_loc1_.isInactive && !_loc1_.tier.isApex())
         {
            this.listItemPosLabel.setText("");
         }
         else
         {
            this.listItemPosLabel.setText(_loc1_.position.toString());
         }
         this.leaguePositionVariation.updateLeaguePosition(_loc1_);
         this.pointsLabel.setText(_loc1_.points.toString() + this._localeHelper.localeLookup("mlLeaguePointsAbbr"));
         if(this._isProvisional)
         {
            this.tierBadge.setCurrentState(LeagueTier.PROVISIONAL.value());
            this.button.setEnabled(false);
            this.tierDetails.setText(this._localeHelper.localeLookup(LeagueTier.PROVISIONAL.value()));
            this.listItemPosLabel.setVisible(false);
            this.leaguePositionVariation.setVisible(false);
            this.pointsLabel.setVisible(false);
         }
         else if(this._data.tier)
         {
            this.tierBadge.setCurrentState(this._data.tier.value());
            this.button.setEnabled(true);
            this.tierDetails.setText(this._localeHelper.localeLookup(this._data.tier.value()) + " " + this._data.rank.value());
            if(this._data.queueType != QueueTypesEnum.QUEUE_TYPE_SOLO)
            {
               this.tierDetails.appendText(" " + this._localeHelper.localeLookup(_loc1_.queueLabel));
            }
            this.listItemPosLabel.setVisible(true);
            this.leaguePositionVariation.setVisible(true);
            this.pointsLabel.setVisible(true);
         }
         else
         {
            this.tierBadge.setCurrentState(LeagueTier.PROVISIONAL.value());
            this.button.setEnabled(false);
            this.tierDetails.setText("");
            this.listItemPosLabel.setVisible(false);
            this.leaguePositionVariation.setVisible(false);
            this.pointsLabel.setVisible(false);
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:ILeagueSystemModuleNavigation = null;
         if(this._data != null)
         {
            _loc2_ = getDependency(ILeagueSystemModuleNavigation);
            _loc2_.dispatchOnLeagueSelectionSignal(this._data.id);
         }
      }
      
      private function onButtonToTeamClick(param1:MouseEvent) : void
      {
         var _loc2_:TeamId = this._teamId;
         if(_loc2_)
         {
            this.rankedTeamProvider.gotoTeamProfile(_loc2_);
         }
      }
      
      private function refreshButtonToTeam(param1:SummonerLeagueObjectModel) : void
      {
         var _loc2_:TeamId = null;
         if(Boolean(this.rankedTeamProvider) && Boolean(param1))
         {
            _loc2_ = this.lookupTeamId(param1);
            if(_loc2_)
            {
               this._teamId = _loc2_;
               this.buttonToTeam.setVisible(true);
               return;
            }
         }
         this._teamId = null;
         this.buttonToTeam.setVisible(false);
      }
      
      private function lookupTeamId(param1:SummonerLeagueObjectModel) : TeamId
      {
         var results:Vector.<ListItemObjectModel> = null;
         var data:SummonerLeagueObjectModel = param1;
         if(data.elements)
         {
            results = data.elements.allRankListElements.filter(function(param1:ListItemObjectModel, param2:int, param3:Vector.<ListItemObjectModel>):Boolean
            {
               return param1.isTeam && param1.teamName === data.teamName;
            });
            if(results.length > 0)
            {
               return TeamId.MakeTeamId(results[0].playerOrTeamId);
            }
         }
         return null;
      }
      
      override public function getExplicitSize() : Point
      {
         var _loc1_:Point = super.getExplicitSize();
         _loc1_.y = 45;
         return _loc1_;
      }
   }
}

