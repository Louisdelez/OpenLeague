package com.riotgames.pvpnet.runes.views.runespage
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.Padding;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.ItemEffectHelper;
   import com.riotgames.pvpnet.runes.controller.RuneConfigurationController;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class RuneItemEffectRenderer extends SpriteProxy implements IItemRenderer
   {
      
      private var _itemEffect:ItemEffect;
      
      private var valueTextField:Text;
      
      private var statNameTextField:Text;
      
      private var _index:uint;
      
      private var layoutContainer:LayoutContainer;
      
      private var runeConfigController:RuneConfigurationController;
      
      public function RuneItemEffectRenderer(param1:IContext)
      {
         super(param1);
         setLinkage(this.runeConfigController.getItemEffectLinkage());
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runeConfigController = getDependency(RuneConfigurationController);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:SizeLayoutData = new SizeLayoutData();
         _loc1_.setWidthPercent(1);
         this.layoutContainer = new LayoutContainer(this);
         this.layoutContainer.getLayoutInvalidated().add(invalidateLayout);
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.setGap(1);
         if(this.runeConfigController.isIronStyle())
         {
            _loc2_.setPadding(new Padding(1));
         }
         else if(this.runeConfigController.isLegacyStyle())
         {
            _loc2_.setPadding(new Padding(3));
         }
         this.layoutContainer.setLayoutAlgorithm(_loc2_);
         this.statNameTextField = new Text(this);
         this.statNameTextField.getLayoutInvalidated().add(invalidateLayout);
         this.statNameTextField.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("statNameTextField",this.statNameTextField);
         this.layoutContainer.addElement(this.statNameTextField,_loc1_);
         this.valueTextField = new Text(this);
         this.valueTextField.getLayoutInvalidated().add(invalidateLayout);
         this.valueTextField.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("valueTextField",this.valueTextField);
         this.layoutContainer.addElement(this.valueTextField,_loc1_);
         var _loc3_:SpriteProxy = new SpriteProxy(this);
         _loc3_.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("hRule",_loc3_);
         this.layoutContainer.addElement(_loc3_,_loc1_);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.layoutContainer.setExplicitSize(param1,param2);
         this.layoutContainer.setExplicitPosition(0,0);
         return new Rectangle(0,0,_loc3_.x,_loc3_.y);
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
         return this._itemEffect;
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:String = null;
         this._itemEffect = param1 as ItemEffect;
         if(this._itemEffect != null)
         {
            _loc2_ = "+ " + ItemEffectHelper.getValueFormattingForItemEffect(this._itemEffect);
            if(this.runeConfigController.isLegacyStyle())
            {
               this.valueTextField.setText(_loc2_);
               this.statNameTextField.setText(this._itemEffect.displayName);
            }
            else if(this.runeConfigController.isIronStyle())
            {
               this.valueTextField.setText(_loc2_ + " " + this._itemEffect.displayName);
            }
         }
      }
   }
}

