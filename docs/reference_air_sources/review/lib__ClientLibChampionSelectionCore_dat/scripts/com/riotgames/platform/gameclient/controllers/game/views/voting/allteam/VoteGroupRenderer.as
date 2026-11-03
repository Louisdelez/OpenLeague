package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import flash.geom.Rectangle;
   
   public class VoteGroupRenderer extends StatefulView
   {
      
      private var extensionContainer:DisplayObjectContainerProxy;
      
      private var borderCloser:StatefulView;
      
      private var skinSliderLayout:LayoutContainer;
      
      private var skinSliderHorizontalLayout:HorizontalLayout;
      
      private var sizer:SpriteProxy;
      
      private var winnerText:TextFieldProxy;
      
      private var voteItem:VoteItem;
      
      private var voteNumberText:TextFieldProxy;
      
      private var championImage:MovieClipProxy;
      
      private var spanningBar:SpriteProxy;
      
      private var textBackground:TextFieldProxy;
      
      public function VoteGroupRenderer(param1:IContext, param2:VoteItem)
      {
         super(param1);
         this.setVoteItem(param2);
         setLinkage("ChampVoteRendererExtended");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.extensionContainer.setExplicitPosition(62,-1);
         this.skinSliderLayout.setExplicitPosition(62,-1);
         this.borderCloser.setExplicitPosition(this.extensionContainer.getBounds().right - 5,-1);
         if(this.voteItem != null)
         {
            this.spanningBar.setWidth(this.voteItem.size * 60);
            this.winnerText.setWidth((this.voteItem.size - 1) * 60);
         }
         this.extensionContainer.setExplicitSize(this.sizer.getWidth(),this.sizer.getHeight());
         return new Rectangle(0,0,this.sizer.getWidth(),this.sizer.getHeight());
      }
      
      private function setVoteItem(param1:VoteItem) : void
      {
         this.voteItem = param1;
         VoteRendererUtils.updatePercentChance(this.voteNumberText,this.voteItem);
         VoteRendererUtils.updateIconState(this,this.voteItem);
         VoteRendererUtils.updateIconImage(this.championImage,this.voteItem);
         this.textBackground.setVisible(this.voteNumberText.getVisible());
         this.spanningBar.setVisible(this.voteNumberText.getVisible());
         this.sizer.setWidth(64 * this.voteItem.size);
         this.updateExtension();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.championImage = new MovieClipProxy(this);
         setTimelineChildByName("championImage",this.championImage);
         this.championImage.getAssetChanged().add(invalidateLayout);
         this.voteNumberText = new TextFieldProxy(this);
         setTimelineChildByName("voteNumberLabel",this.voteNumberText);
         this.textBackground = new TextFieldProxy(this);
         setTimelineChildByName("textBackground",this.textBackground);
         this.spanningBar = new SpriteProxy(this);
         setTimelineChildByName("spanningBar",this.spanningBar);
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this.sizer);
         this.extensionContainer = new DisplayObjectContainerProxy(this);
         setTimelineChildByName("extensionContainer",this.extensionContainer);
         this.borderCloser = new StatefulView(this);
         setTimelineChildByName("borderCloser",this.borderCloser);
         this.skinSliderLayout = new LayoutContainer(this.extensionContainer);
         this.skinSliderHorizontalLayout = new HorizontalLayout();
         this.skinSliderHorizontalLayout.setGap(-3);
         this.skinSliderLayout.setLayoutAlgorithm(this.skinSliderHorizontalLayout);
         this.skinSliderLayout.getLayoutInvalidated().add(invalidateLayout);
         this.winnerText = new TextFieldProxy(this);
         setTimelineChildByName("winnerText",this.winnerText);
         this.winnerText.setText(RiotResourceLoader.getString("champSelect_voting_winner"));
      }
      
      private function updateExtension() : void
      {
         var _loc3_:MovieClipProxy = null;
         var _loc1_:StatefulView = null;
         var _loc2_:int = 1;
         while(_loc2_ < this.voteItem.size)
         {
            _loc1_ = new StatefulView(this);
            _loc1_.setLinkage("ChampIconExtended");
            VoteRendererUtils.updateIconState(_loc1_,this.voteItem);
            VoteRendererUtils.updateIconState(this.borderCloser,this.voteItem);
            _loc3_ = new MovieClipProxy(this);
            _loc1_.setTimelineChildByName("championImage",_loc3_);
            VoteRendererUtils.updateIconImageTile(_loc3_,this.voteItem);
            _loc1_.getAssetChanged().add(this.skinSliderLayout.invalidateLayout);
            this.extensionContainer.addChild(_loc1_);
            this.skinSliderLayout.addElement(_loc1_);
            _loc2_++;
         }
      }
   }
}

