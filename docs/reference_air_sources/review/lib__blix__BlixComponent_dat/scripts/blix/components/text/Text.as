package blix.components.text
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.scroll.ScrollModel;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.model.ITextModel;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Text extends TextFieldProxy
   {
      
      public static const TEXT_WIDTH_PADDING:int = 5;
      
      public static const TEXT_HEIGHT_PADDING:int = 4;
      
      public var showToolTipOnTruncation:Boolean = true;
      
      protected var _textModel:ITextModel;
      
      protected var _isTextModelHtml:Boolean;
      
      protected var _horizontalScrollModel:ScrollModel;
      
      protected var _verticalScrollModel:ScrollModel;
      
      protected var _text:String;
      
      protected var _htmlText:String;
      
      protected var _textDecorators:Vector.<Function> = new Vector.<Function>();
      
      protected var _truncateToFit:Boolean = false;
      
      protected var _showingToolTip:Boolean = false;
      
      protected var _truncationIndicator:String = "...";
      
      protected var isValidatingScroll:Boolean = false;
      
      public function Text(param1:IContext, param2:TextField = null)
      {
         super(param1,param2);
         this.initializeScrollModel();
      }
      
      private function initializeScrollModel() : void
      {
         if(this._horizontalScrollModel == null)
         {
            this.setHorizontalScrollModel(new ScrollModel());
         }
         if(this._verticalScrollModel == null)
         {
            this.setVerticalScrollModel(new ScrollModel());
         }
         addEventListener(Event.SCROLL,this.scrollHandler);
      }
      
      protected function scrollHandler(param1:Event) : void
      {
         if(this.isValidatingScroll)
         {
            return;
         }
         if(this._verticalScrollModel != null)
         {
            this._verticalScrollModel.setValue(getScrollV());
         }
         if(this._horizontalScrollModel != null)
         {
            this._horizontalScrollModel.setValue(getScrollH());
         }
      }
      
      public function getHorizontalScrollModel() : ScrollModel
      {
         return this._horizontalScrollModel;
      }
      
      public function setHorizontalScrollModel(param1:ScrollModel) : void
      {
         if(this._horizontalScrollModel != null)
         {
            this._horizontalScrollModel.getChanged().remove(invalidateLayout);
         }
         this._horizontalScrollModel = param1;
         if(this._horizontalScrollModel != null)
         {
            this._horizontalScrollModel.setMax(getMaxScrollH());
            this._horizontalScrollModel.getChanged().add(invalidateLayout);
            invalidateLayout();
         }
      }
      
      public function getVerticalScrollModel() : ScrollModel
      {
         return this._verticalScrollModel;
      }
      
      public function setVerticalScrollModel(param1:ScrollModel) : void
      {
         if(this._verticalScrollModel != null)
         {
            this._verticalScrollModel.getChanged().remove(invalidateLayout);
         }
         this._verticalScrollModel = param1;
         if(this._verticalScrollModel != null)
         {
            this._verticalScrollModel.setMax(getMaxScrollV());
            this._verticalScrollModel.getChanged().add(invalidateLayout);
            invalidateLayout();
         }
      }
      
      override public function setScrollH(param1:int) : void
      {
         this._horizontalScrollModel.setValue(param1);
      }
      
      override public function setScrollV(param1:int) : void
      {
         this._verticalScrollModel.setValue(param1);
      }
      
      public function getTextDecorators() : Vector.<Function>
      {
         return this._textDecorators.slice();
      }
      
      public function setTextDecorators(param1:Vector.<Function>) : void
      {
         this._textDecorators = param1;
         this.refreshText();
      }
      
      public function addTextDecorator(param1:Function) : void
      {
         this.removeTextDecorator(param1);
         this._textDecorators[this._textDecorators.length] = param1;
         this.refreshText();
      }
      
      public function removeTextDecorator(param1:Function) : Boolean
      {
         var _loc2_:int = this._textDecorators.indexOf(param1);
         if(_loc2_ == -1)
         {
            return false;
         }
         this._textDecorators.splice(_loc2_,1);
         this.refreshText();
         return true;
      }
      
      public function getTextModel() : ITextModel
      {
         return this._textModel;
      }
      
      protected function unconfigureTextModel() : void
      {
         if(this._textModel != null)
         {
            this._textModel.getTextChanged().remove(this.textModelChangedHandler);
            this._textModel = null;
         }
      }
      
      protected function configureTextModel() : void
      {
         if(this._textModel != null)
         {
            this._textModel.getTextChanged().add(this.textModelChangedHandler);
         }
      }
      
      public function setTextModel(param1:ITextModel, param2:Boolean = false) : void
      {
         if(this._textModel == param1)
         {
            return;
         }
         this.unconfigureTextModel();
         this._textModel = param1;
         this._isTextModelHtml = param2;
         this.configureTextModel();
         this.textModelChangedHandler();
      }
      
      protected function textModelChangedHandler() : void
      {
         if(this._textModel != null)
         {
            if(!this._isTextModelHtml)
            {
               this._text = this._textModel.getText();
               this._htmlText = null;
            }
            else
            {
               this._htmlText = this._textModel.getText();
               this._text = null;
            }
         }
         this.refreshText();
      }
      
      protected function refreshText() : void
      {
         var _loc1_:String = null;
         var _loc2_:Function = null;
         if(Boolean(this._htmlText))
         {
            _loc1_ = this._htmlText;
         }
         else if(this._text != null)
         {
            _loc1_ = this._text;
         }
         if(_loc1_ == null)
         {
            _loc1_ = "";
         }
         for each(_loc2_ in this._textDecorators)
         {
            _loc1_ = _loc2_(_loc1_);
         }
         if(Boolean(this._htmlText))
         {
            super.setHtmlText(_loc1_);
         }
         else
         {
            super.setText(_loc1_);
         }
      }
      
      override public function setText(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this.unconfigureTextModel();
         this._htmlText = null;
         this._text = param1;
         this.refreshText();
      }
      
      override public function setHtmlText(param1:String) : void
      {
         if(this._htmlText == param1)
         {
            return;
         }
         this.unconfigureTextModel();
         this._text = null;
         this._htmlText = param1;
         this.refreshText();
      }
      
      public function getTruncateToFit() : Boolean
      {
         return this._truncateToFit;
      }
      
      public function setTruncateToFit(param1:Boolean) : void
      {
         if(param1 == this._truncateToFit)
         {
            return;
         }
         this._truncateToFit = param1;
         if(!param1)
         {
            if(_textField != null && this._text != null && _textField.text != this._text)
            {
               _textField.text = this._text;
            }
         }
         invalidateLayout();
      }
      
      public function getTruncationIndicator() : String
      {
         return this._truncationIndicator;
      }
      
      public function setTruncationIndicator(param1:String) : void
      {
         if(this._truncationIndicator == param1)
         {
            return;
         }
         this._truncationIndicator = param1;
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc4_:Boolean = false;
         if(!isNaN(param1))
         {
            setWidth(param1);
         }
         if(!isNaN(param2))
         {
            setHeight(param2);
         }
         if(_textField != null)
         {
            _textField.getCharBoundaries(0);
            _loc4_ = false;
            if(this._truncateToFit && _textField.autoSize == TextFieldAutoSize.NONE && this._text != null)
            {
               _textField.text = this._text;
               if(_textField.textWidth + TEXT_WIDTH_PADDING > _textField.width + 1e-14 || Boolean(_textField.multiline) && _textField.textHeight + TEXT_HEIGHT_PADDING > _textField.height + 1e-14)
               {
                  this.truncateText(this._text,this._truncationIndicator,0,this._text.length);
                  if(this.showToolTipOnTruncation)
                  {
                     _loc4_ = true;
                  }
               }
            }
         }
         if(this._showingToolTip != _loc4_)
         {
            if(_loc4_)
            {
               assignToolTip(this,this._text);
            }
            else
            {
               unassignToolTip(this);
            }
            this._showingToolTip = _loc4_;
         }
         this.validateScroll();
         return _asset.getBounds(null);
      }
      
      protected function validateScroll() : void
      {
         this.isValidatingScroll = true;
         if(_textField != null)
         {
            if(Boolean(this._horizontalScrollModel))
            {
               this._horizontalScrollModel.setMax(getMaxScrollH());
               _textField.scrollH = Math.round(this._horizontalScrollModel.getClampedValue());
            }
            if(Boolean(this._verticalScrollModel))
            {
               this._verticalScrollModel.setMax(getMaxScrollV());
               _textField.scrollV = Math.round(this._verticalScrollModel.getClampedValue());
            }
         }
         this.isValidatingScroll = false;
      }
      
      private function truncateText(param1:String, param2:String, param3:uint, param4:uint) : void
      {
         if(param3 == param4)
         {
            _textField.text = param1.substr(0,param4) + param2;
            return;
         }
         var _loc5_:uint = Math.ceil((param3 + param4) / 2);
         _textField.text = param1.substr(0,_loc5_) + param2;
         if(_textField.textWidth + TEXT_WIDTH_PADDING > _textField.width + 1e-14 || Boolean(_textField.multiline) && _textField.textHeight + TEXT_HEIGHT_PADDING > _textField.height + 1e-14)
         {
            this.truncateText(param1,param2,param3,_loc5_ - 1);
         }
         else
         {
            this.truncateText(param1,param2,_loc5_,param4);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.setTextModel(null);
         this.setHorizontalScrollModel(null);
         this.setVerticalScrollModel(null);
         if(this._showingToolTip)
         {
            unassignToolTip(this);
            this._showingToolTip = false;
         }
         this._textDecorators = null;
      }
   }
}

