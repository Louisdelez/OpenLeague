package com.riotgames.pvpnet.window.popupwindow
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DynamicPopupWindow extends StatefulView
   {
      
      private const TARGET_SIZER_LINKAGE:String = "sizer";
      
      private const DEFAULT_LINKAGE_NAME:String = "TickerWindow";
      
      private const WINDOW_LINKAGE:String = "";
      
      private const BACKGROUND_AND_ARROW_LINKAGE:String = "windowBackground";
      
      private const CLOSE_BUTTON_LINKAGE:String = "close";
      
      private const DISPLAY_ANCHOR_LINKAGE:String = "displayAnchor";
      
      private const ARROW_LINKAGE:String = "windowBackground.arrow";
      
      private const BACKGROUND_LINKAGE:String = "windowBackground.background";
      
      private const DEFAULT_CONTENT_Y_OFFSET:Number = 15;
      
      protected var _contentYOffset:Number = 15;
      
      protected var _borderWindowOffset:Number = 0;
      
      private var _minBounds:Point = new Point();
      
      private var _windowModel:DynamicPopupWindowModel;
      
      protected var _contentList:Vector.<MovieClipProxy> = new Vector.<MovieClipProxy>();
      
      private var _targetPosition:Point;
      
      private var _popupWindowBounds:Rectangle;
      
      private var _backgroundsBounds:Rectangle;
      
      private var _targetBounds:Rectangle;
      
      private var _closeButtonOffsetFromTopRight:Point;
      
      protected var _background:MovieClipProxy;
      
      protected var _window:MovieClipProxy;
      
      protected var _closeButton:ButtonX;
      
      protected var _displayAnchor:MovieClipProxy;
      
      private var _arrow:MovieClipProxy;
      
      public function DynamicPopupWindow(param1:IContext, param2:String)
      {
         super(param1,null);
         setLinkage(param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._window = new MovieClipProxy(this);
         this._closeButton = new ButtonX(this);
         this._displayAnchor = new MovieClipProxy(this);
         this._arrow = new MovieClipProxy(this);
         this._background = new MovieClipProxy(this);
         setTimelineChildByName(this.BACKGROUND_AND_ARROW_LINKAGE,this._window);
         setTimelineChildByName(this.CLOSE_BUTTON_LINKAGE,this._closeButton);
         setTimelineChildByName(this.DISPLAY_ANCHOR_LINKAGE,this._displayAnchor);
         setTimelineChildByName(this.ARROW_LINKAGE,this._arrow);
         setTimelineChildByName(this.BACKGROUND_LINKAGE,this._background);
         this._closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClicked);
         this._background.getAssetChanged().add(this.onBackgroundLoaded);
         this._closeButton.getAssetChanged().addOnce(this.setInitialSizeAndPositionData);
         this._window.getAssetChanged().addOnce(this.setInitialSizeAndPositionData);
         this.getAssetChanged().addOnce(this.setInitialSizeAndPositionData);
      }
      
      private function onBackgroundLoaded() : void
      {
         if(Boolean(this._background.getAsset()))
         {
            this._minBounds.x = this._background.getAsset().width;
            this._minBounds.y = this._background.getAsset().height;
            this.setInitialSizeAndPositionData();
         }
      }
      
      private function setInitialSizeAndPositionData() : void
      {
         if(Boolean(this.getAsset()) && Boolean(this._window.getAsset()) && Boolean(this._closeButton.getAsset()) && Boolean(this._background.getAsset()))
         {
            this.refreshData();
            this.setCloseButtonOffset();
         }
      }
      
      private function setCloseButtonOffset() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(Boolean(this.getAsset()) && Boolean(this._window.getAsset()) && Boolean(this._closeButton.getAsset()))
         {
            this.refreshData();
            _loc1_ = this._closeButton.getBounds(this.getAsset());
            _loc2_ = this._backgroundsBounds.right - _loc1_.x;
            _loc3_ = this._backgroundsBounds.top - _loc1_.y;
            this._closeButtonOffsetFromTopRight = new Point(_loc2_,_loc3_);
         }
      }
      
      public function setPopupWindowModel(param1:DynamicPopupWindowModel) : void
      {
         this._windowModel = param1;
         this.updateDisplay();
      }
      
      protected function addContent(param1:MovieClipProxy) : void
      {
         this.removeContent(param1);
         this._displayAnchor.addChild(param1);
         this._contentList.push(param1);
      }
      
      protected function removeContent(param1:MovieClipProxy) : void
      {
         this._displayAnchor.removeChild(param1);
         var _loc2_:int = this._contentList.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._contentList.splice(_loc2_,1);
         }
      }
      
      protected function updateDisplay() : void
      {
         var _loc1_:MovieClipProxy = null;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._contentList.length)
         {
            _loc1_ = this._contentList[_loc3_];
            _loc1_.setY(_loc2_);
            _loc2_ += _loc1_.getHeight() + this._contentYOffset;
            _loc3_++;
         }
         this.updateWindowSize(_loc2_);
         this.refreshData();
         this.updateWindowPosition();
      }
      
      private function updateWindowSize(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._windowModel.expandMode == DynamicPopupWindowModel.VECTICAL_EXPAND || this._windowModel.expandMode == DynamicPopupWindowModel.BOTH_DIRECTION_EXPAND)
         {
            if(param1 < this._minBounds.y - this._borderWindowOffset)
            {
               _loc2_ = this._minBounds.y;
            }
            else
            {
               _loc2_ = this._displayAnchor.getY() * 2 + param1 + this._borderWindowOffset;
            }
            this._background.setHeight(_loc2_);
         }
         if(this._windowModel.expandMode == DynamicPopupWindowModel.HORIZONTAL_EXPAND || this._windowModel.expandMode == DynamicPopupWindowModel.BOTH_DIRECTION_EXPAND)
         {
            if(this._displayAnchor.getWidth() < this._minBounds.x - this._borderWindowOffset)
            {
               _loc3_ = this._minBounds.x;
            }
            else
            {
               _loc3_ = this._displayAnchor.getX() * 2 + this._displayAnchor.getWidth() + this._borderWindowOffset;
            }
            this._background.setWidth(_loc3_);
            this.updateCloseButtonPosition();
         }
      }
      
      private function updateCloseButtonPosition() : void
      {
         this._closeButton.setX(this._popupWindowBounds.right - this._closeButtonOffsetFromTopRight.x);
         this._closeButton.setY(this._popupWindowBounds.top - this._closeButtonOffsetFromTopRight.y);
      }
      
      private function updateWindowPosition() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(!this._windowModel.lockCornerMode)
         {
            this.setArrow(-this._backgroundsBounds.width * 0.5,-this._backgroundsBounds.height * 0.5);
         }
         _loc3_ = this.getXOffset();
         _loc1_ = this._targetPosition.x + _loc3_;
         _loc4_ = this.getYOffset();
         _loc2_ = this._targetPosition.y + _loc4_;
         this.setX(_loc1_);
         this.setY(_loc2_);
         this.refreshData();
         this.setArrow(_loc3_,_loc4_);
      }
      
      private function getXOffset() : Number
      {
         var _loc1_:Number = 0;
         if(this._windowModel.lockCornerMode)
         {
            if(this._windowModel.calculateHorizontalFromLeftSide)
            {
               _loc1_ = this._windowModel.horizontalPositionOffset;
            }
            else
            {
               _loc1_ = -(this._popupWindowBounds.width + this._windowModel.horizontalPositionOffset);
            }
         }
         else if(this._windowModel.getAlignHorizontal())
         {
            _loc1_ = -(this._backgroundsBounds.width * 0.5);
         }
         else if(this._windowModel.widthRelativePosition == DynamicPopupWindowModel.WINDOW_POSITION_LEFT)
         {
            _loc1_ = -(this._targetBounds.width - (this._targetBounds.right - this._targetPosition.x)) - this._popupWindowBounds.width;
         }
         else if(this._windowModel.widthRelativePosition == DynamicPopupWindowModel.WINDOW_POSITION_RIGHT)
         {
            _loc1_ = this._targetBounds.width - (this._targetPosition.x - this._targetBounds.left);
         }
         return _loc1_;
      }
      
      private function getYOffset() : Number
      {
         var _loc1_:Number = 0;
         if(this._windowModel.lockCornerMode)
         {
            if(this._windowModel.calculateVecticalFromTop)
            {
               _loc1_ = this._windowModel.verticalPositionOffset;
            }
            else
            {
               _loc1_ = -(this._popupWindowBounds.height + this._windowModel.verticalPositionOffset);
            }
         }
         else if(this._windowModel.getAlignVertical())
         {
            _loc1_ = -(this._backgroundsBounds.height * 0.5);
         }
         else if(this._windowModel.widthRelativePosition == DynamicPopupWindowModel.WINDOW_POSITION_BOT)
         {
            _loc1_ = this._targetBounds.height - (this._targetPosition.y - this._targetBounds.top);
         }
         else if(this._windowModel.widthRelativePosition == DynamicPopupWindowModel.WINDOW_POSITION_TOP)
         {
            _loc1_ = -(this._targetBounds.height - (this._targetBounds.bottom - this._targetPosition.y)) - this._popupWindowBounds.height;
         }
         return _loc1_;
      }
      
      private function setArrow(param1:Number, param2:Number) : void
      {
         switch(this._windowModel.arrowPosition)
         {
            case DynamicPopupWindowModel.ARROW_POSITION_TOP:
               this._arrow.setRotationZ(0);
               this._arrow.setX(-param1);
               this._arrow.setY(this._backgroundsBounds.top);
               break;
            case DynamicPopupWindowModel.ARROW_POSITION_RIGHT:
               this._arrow.setRotationZ(90);
               this._arrow.setX(this._backgroundsBounds.right);
               this._arrow.setY(-param2);
               break;
            case DynamicPopupWindowModel.ARROW_POSITION_BOT:
               this._arrow.setRotationZ(180);
               this._arrow.setX(-param1);
               this._arrow.setY(this._backgroundsBounds.bottom);
               break;
            case DynamicPopupWindowModel.ARROW_POSITION_LEFT:
               this._arrow.setRotationZ(-90);
               this._arrow.setX(this._backgroundsBounds.left);
               this._arrow.setY(-param2);
         }
      }
      
      private function refreshData() : void
      {
         this._targetBounds = this.getTargetBounds(this._windowModel.target as MovieClipProxy);
         this._targetPosition = this.getTargetPosition();
         this._popupWindowBounds = this.getAssetBound(this);
         this._backgroundsBounds = this.getAssetBound(this._background);
      }
      
      private function getTargetPosition() : Point
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._windowModel.alignToTargetCenter)
         {
            _loc2_ = this._targetBounds.left + (this._targetBounds.right - this._targetBounds.left) * 0.5;
            _loc3_ = this._targetBounds.top + (this._targetBounds.bottom - this._targetBounds.top) * 0.5;
            _loc1_ = new Point(_loc2_,_loc3_);
         }
         else
         {
            _loc1_ = new Point(this._windowModel.target.getX(),this._windowModel.target.getY());
         }
         return _loc1_;
      }
      
      private function getTargetBounds(param1:MovieClipProxy) : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc4_:DisplayObjectContainerProxy = null;
         var _loc3_:Sprite = param1.getChildByInstanceName(this.TARGET_SIZER_LINKAGE) as Sprite;
         if(Boolean(_loc3_))
         {
            _loc4_ = param1.getParentDisplayContainer() as DisplayObjectContainerProxy;
            _loc2_ = _loc3_.getBounds(_loc4_.getAsset());
         }
         else
         {
            _loc2_ = this.getAssetBound(param1);
         }
         return _loc2_;
      }
      
      private function getAssetBound(param1:MovieClipProxy) : Rectangle
      {
         var _loc3_:Rectangle = null;
         var _loc2_:DisplayObjectContainerProxy = param1.getParentDisplayContainer() as DisplayObjectContainerProxy;
         if(Boolean(_loc2_))
         {
            _loc3_ = param1.getBounds(_loc2_.getAsset());
         }
         else
         {
            _loc3_ = new Rectangle();
         }
         return _loc3_;
      }
      
      protected function onCloseButtonClicked(param1:MouseEvent) : void
      {
      }
   }
}

