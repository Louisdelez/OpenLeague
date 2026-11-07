package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import blix.layout.vo.Padding;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.riotgames.pvpnet.runes.views.common.RuneInventoryRenderer;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.geom.Rectangle;
   
   public class RuneBin extends DataGroup
   {
      
      private var _heightPercent:Number;
      
      private var background:SpriteProxy;
      
      private var _showSignal:Signal = new Signal();
      
      public function RuneBin(param1:IContext)
      {
         super(param1);
         setVisible(false);
         var _loc2_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc2_.setPadding(new Padding(0));
         _loc2_.setGap(1);
         setLayoutAlgorithm(_loc2_);
         setRendererFactory(new RendererFactory(RuneInventoryRenderer,[this]));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
      }
      
      public function getShowSignal() : ISignal
      {
         return this._showSignal;
      }
      
      public function show() : void
      {
         this.heightPercent = 0;
         setVisible(true);
         var _loc1_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         TweenLite.to(this,_loc1_ ? 0.07 : 0,{
            "heightPercent":1,
            "ease":Sine.easeIn,
            "onComplete":this._showSignal.dispatch,
            "onCompleteParams":[this,true]
         });
      }
      
      public function hide() : void
      {
         setVisible(false);
         var _loc1_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         TweenLite.to(this,_loc1_ ? 0.03 : 0,{
            "heightPercent":0,
            "ease":Sine.easeOut,
            "onComplete":setVisible,
            "onCompleteParams":[false]
         });
      }
      
      public function get heightPercent() : Number
      {
         return this._heightPercent;
      }
      
      public function set heightPercent(param1:Number) : void
      {
         this._heightPercent = param1;
         invalidateLayout();
      }
      
      public function setRunes(param1:IListX) : void
      {
         setDataProvider(param1);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         var _loc4_:Rectangle = new Rectangle(0,0,_loc3_.width,_loc3_.height * this._heightPercent);
         setScrollRect(_loc4_);
         this.background.setExplicitSize(_loc3_.width,_loc3_.height);
         this.background.setExplicitPosition(0,0);
         return _loc4_;
      }
   }
}

