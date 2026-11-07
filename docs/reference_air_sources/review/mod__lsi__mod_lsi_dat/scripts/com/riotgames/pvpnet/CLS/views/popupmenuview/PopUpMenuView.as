package com.riotgames.pvpnet.CLS.views.popupmenuview
{
   import blix.action.IAction;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.factory.ILeaguesActionFactory;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PopUpMenuView extends StatefulView
   {
      
      private static const POPUP_YMAX:Number = 600;
      
      private static const SUMMONER_STATE:String = "summoner";
      
      private static const TEAM_STATE:String = "team";
      
      private static const SPECTATE_STATE:String = "_spectate";
      
      private var _addFriendButton:LabelButtonX;
      
      private var _viewProfileButton:LabelButtonX;
      
      private var _spectateButton:LabelButtonX;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _currentSummonerName:String;
      
      private var _id:String;
      
      private var _position:Point = new Point(0,0);
      
      private var _isTeam:Boolean;
      
      private var _isSpectatable:Boolean = false;
      
      public function PopUpMenuView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this._addFriendButton = new LabelButtonX(this);
         this._addFriendButton.setText(this._localeHelper.localeLookup("pumAddFriend"));
         this._addFriendButton.addEventListener(MouseEvent.CLICK,this.onAddFriendButton);
         setTimelineChildByName("AddFriendButton",this._addFriendButton);
         this._viewProfileButton = new LabelButtonX(this);
         this._viewProfileButton.setText(this._localeHelper.localeLookup("pumViewProfile"));
         this._viewProfileButton.addEventListener(MouseEvent.CLICK,this.onViewProfileButton);
         setTimelineChildByName("ViewProfileButton",this._viewProfileButton);
         this._spectateButton = new LabelButtonX(this);
         this._spectateButton.setText(this._localeHelper.localeLookup("pumSpectate"));
         this._spectateButton.addEventListener(MouseEvent.CLICK,this.onSpectateButton);
         setTimelineChildByName("spectateButton",this._spectateButton);
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnPopUpMenuView().add(this.onSetVisible);
      }
      
      private function setInvisible() : void
      {
         if(this.getStage())
         {
            this.getStage().removeEventListener(MouseEvent.CLICK,this.onSetInvisible);
         }
         setVisible(false);
      }
      
      private function onAddFriendButton(param1:MouseEvent) : void
      {
         this.setInvisible();
         this._leagueSystemModuleNavigation.dispatchOnAddFriendPressed(this._currentSummonerName);
      }
      
      private function onViewProfileButton(param1:MouseEvent) : void
      {
         this.setInvisible();
         this._leagueSystemModuleNavigation.dispatchOnViewProfilePressed(this._currentSummonerName,this._id,this._isTeam);
      }
      
      private function onSpectateButton(param1:MouseEvent) : void
      {
         var _loc2_:ILeaguesActionFactory = null;
         var _loc3_:IAction = null;
         if(this._isSpectatable)
         {
            _loc2_ = getDependency(ILeaguesActionFactory);
            if(this._isTeam)
            {
               _loc3_ = _loc2_.getRetrieveInProgressGameSpectatorInfoAction(this._id);
            }
            else
            {
               _loc3_ = _loc2_.getRetrieveInProgressGameSpectatorInfoAction(this._currentSummonerName);
            }
            _loc3_.invoke();
         }
      }
      
      private function onSetVisible(param1:Number, param2:Number, param3:String, param4:String, param5:Boolean, param6:Boolean, param7:LeagueTier) : void
      {
         var _loc8_:String = param7 != LeagueTier.CHALLENGER ? "" : SPECTATE_STATE;
         this._isTeam = param5;
         if(this._isTeam)
         {
            setCurrentState(TEAM_STATE + _loc8_);
         }
         else
         {
            setCurrentState(SUMMONER_STATE + _loc8_);
         }
         this._currentSummonerName = param3;
         this._id = param4;
         if(this.getStage())
         {
            this.getStage().addEventListener(MouseEvent.CLICK,this.onSetInvisible,false,0,true);
         }
         setVisible(true);
         this._position.x = param1;
         this._position.y = Math.min(param2,POPUP_YMAX);
         this._isSpectatable = param6;
         this._spectateButton.setEnabled(this._isSpectatable);
         setExplicitPosition(this._position.x,this._position.y);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return super.updateLayout(param1,param2);
      }
      
      private function onSetInvisible(param1:MouseEvent) : void
      {
         this.setInvisible();
      }
   }
}

