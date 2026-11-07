package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryTeamStats;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class MatchHistoryBansView extends SpriteProxy
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _teamNumber:int;
      
      private var _banText:TextFieldProxy;
      
      private var _ban1Sizer:SpriteProxy;
      
      private var _ban2Sizer:SpriteProxy;
      
      private var _ban3Sizer:SpriteProxy;
      
      private var _ban1ChampionIcon:NewMatchHistoryChampionRenderer;
      
      private var _ban2ChampionIcon:NewMatchHistoryChampionRenderer;
      
      private var _ban3ChampionIcon:NewMatchHistoryChampionRenderer;
      
      public function MatchHistoryBansView(param1:IContext, param2:int)
      {
         this._teamNumber = param2;
         super(param1);
         this._model.getCurrentGameChanged().add(this.handleCurrentGameChanged);
         this.handleCurrentGameChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._banText = new TextFieldProxy(this);
         setTimelineChildByName("banText",this._banText);
         this._banText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_bans"));
         this._ban1Sizer = new SpriteProxy(this);
         setTimelineChildByName("ban1sizer",this._ban1Sizer);
         this._ban2Sizer = new SpriteProxy(this);
         setTimelineChildByName("ban2sizer",this._ban2Sizer);
         this._ban3Sizer = new SpriteProxy(this);
         setTimelineChildByName("ban3sizer",this._ban3Sizer);
         this._ban1ChampionIcon = new NewMatchHistoryChampionRenderer(this,new Sprite());
         addChild(this._ban1ChampionIcon);
         this._ban2ChampionIcon = new NewMatchHistoryChampionRenderer(this,new Sprite());
         addChild(this._ban2ChampionIcon);
         this._ban3ChampionIcon = new NewMatchHistoryChampionRenderer(this,new Sprite());
         addChild(this._ban3ChampionIcon);
         super.createChildren();
      }
      
      private function updateView() : void
      {
         var _loc1_:Vector.<Champion> = null;
         if(Boolean(this._currentGame) && this._currentGame.getDetailsPopulated())
         {
            _loc1_ = MatchHistoryTeamStats(this._currentGame.teams[this._teamNumber]).bans;
            setVisible(_loc1_.length > 0);
            if(_loc1_.length > 0)
            {
               this._ban1ChampionIcon.setChampion(_loc1_[0]);
            }
            if(_loc1_.length > 1)
            {
               this._ban2ChampionIcon.setChampion(_loc1_[1]);
            }
            if(_loc1_.length > 2)
            {
               this._ban3ChampionIcon.setChampion(_loc1_[2]);
            }
         }
         else
         {
            this._ban1ChampionIcon.setChampion(null);
            this._ban2ChampionIcon.setChampion(null);
            this._ban3ChampionIcon.setChampion(null);
         }
      }
      
      private function handleCurrentGameChanged() : void
      {
         this.removeGameListeners();
         this._currentGame = this._model.getCurrentGame();
         this.handleDetailsPopulatedChanged();
         this.addGameListeners();
      }
      
      private function addGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getDetailsPopulatedChanged().add(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function removeGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getDetailsPopulatedChanged().remove(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function handleDetailsPopulatedChanged() : void
      {
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._ban1ChampionIcon.setExplicitSize(this._ban1Sizer.getWidth(),this._ban1Sizer.getHeight());
         this._ban1ChampionIcon.setExplicitPosition(this._ban1Sizer.getX(),this._ban1Sizer.getY());
         this._ban2ChampionIcon.setExplicitSize(this._ban2Sizer.getWidth(),this._ban2Sizer.getHeight());
         this._ban2ChampionIcon.setExplicitPosition(this._ban2Sizer.getX(),this._ban2Sizer.getY());
         this._ban3ChampionIcon.setExplicitSize(this._ban3Sizer.getWidth(),this._ban3Sizer.getHeight());
         this._ban3ChampionIcon.setExplicitPosition(this._ban3Sizer.getX(),this._ban3Sizer.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

