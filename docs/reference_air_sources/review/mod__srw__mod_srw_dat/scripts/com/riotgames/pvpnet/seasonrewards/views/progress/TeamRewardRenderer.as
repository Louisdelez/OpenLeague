package com.riotgames.pvpnet.seasonrewards.views.progress
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.seasonrewards.models.RewardModel;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   
   public class TeamRewardRenderer extends SpriteProxy
   {
      
      private var earned:Boolean;
      
      private var requirementText:TextFieldProxy;
      
      private var highlight:SpriteProxy;
      
      private var background:SpriteProxy;
      
      private var vLine:SpriteProxy;
      
      private var model:RewardModel;
      
      private var localeHelper:ILocaleHelper;
      
      public function TeamRewardRenderer(param1:IContext, param2:RewardModel)
      {
         super(param1);
         setLinkage("TeamRewardRenderer");
         this.setModel(param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.localeHelper = getDependency(ILocaleHelper);
         this.requirementText = new TextFieldProxy(this);
         setTimelineChildByName("requirementText",this.requirementText);
         this.highlight = new SpriteProxy(this);
         this.highlight.setVisible(false);
         this.highlight.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("highlight",this.highlight);
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this.vLine = new SpriteProxy(this);
         setTimelineChildByName("vLine",this.vLine);
         getMouseIsOverChanged().add(this.mouseIsOverChanged);
      }
      
      public function getModel() : RewardModel
      {
         return this.model;
      }
      
      public function setModel(param1:RewardModel) : void
      {
         this.model = param1;
      }
      
      public function setLabel(param1:String) : void
      {
         this.setHtmlText(this.requirementText,param1);
      }
      
      public function setEarned(param1:Boolean) : void
      {
         this.earned = param1;
         this.highlight.setVisible(this.earned || Boolean(getMouseIsOver()));
      }
      
      public function setIndex(param1:int) : void
      {
         this.vLine.setVisible(param1 != 0);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.requirementText.setExplicitSize(param1,NaN);
         this.highlight.setExplicitSize(param1,NaN);
         this.background.setExplicitSize(param1,NaN);
         return super.updateLayout(param1,param2);
      }
      
      private function mouseIsOverChanged(param1:TeamRewardRenderer) : void
      {
         this.highlight.setVisible(this.earned || Boolean(getMouseIsOver()));
      }
      
      private function setHtmlText(param1:TextFieldProxy, param2:String) : void
      {
         var _loc4_:TextFormat = null;
         var _loc3_:String = null;
         if(this.requirementText.getDefaultTextFormat())
         {
            _loc3_ = this.requirementText.getDefaultTextFormat().font;
         }
         param1.setHtmlText(param2);
         if(_loc3_)
         {
            _loc4_ = new TextFormat(_loc3_);
            this.requirementText.setDefaultTextFormat(_loc4_);
            this.requirementText.setTextFormat(_loc4_);
         }
      }
   }
}

