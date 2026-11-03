package flash.media
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   import flash.ui.*;
   
   [API("669")]
   [native(cls="StageWebViewImplClass",instance="StageWebViewImplObject",methods="auto",construct="native")]
   internal class StageWebViewImpl extends Sprite
   {
      
      public function StageWebViewImpl()
      {
         super();
         focusRect = false;
         tabIndex = -1;
         tabEnabled = true;
         addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.onKeyFocusChange);
         addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,int.MAX_VALUE);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,int.MAX_VALUE);
      }
      
      private function onKeyFocusChange(evt:FocusEvent) : void
      {
         evt.preventDefault();
      }
      
      private function onFocusOut(ev:FocusEvent) : void
      {
         if(Boolean(ev.relatedObject) && Boolean(contains(ev.relatedObject)))
         {
            if(Boolean(stage))
            {
               stage.focus = this;
            }
         }
         else
         {
            this.onNativeFocusOut();
         }
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
      
      private native function onNativeFocusOut() : void;
   }
}

