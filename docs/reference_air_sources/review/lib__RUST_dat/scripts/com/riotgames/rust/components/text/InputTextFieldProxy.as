package com.riotgames.rust.components.text
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.DisplayObject;
   import flash.events.FocusEvent;
   import flash.events.NativeDragEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.setTimeout;
   
   public class InputTextFieldProxy extends TextFieldProxy
   {
      
      private var _hintText:String;
      
      private var _hintTextColor:uint = 6710886;
      
      private var _showingHintText:Boolean = true;
      
      private var _useHintTextColor:Boolean = true;
      
      private var _originalTextColor:uint;
      
      private var _updatingHintText:Boolean = false;
      
      private var _hasFocus:Boolean = false;
      
      public var selectTextOnFocus:Boolean = true;
      
      public function InputTextFieldProxy(param1:IContext, param2:TextField = null)
      {
         super(param1,param2);
         setTextColor(this._hintTextColor);
         addEventListener(FocusEvent.FOCUS_IN,this.handleFocusIn);
         addEventListener(FocusEvent.FOCUS_OUT,this.handleFocusOut);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleTextDragDrop);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         var _loc2_:TextField = param1 as TextField;
         if(Boolean(_loc2_))
         {
            this._originalTextColor = _loc2_.textColor;
            if(this._showingHintText && this._useHintTextColor)
            {
               setTextColor(this._hintTextColor);
            }
            else
            {
               setTextColor(this._originalTextColor);
            }
            if(_loc2_.type != TextFieldType.INPUT)
            {
               throw new Error("Asset for InputTextFieldProxy isn\'t an input-type text field");
            }
         }
         super.configureAsset(param1);
      }
      
      override public function setText(param1:String) : void
      {
         if(!this._updatingHintText)
         {
            if(this._showingHintText && (param1 != "" && param1 != null))
            {
               this._showingHintText = false;
               setTextColor(this._originalTextColor);
            }
            else if((param1 == "" || param1 == null) && !this._hasFocus)
            {
               if(this._useHintTextColor)
               {
                  setTextColor(this._hintTextColor);
               }
               this._showingHintText = true;
               super.setText(this._hintText);
               return;
            }
         }
         super.setText(param1);
      }
      
      override public function getText() : String
      {
         if(this._showingHintText)
         {
            return "";
         }
         return super.getText();
      }
      
      public function setHintText(param1:String) : void
      {
         this._updatingHintText = true;
         this._hintText = param1;
         if(this._showingHintText)
         {
            this.setText(this._hintText);
         }
         this._updatingHintText = false;
      }
      
      public function getHintText() : String
      {
         return this._hintText;
      }
      
      public function setHintTextColor(param1:uint) : void
      {
         this._hintTextColor = param1;
         if(this._showingHintText && this._useHintTextColor)
         {
            setTextColor(this._hintTextColor);
         }
      }
      
      public function getHintTextColor() : uint
      {
         return this._hintTextColor;
      }
      
      public function useHintTextColor(param1:Boolean) : void
      {
         this._useHintTextColor = param1;
         if(this._showingHintText)
         {
            setTextColor(this._useHintTextColor ? this._hintTextColor : this._originalTextColor);
         }
      }
      
      private function handleFocusIn(param1:FocusEvent) : void
      {
         this._hasFocus = true;
         if(this._showingHintText)
         {
            this._updatingHintText = true;
            this._showingHintText = false;
            setTextColor(this._originalTextColor);
            this.setText("");
            this._updatingHintText = false;
         }
         if(this.selectTextOnFocus)
         {
            setTimeout(this.selectAllText,1);
         }
      }
      
      private function handleFocusOut(param1:FocusEvent) : void
      {
         this._hasFocus = false;
         if(this.getText() == "")
         {
            this.setText(this._hintText);
            if(this._useHintTextColor)
            {
               setTextColor(this._hintTextColor);
            }
            this._showingHintText = true;
         }
      }
      
      private function handleTextDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:Clipboard = null;
         var _loc3_:String = null;
         if(Boolean(this.getText()))
         {
            this.setText(Boolean(getMaxChars()) ? this.getText().substr(0,getMaxChars()) : this.getText());
         }
         else
         {
            _loc2_ = param1.clipboard;
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.getData(ClipboardFormats.TEXT_FORMAT) as String;
               if(Boolean(_loc3_))
               {
                  this.setText(Boolean(getMaxChars()) ? _loc3_.substr(0,getMaxChars()) : _loc3_);
               }
            }
         }
      }
      
      private function selectAllText() : void
      {
         setSelection(0,this.getText().length);
      }
      
      override public function destroy() : void
      {
         removeEventListener(FocusEvent.FOCUS_IN,this.handleFocusIn);
         removeEventListener(FocusEvent.FOCUS_OUT,this.handleFocusOut);
         removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.handleTextDragDrop);
         super.destroy();
      }
   }
}

