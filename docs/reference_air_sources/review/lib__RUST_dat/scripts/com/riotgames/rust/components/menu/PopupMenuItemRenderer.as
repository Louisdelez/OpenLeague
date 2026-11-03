package com.riotgames.rust.components.menu
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.rust.components.button.ResizableButton;
   import flash.geom.Rectangle;
   
   public class PopupMenuItemRenderer extends ResizableButton
   {
      
      protected var _dataLinkage:String;
      
      protected var _separatorLinkage:String;
      
      protected var _labelField:String;
      
      protected var _moreOptions:SpriteProxy;
      
      public function PopupMenuItemRenderer(param1:IContext, param2:String = null, param3:String = null, param4:String = null)
      {
         if(!param3)
         {
            param3 = param2;
         }
         this._dataLinkage = param2;
         this._separatorLinkage = param3;
         this._labelField = param4;
         super(param1);
         this.horizontalAlign = HorizontalAlign.LEFT;
      }
      
      override protected function createChildren() : void
      {
         button = new StatefulView(this);
         setTimelineChildByName("button",button);
         super.createChildren();
         this._moreOptions = new SpriteProxy(this);
         setTimelineChildByName("moreOptions",this._moreOptions);
      }
      
      override public function setData(param1:*) : void
      {
         var _loc2_:* = undefined;
         super.setData(param1);
         if(param1 is MenuNode)
         {
            _loc2_ = (param1 as MenuNode).header;
            if(Boolean(this._moreOptions))
            {
               this._moreOptions.setVisible(true);
            }
         }
         else
         {
            _loc2_ = param1;
            if(Boolean(this._moreOptions))
            {
               this._moreOptions.setVisible(false);
            }
         }
         if(_loc2_ is String)
         {
            textField.setText(_loc2_);
         }
         else if(_loc2_ is Object && this._labelField != null)
         {
            textField.setText(_loc2_[this._labelField]);
         }
         if(_loc2_ != null)
         {
            setLinkage(this._dataLinkage);
            setEnabled(true);
         }
         else
         {
            setLinkage(this._separatorLinkage);
            setEnabled(false);
         }
         invalidateLayout();
      }
      
      override public function setCurrentState(param1:String) : void
      {
         var _loc2_:StatefulView = null;
         super.setCurrentState(param1);
         if(button is StatefulView)
         {
            _loc2_ = button as StatefulView;
            _loc2_.setCurrentState(param1);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         if(Boolean(this._moreOptions))
         {
            this._moreOptions.setX(_loc3_.width - this._moreOptions.getWidth() - _rightPadding);
         }
         return _loc3_;
      }
   }
}

