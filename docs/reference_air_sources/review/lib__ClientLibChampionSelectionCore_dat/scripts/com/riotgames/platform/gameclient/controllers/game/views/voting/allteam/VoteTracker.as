package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import flash.geom.Rectangle;
   
   public class VoteTracker extends SpriteProxy
   {
      
      public var xOffset:int = 5;
      
      public var yOffset:int = 3;
      
      private var _horizontalLayout:HorizontalLayout;
      
      private var _voteItemComponents:Vector.<StatefulView> = new Vector.<StatefulView>();
      
      private var _horizontalLayoutContainer:LayoutContainer;
      
      private var _voteItems:Array = [];
      
      public function VoteTracker(param1:IContext)
      {
         super(param1);
         setLinkage("VoteTracker");
      }
      
      public function getModel() : Array
      {
         return this._voteItems;
      }
      
      public function setModel(param1:Array) : void
      {
         this._voteItems = param1;
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._horizontalLayoutContainer.setExplicitPosition(this.xOffset,this.yOffset);
         return new Rectangle(0,0,param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._horizontalLayoutContainer = new LayoutContainer(this);
         this._horizontalLayout = new HorizontalLayout();
         this._horizontalLayout.setGap(8);
         this._horizontalLayoutContainer.setLayoutAlgorithm(this._horizontalLayout);
         this._horizontalLayoutContainer.getLayoutInvalidated().add(invalidateLayout);
      }
      
      private function updateView() : void
      {
         var _loc2_:VoteItem = null;
         this.removeVoteItemComponents();
         var _loc1_:StatefulView = null;
         for each(_loc2_ in this._voteItems)
         {
            _loc1_ = _loc2_.size == 1 ? new VoteItemRenderer(this,_loc2_) : new VoteGroupRenderer(this,_loc2_);
            this.addChild(_loc1_);
            this._horizontalLayoutContainer.addElement(_loc1_);
            this._voteItemComponents.push(_loc1_);
         }
      }
      
      private function removeVoteItemComponents() : void
      {
         var _loc1_:StatefulView = null;
         for each(_loc1_ in this._voteItemComponents)
         {
            removeChild(_loc1_);
            _loc1_.destroy();
         }
         this._voteItemComponents.length = 0;
         this._horizontalLayoutContainer.removeAllElements();
      }
   }
}

