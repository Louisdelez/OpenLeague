package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryContentHelper;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.geom.Rectangle;
   
   public class MatchHistoryScoreboardRenderer extends StatefulView implements IItemRenderer
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _index:uint;
      
      private var _participant:MatchHistoryGameParticipant;
      
      private var _championIcon:NewMatchHistoryChampionRenderer;
      
      private var _spell1Icon:NewMatchHistorySpellRenderer;
      
      private var _spell2Icon:NewMatchHistorySpellRenderer;
      
      private var _championIconSizer:SpriteProxy;
      
      private var _spell1IconSizer:SpriteProxy;
      
      private var _spell2IconSizer:SpriteProxy;
      
      private var _item1IconSizer:SpriteProxy;
      
      private var _item2IconSizer:SpriteProxy;
      
      private var _item3IconSizer:SpriteProxy;
      
      private var _item4IconSizer:SpriteProxy;
      
      private var _item5IconSizer:SpriteProxy;
      
      private var _item6IconSizer:SpriteProxy;
      
      private var _item7IconSizer:SpriteProxy;
      
      private var _item1:NewMatchHistoryGameItemRenderer;
      
      private var _item2:NewMatchHistoryGameItemRenderer;
      
      private var _item3:NewMatchHistoryGameItemRenderer;
      
      private var _item4:NewMatchHistoryGameItemRenderer;
      
      private var _item5:NewMatchHistoryGameItemRenderer;
      
      private var _item6:NewMatchHistoryGameItemRenderer;
      
      private var _item7:NewMatchHistoryGameItemRenderer;
      
      private var _kdaText:TextFieldProxy;
      
      private var _goldText:TextFieldProxy;
      
      private var _csText:TextFieldProxy;
      
      private var _objectiveScoreText:TextFieldProxy;
      
      private var _levelText:TextFieldProxy;
      
      private var _summonerNameText:TextFieldProxy;
      
      private var _background:StatefulView;
      
      private var _dominionRank:StatefulView;
      
      public function MatchHistoryScoreboardRenderer(param1:IContext, param2:String)
      {
         super(param1,null);
         setLinkage(param2);
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._championIcon = new NewMatchHistoryChampionRenderer(this);
         setTimelineChildByName("championIconContainer",this._championIcon);
         this._spell1Icon = new NewMatchHistorySpellRenderer(this);
         addChild(this._spell1Icon);
         this._spell2Icon = new NewMatchHistorySpellRenderer(this);
         addChild(this._spell2Icon);
         this._item1 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item1);
         this._item2 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item2);
         this._item3 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item3);
         this._item4 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item4);
         this._item5 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item5);
         this._item6 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item6);
         this._item7 = new NewMatchHistoryGameItemRenderer(this);
         addChild(this._item7);
         this._kdaText = new TextFieldProxy(this);
         setTimelineChildByName("kdaText",this._kdaText);
         this._goldText = new TextFieldProxy(this);
         setTimelineChildByName("goldText",this._goldText);
         this._csText = new TextFieldProxy(this);
         setTimelineChildByName("csText",this._csText);
         this._objectiveScoreText = new TextFieldProxy(this);
         setTimelineChildByName("objectiveScoreText",this._objectiveScoreText);
         this._championIconSizer = new SpriteProxy(this);
         setTimelineChildByName("championIconSizer",this._championIconSizer);
         this._spell1IconSizer = new SpriteProxy(this);
         setTimelineChildByName("spell1IconSizer",this._spell1IconSizer);
         this._spell2IconSizer = new SpriteProxy(this);
         setTimelineChildByName("spell2IconSizer",this._spell2IconSizer);
         this._item1IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item1Sizer",this._item1IconSizer);
         this._item2IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item2Sizer",this._item2IconSizer);
         this._item3IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item3Sizer",this._item3IconSizer);
         this._item4IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item4Sizer",this._item4IconSizer);
         this._item5IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item5Sizer",this._item5IconSizer);
         this._item6IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item6Sizer",this._item6IconSizer);
         this._item7IconSizer = new SpriteProxy(this);
         setTimelineChildByName("item7Sizer",this._item7IconSizer);
         this._levelText = new TextFieldProxy(this);
         setTimelineChildByName("levelText",this._levelText);
         this._levelText.setMouseEnabled(false);
         this._summonerNameText = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameText",this._summonerNameText);
         this._summonerNameText.setText("");
         this._background = new StatefulView(this);
         setTimelineChildByName("background",this._background);
         this._dominionRank = new StatefulView(this);
         setTimelineChildByName("dominionRank",this._dominionRank);
         this._dominionRank.setMouseEnabled(false);
         super.createChildren();
      }
      
      private function updateView() : void
      {
         if(this._participant)
         {
            if(Boolean(this._model.getCurrentGame()) && MatchHistoryContentHelper.shouldShowObjectiveScoreForMap(this._model.getCurrentGame().mapId))
            {
               setCurrentState("objectiveScore");
            }
            else
            {
               setCurrentState("default");
            }
            this._championIcon.setChampion(this._participant.champion);
            this._spell1Icon.setSpell(this._participant.spell1);
            this._spell2Icon.setSpell(this._participant.spell2);
            this._item1.setGameItem(this._participant.stats.item0);
            this._item2.setGameItem(this._participant.stats.item1);
            this._item3.setGameItem(this._participant.stats.item2);
            this._item4.setGameItem(this._participant.stats.item3);
            this._item5.setGameItem(this._participant.stats.item4);
            this._item6.setGameItem(this._participant.stats.item5);
            this._item7.setGameItem(this._participant.stats.item6);
            this._kdaText.setText(this.getFormattedKDA());
            this._goldText.setText(this.getFormattedGold());
            this._csText.setText(this._participant.stats.totalMinionsKilled.toString());
            this._objectiveScoreText.setText(this._participant.stats.totalPlayerScore.toString());
            this._levelText.setText(this._participant.stats.champLevel.toString());
            this._summonerNameText.setText(this._participant.player.summonerName);
            this._dominionRank.setCurrentState(this._participant.stats.totalScoreRank.toString());
            if(this._participant.player.accountId == this._model.getCurrentGame().searchedParticipant.player.accountId)
            {
               this._background.setCurrentState("isMe");
            }
            else
            {
               this._background.setCurrentState("default");
            }
         }
      }
      
      private function getFormattedKDA() : String
      {
         return this._participant.stats.kills.toString() + "/" + this._participant.stats.deaths.toString() + "/" + this._participant.stats.assists.toString();
      }
      
      private function getFormattedGold() : String
      {
         var _loc1_:int = this._participant.stats.goldEarned;
         var _loc2_:String = EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.THOUSAND);
         return Math.round(_loc1_ / 1000).toString() + _loc2_;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._championIcon.setExplicitSize(this._championIconSizer.getWidth(),this._championIconSizer.getHeight());
         this._championIcon.setExplicitPosition(this._championIconSizer.getX(),this._championIconSizer.getY());
         this._spell1Icon.setExplicitSize(this._spell1IconSizer.getWidth(),this._spell1IconSizer.getHeight());
         this._spell1Icon.setExplicitPosition(this._spell1IconSizer.getX(),this._spell1IconSizer.getY());
         this._spell2Icon.setExplicitSize(this._spell2IconSizer.getWidth(),this._spell2IconSizer.getHeight());
         this._spell2Icon.setExplicitPosition(this._spell2IconSizer.getX(),this._spell2IconSizer.getY());
         this._item1.setExplicitSize(this._item1IconSizer.getWidth(),this._item1IconSizer.getHeight());
         this._item1.setExplicitPosition(this._item1IconSizer.getX(),this._item1IconSizer.getY());
         this._item2.setExplicitSize(this._item2IconSizer.getWidth(),this._item2IconSizer.getHeight());
         this._item2.setExplicitPosition(this._item2IconSizer.getX(),this._item2IconSizer.getY());
         this._item3.setExplicitSize(this._item3IconSizer.getWidth(),this._item3IconSizer.getHeight());
         this._item3.setExplicitPosition(this._item3IconSizer.getX(),this._item3IconSizer.getY());
         this._item4.setExplicitSize(this._item4IconSizer.getWidth(),this._item4IconSizer.getHeight());
         this._item4.setExplicitPosition(this._item4IconSizer.getX(),this._item4IconSizer.getY());
         this._item5.setExplicitSize(this._item5IconSizer.getWidth(),this._item5IconSizer.getHeight());
         this._item5.setExplicitPosition(this._item5IconSizer.getX(),this._item5IconSizer.getY());
         this._item6.setExplicitSize(this._item6IconSizer.getWidth(),this._item6IconSizer.getHeight());
         this._item6.setExplicitPosition(this._item6IconSizer.getX(),this._item6IconSizer.getY());
         this._item7.setExplicitSize(this._item7IconSizer.getWidth(),this._item7IconSizer.getHeight());
         this._item7.setExplicitPosition(this._item7IconSizer.getX(),this._item7IconSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getData() : *
      {
         return this._participant;
      }
      
      public function setData(param1:*) : void
      {
         if(param1 != this._participant)
         {
            this._participant = param1 as MatchHistoryGameParticipant;
            this.updateView();
         }
      }
   }
}

