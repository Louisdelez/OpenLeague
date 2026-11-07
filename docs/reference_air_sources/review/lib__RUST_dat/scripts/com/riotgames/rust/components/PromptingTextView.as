package com.riotgames.rust.components
{
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.signals.Signal;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class PromptingTextView extends Text
   {
      
      public var promptText:String;
      
      public var promptColor:uint = 8947848;
      
      private var showingPrompt:Boolean = false;
      
      private var textColor:uint;
      
      public var onEnterPressed:Signal = new Signal();
      
      public var onTextChanged:Signal = new Signal();
      
      public function PromptingTextView(param1:Context)
      {
         super(param1);
         getAssetChanged().add(this.onAssetChanged);
         addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         addEventListener(Event.CHANGE,this.onChange);
      }
      
      private function onAssetChanged() : void
      {
         if(_asset is TextField)
         {
            this.showPrompt();
         }
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         var _loc2_:TextField = param1 as TextField;
         if(Boolean(_loc2_))
         {
            this.textColor = this.getColor(_loc2_);
         }
         super.configureAsset(param1);
      }
      
      public function setPrompt(param1:String, param2:uint) : void
      {
         this.promptText = param1;
         this.promptColor = param2;
         this.showPrompt();
      }
      
      public function showPrompt() : void
      {
         setTextColor(this.promptColor);
         setText(this.promptText);
         this.showingPrompt = true;
      }
      
      public function hidePrompt() : void
      {
         if(this.showingPrompt)
         {
            setTextColor(this.textColor);
            setText("");
            this.showingPrompt = false;
         }
      }
      
      public function get isShowingPrompt() : Boolean
      {
         return this.showingPrompt;
      }
      
      private function onFocusIn(param1:FocusEvent) : void
      {
         this.hidePrompt();
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         var _loc2_:TextField = _asset as TextField;
         if(Boolean(_loc2_) && _loc2_.text.length == 0)
         {
            this.showPrompt();
         }
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onEnterPressed.dispatch(this,(_asset as TextField).text);
         }
      }
      
      private function onChange(param1:Event) : void
      {
         this.onTextChanged.dispatch(this,(_asset as TextField).text);
      }
      
      private function getColor(param1:TextField) : uint
      {
         if(param1.defaultTextFormat.color == null)
         {
            return 0;
         }
         return Number(param1.defaultTextFormat.color);
      }
      
      override public function getText() : String
      {
         if(_text != this.promptText)
         {
            return super.getText();
         }
         return "";
      }
   }
}

