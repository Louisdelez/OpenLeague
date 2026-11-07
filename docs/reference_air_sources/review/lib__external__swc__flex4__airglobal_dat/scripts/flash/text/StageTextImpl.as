package flash.text
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   import flash.ui.*;
   
   [API("675")]
   [native(cls="StageTextImplClass",instance="StageTextImplObject",methods="auto",construct="native")]
   internal class StageTextImpl extends Sprite
   {
      
      public function StageTextImpl()
      {
         super();
         focusRect = false;
         tabIndex = -1;
         tabEnabled = true;
         addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onKeyFocusChange);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,int.MAX_VALUE);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,int.MAX_VALUE);
         this.addMyListeners();
      }
      
      private function onKeyFocusChange(evt:FocusEvent) : void
      {
         evt.preventDefault();
      }
      
      private function onKeyUp(evt:KeyboardEvent) : void
      {
         var stage:Stage = null;
         if(evt.keyCode == Keyboard.BACK || evt.keyCode == Keyboard.MENU || evt.keyCode == Keyboard.SEARCH)
         {
            stage = this.stage;
            if(Boolean(stage))
            {
               stage.dispatchEvent(evt);
            }
            evt.stopImmediatePropagation();
         }
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         var stage:Stage = null;
         var handled:Boolean = false;
         if(evt.keyCode == Keyboard.BACK || evt.keyCode == Keyboard.MENU || evt.keyCode == Keyboard.SEARCH)
         {
            stage = this.stage;
            if(Boolean(stage))
            {
               handled = stage.dispatchEvent(evt);
            }
            evt.stopImmediatePropagation();
            if(!handled)
            {
               evt.preventDefault();
            }
         }
      }
      
      private function addListenersForASImpl(st:StageText, obj:EventDispatcher) : void
      {
         this.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler);
         obj.addEventListener(FocusEvent.FOCUS_OUT,function(evt:Event):void
         {
            st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
         });
         obj.addEventListener(FocusEvent.FOCUS_IN,function(evt:Event):void
         {
            st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
         });
         obj.addEventListener(Event.CHANGE,function(evt:Event):void
         {
            st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
         });
         obj.addEventListener(KeyboardEvent.KEY_DOWN,function(evt:KeyboardEvent):void
         {
            var handled:Boolean = false;
            handled = st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
            if(!handled)
            {
               evt.preventDefault();
            }
         });
         obj.addEventListener(KeyboardEvent.KEY_UP,function(evt:Event):void
         {
            st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
         });
         obj.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,function(evt:Event):void
         {
            st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
         });
         obj.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,function(evt:SoftKeyboardEvent):void
         {
            var handled:Boolean = false;
            handled = st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
            if(!handled)
            {
               evt.preventDefault();
            }
         });
         obj.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,function(evt:Event):void
         {
            st.dispatchEvent(evt);
            evt.stopImmediatePropagation();
         });
      }
      
      private function addFullScreenListeners() : *
      {
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreenEvent);
      }
      
      private function removeFullScreenListeners() : *
      {
         stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreenEvent);
      }
      
      private function onFullScreenEvent(evt:Event) : *
      {
         this.onNativeDisplayStateChangeForStage();
      }
      
      private function focusOutHandler(evt:Event) : void
      {
         evt.stopImmediatePropagation();
         this.onNativeFocusOut();
      }
      
      private function addMyListeners() : void
      {
         addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler);
         addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,function(evt:SoftKeyboardEvent):void
         {
            evt.stopImmediatePropagation();
            onNativeSoftKeyboardActivate();
         });
         addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,function(evt:SoftKeyboardEvent):void
         {
            evt.stopImmediatePropagation();
            if(onNativeSoftKeyboardActivating())
            {
               evt.preventDefault();
            }
         });
         addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,function(evt:SoftKeyboardEvent):void
         {
            evt.stopImmediatePropagation();
            onNativeSoftKeyboardDeactivate(evt.triggerType);
         });
      }
      
      private native function onNativeFocusOut() : void;
      
      private native function onNativeSoftKeyboardActivate() : void;
      
      private native function onNativeSoftKeyboardActivating() : Boolean;
      
      private native function onNativeSoftKeyboardDeactivate(param1:String) : void;
      
      private native function onNativeDisplayStateChangeForStage() : void;
   }
}

