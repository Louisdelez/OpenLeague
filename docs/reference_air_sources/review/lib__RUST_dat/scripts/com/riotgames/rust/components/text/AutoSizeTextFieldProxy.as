package com.riotgames.rust.components.text
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   
   public class AutoSizeTextFieldProxy extends TextFieldProxy
   {
      
      public static const ALLOW_LINE_BREAK_MODE:String = "ALLOW_LINE_BREAK_MODE";
      
      public static const SINGLE_LINE_MODE:String = "SINGLE_LINE_MODE";
      
      public static const SCALED:String = "SCALED";
      
      public static const NOT_TOUCHED:String = "NOT_TOUCHED";
      
      public static var styleGroups:Dictionary = new Dictionary(true);
      
      private var _desiredBounds:Rectangle;
      
      private var _fullTextBounds:Rectangle;
      
      private var _defaultTextAutoSize:String;
      
      private var _lineMode:String = "SINGLE_LINE_MODE";
      
      private var _styleGroup:int = -1;
      
      public var left_padding:Number = 0;
      
      public var right_padding:Number = 0;
      
      public var top_padding:Number = 0;
      
      public var bottom_padding:Number = 0;
      
      public var DEBUG_MODE:Boolean = false;
      
      public function AutoSizeTextFieldProxy(param1:IContext, param2:TextField = null)
      {
         super(param1,param2);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         _textField = param1 as TextField;
         if(_textField != null)
         {
            this._defaultTextAutoSize = _textField.autoSize;
         }
         this.captureBounds();
      }
      
      public function captureBounds() : void
      {
         if(_textField != null && _textField.parent != null)
         {
            this._desiredBounds = _textField.getBounds(_textField.parent);
            this._desiredBounds.width = this._desiredBounds.width - this.left_padding - this.right_padding;
            this._desiredBounds.x += this.left_padding;
            this._desiredBounds.height = this._desiredBounds.height - this.top_padding - this.bottom_padding;
            this._desiredBounds.y += this.top_padding;
         }
      }
      
      public function setSingleLineMode() : void
      {
         this._lineMode = SINGLE_LINE_MODE;
      }
      
      public function setAllowLineBreakMode() : void
      {
         this._lineMode = ALLOW_LINE_BREAK_MODE;
      }
      
      override public function invalidateLayout() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:TextFormat = null;
         if(_textField != null)
         {
            if(this._desiredBounds == null)
            {
               this.captureBounds();
            }
            _loc1_ = Boolean(_textField.visible);
            _textField.visible = false;
            _textField.autoSize = TextFieldAutoSize.LEFT;
            _textField.scaleX = 1;
            _textField.scaleY = 1;
            _textField.wordWrap = false;
            this._fullTextBounds = _textField.getBounds(_textField.parent);
            _loc2_ = this._desiredBounds.width - this._fullTextBounds.width;
            _loc3_ = this._desiredBounds.height - this._fullTextBounds.height;
            if(_loc2_ < 0 || _loc3_ < 0)
            {
               this.visualizeDebug("SCALED");
               if(_loc2_ > _loc3_)
               {
                  _loc4_ = "H";
               }
               else if(_loc2_ < _loc3_)
               {
                  _loc4_ = "W";
               }
               else if(_loc2_ == _loc3_)
               {
                  _loc4_ = "F";
               }
               if(_loc4_ == "W")
               {
                  _textField.scaleX = this._desiredBounds.width / _textField.width;
                  _textField.scaleY = _textField.scaleX;
               }
               else if(_loc4_ == "H")
               {
                  _textField.scaleY = this._desiredBounds.height / _textField.height;
                  _textField.scaleX = _textField.scaleY;
               }
               else
               {
                  _textField.scaleX = this._desiredBounds.width / _textField.width;
                  _textField.scaleY = _textField.scaleX;
               }
               _loc5_ = getTextFormat();
               switch(_loc5_.align)
               {
                  case TextFormatAlign.LEFT:
                     _textField.x = this._desiredBounds.x;
                     break;
                  case TextFormatAlign.RIGHT:
                     _textField.x = this._desiredBounds.right - _textField.width;
                     break;
                  case TextFormatAlign.CENTER:
                  default:
                     _textField.x = this._desiredBounds.x + (this._desiredBounds.width / 2 - _textField.width / 2);
               }
               _textField.y = this._desiredBounds.y + (this._desiredBounds.height - _textField.height) / 2;
            }
            else
            {
               this.visualizeDebug("NOT_TOUCHED");
               _textField.autoSize = this._defaultTextAutoSize;
               _textField.width = this._desiredBounds.width;
               _textField.height = this._desiredBounds.height;
            }
            _textField.visible = _loc1_;
         }
         super.invalidateLayout();
      }
      
      public function visualizeDebug(param1:String = "NOT_TOUCHED") : void
      {
         var _loc2_:Sprite = null;
         if(this.DEBUG_MODE)
         {
            switch(param1)
            {
               case SCALED:
                  _textField.borderColor = 16711680;
                  _textField.border = true;
                  break;
               case NOT_TOUCHED:
                  _textField.borderColor = 65280;
                  _textField.border = true;
            }
            _textField.selectable = true;
            _loc2_ = new Sprite();
            _loc2_.graphics.beginFill(_textField.borderColor,0.1);
            _loc2_.graphics.drawRect(0,0,this._desiredBounds.width,this._desiredBounds.height);
            _loc2_.graphics.endFill();
            if(param1 != NOT_TOUCHED)
            {
               _loc2_.graphics.beginFill(_textField.borderColor,0.1);
               _loc2_.graphics.drawRect(this._desiredBounds.width,0,this._fullTextBounds.width,this._fullTextBounds.height);
               _loc2_.graphics.endFill();
            }
            _loc2_.x = this._desiredBounds.x;
            _loc2_.y = this._desiredBounds.y;
            _textField.parent.addChild(_loc2_);
         }
      }
      
      public function get styleGroup() : int
      {
         return this._styleGroup;
      }
      
      public function set styleGroup(param1:int) : void
      {
         this._styleGroup = param1;
      }
   }
}

