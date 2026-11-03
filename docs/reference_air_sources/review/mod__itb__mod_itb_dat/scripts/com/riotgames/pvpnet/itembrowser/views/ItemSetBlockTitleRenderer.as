package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ItemSetBlockTitleRenderer extends ButtonX
   {
      
      private var _textChanged:Signal = new Signal();
      
      private var _isEditingChanged:Signal = new Signal();
      
      private var editing:Boolean = false;
      
      private var title:TextFieldProxy;
      
      public function ItemSetBlockTitleRenderer(param1:IContext)
      {
         super(param1);
         this.refreshState();
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         if(!this.editing)
         {
            super.clickHandler(param1);
            this.startEditing();
         }
      }
      
      public function getText() : String
      {
         return this.title.getText();
      }
      
      public function getIsEditing() : Boolean
      {
         return this.editing;
      }
      
      private function startKeyListener() : void
      {
         this.title.addEventListener(FocusEvent.FOCUS_OUT,this.stopEditing);
         this.title.addEventListener(KeyboardEvent.KEY_DOWN,this.keyHandler);
         this.title.addEventListener(Event.CHANGE,this.titleChangeHandler);
      }
      
      private function keyHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NUMPAD_ENTER)
         {
            this.stopEditing();
         }
      }
      
      public function stopEditing(param1:Event = null) : void
      {
         this.editing = false;
         this._isEditingChanged.dispatch(this);
         this.refreshState();
      }
      
      public function setText(param1:String) : void
      {
         this.title.setText(param1);
         this.stopEditing();
      }
      
      public function getTextChanged() : ISignal
      {
         return this._textChanged;
      }
      
      override protected function refreshState() : void
      {
         if(this.editing)
         {
            if(_currentState != "edit")
            {
               setCurrentState("edit");
               setUseHandCursor(false);
               setMouseChildren(true);
               this.startKeyListener();
               RiotFocusManager.setFocus(this.title);
               this.title.setSelection(0,this.title.getText().length);
            }
         }
         else
         {
            super.refreshState();
            setUseHandCursor(true);
            setMouseChildren(false);
            this.stopKeyListener();
         }
      }
      
      private function titleChangeHandler(param1:Event) : void
      {
         this._textChanged.dispatch(this,this.title.getText());
      }
      
      override protected function createChildren() : void
      {
         this.title = new TextFieldProxy(this);
         setTimelineChildByName("blockTitleText",this.title);
         this.title.setMaxChars(50);
      }
      
      public function getIsEditingChanged() : ISignal
      {
         return this._isEditingChanged;
      }
      
      public function startEditing(param1:Event = null) : void
      {
         this.editing = true;
         this._isEditingChanged.dispatch(this);
         this.refreshState();
      }
      
      private function stopKeyListener() : void
      {
         this.title.removeEventListener(FocusEvent.FOCUS_OUT,this.stopEditing);
         this.title.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyHandler);
         this.title.removeEventListener(Event.CHANGE,this.titleChangeHandler);
      }
   }
}

