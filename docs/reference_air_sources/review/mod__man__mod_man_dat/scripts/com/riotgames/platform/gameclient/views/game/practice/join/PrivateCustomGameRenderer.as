package com.riotgames.platform.gameclient.views.game.practice.join
{
   import mx.controls.Image;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   
   public class PrivateCustomGameRenderer extends UIComponent implements IListItemRenderer
   {
      
      protected static const lockImageClass:Class = PrivateCustomGameRenderer_lockImageClass;
      
      protected var _data:Object;
      
      protected var lockImage:UIComponent;
      
      protected var dataChanged:Boolean = false;
      
      public function PrivateCustomGameRenderer()
      {
         super();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.dataChanged && Boolean(this.lockImage))
         {
            this.lockImage.visible = this.data ? Boolean(this.data.privateGame) : false;
            this.dataChanged = false;
         }
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.dataChanged = true;
         invalidateProperties();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      protected function createLockImage() : UIComponent
      {
         var _loc1_:Image = new Image();
         _loc1_.source = lockImageClass;
         _loc1_.smoothBitmapContent = true;
         _loc1_.width = 13;
         return _loc1_;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lockImage = this.createLockImage();
         if(this.lockImage)
         {
            addChild(this.lockImage);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this.lockImage)
         {
            _loc3_ = Number(this.lockImage.getExplicitOrMeasuredWidth());
            _loc4_ = Number(this.lockImage.getExplicitOrMeasuredHeight());
            this.lockImage.setActualSize(_loc3_,_loc4_);
            this.lockImage.move((param1 - _loc3_) / 2,(param2 - _loc4_) / 2);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.lockImage)
         {
            measuredWidth = this.lockImage.getExplicitOrMeasuredWidth();
            measuredHeight = this.lockImage.getExplicitOrMeasuredHeight();
         }
      }
   }
}

