package com.riotgames.platform.gameclient.components.text
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.text.Text;
   import blix.components.text.TextScroller;
   import blix.context.IContext;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   
   public class ExpandingTextScroller extends TextScroller
   {
      
      private var _altNewline:Boolean = false;
      
      public var clear:Signal = new Signal();
      
      private var _autoClear:Boolean = false;
      
      private var numLines:uint = 0;
      
      private var clearIsValidFlag:Boolean = true;
      
      private var textBorder:SpriteProxy;
      
      private var _maxLinesExpanded:uint = 3;
      
      private var textBackground:SpriteProxy;
      
      public function ExpandingTextScroller(param1:IContext)
      {
         super(param1);
      }
      
      private function textViewChangedHandler(param1:Text, param2:TextField, param3:TextField) : void
      {
         if(Boolean(param3))
         {
            _padding.left = param3.x;
            _padding.top = param3.y;
         }
         invalidateLayout();
      }
      
      override public function setHtmlText(param1:String) : void
      {
         super.setHtmlText(param1);
         this.clearIsValidFlag = true;
         invalidateLayout();
      }
      
      public function getMaxLinesExpanded() : uint
      {
         return this._maxLinesExpanded;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.updateTextView(param1);
         return super.updateLayout(param1,this.textBorder.getExplicitSize().y);
      }
      
      public function setMaxLinesExpanded(param1:uint) : void
      {
         this._maxLinesExpanded = param1;
         invalidateLayout();
      }
      
      public function getIsInput() : Boolean
      {
         return _textView.getType() == TextFieldType.INPUT;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.textBackground = new SpriteProxy(this);
         this.textBackground.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("textBackground",this.textBackground);
         this.textBorder = new SpriteProxy(this);
         this.textBorder.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("textBorder",this.textBorder);
         _textView.setAutoSize(TextFieldAutoSize.NONE);
         _textView.setVerticalScrollEnabled(true);
         _textView.getAssetChanged().add(this.textViewChangedHandler);
         setVScrollPolicy(ScrollPolicy.ON);
      }
      
      public function setAutoClear(param1:Boolean) : void
      {
         this._autoClear = param1;
         this.setIsInput(true);
      }
      
      public function getAltNewline() : Boolean
      {
         return this._altNewline;
      }
      
      public function getAutoClear() : Boolean
      {
         return this._autoClear;
      }
      
      public function clearText() : void
      {
         this.clearIsValidFlag = false;
         invalidateLayout();
      }
      
      private function updateTextView(param1:Number) : void
      {
         var _loc3_:TextLineMetrics = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:int = int(_textView.getNumLines());
         if(!this.clearIsValidFlag)
         {
            this.clearIsValidFlag = true;
            _loc2_ = 1;
            _textView.setText("**");
            _textView.setText("");
         }
         if(this.numLines != _loc2_)
         {
            this.numLines = _loc2_;
            if(_loc2_ > 0)
            {
               _loc2_ = Math.min(this._maxLinesExpanded,_loc2_);
               _loc3_ = _textView.getLineMetrics(0);
               _loc4_ = Math.ceil(_loc2_ * _loc3_.height) + 4;
               _textView.setExplicitSize(param1 - 6,_loc4_);
               _loc5_ = Math.round(_padding.top - this.textBackground.getY());
               this.textBackground.setExplicitSize(param1 - 6,_loc4_ + 2 * _loc5_);
               _loc5_ = Math.round(_padding.top - this.textBorder.getY());
               this.textBorder.setExplicitSize(param1 - 2,_loc4_ + 2 * _loc5_);
            }
         }
      }
      
      public function setAltNewline(param1:Boolean) : void
      {
         this._altNewline = param1;
         this.setIsInput(true);
      }
      
      override public function setText(param1:String) : void
      {
         super.setText(param1);
         this.clearIsValidFlag = true;
         invalidateLayout();
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            _loc2_ = _textView.getText();
            _loc3_ = int(_textView.getSelectionBeginIndex());
            _loc4_ = _loc3_;
            _loc5_ = _loc2_.charAt(--_loc3_);
            while(_loc5_ == "\n" || _loc5_ == "\r")
            {
               _loc5_ = _loc2_.charAt(--_loc3_);
            }
            _loc2_ = _loc2_.substring(0,++_loc3_) + _loc2_.substring(_loc4_);
            _textView.setText(_loc2_);
            switch(true)
            {
               case param1.shiftKey:
               case param1.controlKey:
                  break;
               case param1.altKey:
                  if(this._altNewline)
                  {
                     _loc2_ = _loc2_.substring(0,_loc3_) + "\n" + _loc2_.substring(_loc3_);
                     _textView.setText(_loc2_);
                     _textView.setSelection(++_loc3_,_loc3_);
                     invalidateLayout();
                  }
                  break;
               default:
                  if(this._autoClear)
                  {
                     if(_loc2_.length > 0)
                     {
                        this.clear.dispatch();
                     }
                     this.clearText();
                  }
            }
         }
         else
         {
            invalidateLayout();
         }
      }
      
      private function textInputHandler(param1:Event) : void
      {
         invalidateLayout();
      }
      
      public function setIsInput(param1:Boolean) : void
      {
         _textView.setType(param1 ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
         _textView.setSelectable(param1);
         if(this._autoClear || this._altNewline)
         {
            _textView.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            _textView.addEventListener(TextEvent.TEXT_INPUT,this.textInputHandler);
         }
         else
         {
            _textView.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            _textView.removeEventListener(TextEvent.TEXT_INPUT,this.textInputHandler);
         }
      }
   }
}

