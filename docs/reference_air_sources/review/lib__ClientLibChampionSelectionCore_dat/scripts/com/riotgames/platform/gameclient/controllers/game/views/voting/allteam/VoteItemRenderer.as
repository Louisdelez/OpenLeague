package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import flash.geom.Rectangle;
   
   public class VoteItemRenderer extends StatefulView
   {
      
      private var voteNumberText:TextFieldProxy;
      
      private var textBackground:TextFieldProxy;
      
      private var sizer:SpriteProxy;
      
      private var championImage:MovieClipProxy;
      
      private var voteItem:VoteItem;
      
      public function VoteItemRenderer(param1:IContext, param2:VoteItem)
      {
         super(param1);
         this.setVoteItem(param2);
         setLinkage("ChampVoteRenderer");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this.sizer.getWidth(),this.sizer.getHeight());
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
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this.sizer);
      }
      
      private function setVoteItem(param1:VoteItem) : void
      {
         this.voteItem = param1;
         VoteRendererUtils.updatePercentChance(this.voteNumberText,this.voteItem);
         VoteRendererUtils.updateIconState(this,this.voteItem);
         VoteRendererUtils.updateIconImage(this.championImage,this.voteItem);
         if(this.voteItem.winner)
         {
            this.voteNumberText.setText(RiotResourceLoader.getString("champSelect_voting_winner"));
            this.voteNumberText.setVisible(true);
         }
         this.textBackground.setVisible(this.voteNumberText.getVisible());
      }
   }
}

