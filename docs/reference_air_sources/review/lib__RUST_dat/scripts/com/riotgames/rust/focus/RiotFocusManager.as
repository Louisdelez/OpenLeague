package com.riotgames.rust.focus
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.frame.getEnterFrame;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.NativeWindowDisplayState;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class RiotFocusManager
   {
      
      private static var pendingFocus:InteractiveObjectProxy;
      
      private static var pendingShowHighlight:Boolean;
      
      private static var stageFocusManagersDict:Dictionary = new Dictionary(true);
      
      private var focusHighlight:DisplayObjectProxy;
      
      private var stage:Stage;
      
      public function RiotFocusManager(param1:DisplayObjectProxy)
      {
         super();
         this.focusHighlight = param1;
         param1.setVisible(false);
      }
      
      public static function getPendingFocus() : InteractiveObjectProxy
      {
         return pendingFocus;
      }
      
      public static function setFocus(param1:InteractiveObjectProxy, param2:Boolean = false) : void
      {
         if(Boolean(pendingFocus))
         {
            pendingFocus.getIsOnStageChanged().remove(refreshFocus);
         }
         pendingFocus = param1;
         pendingShowHighlight = param2;
         if(pendingFocus != null)
         {
            if(pendingFocus.getIsOnStage())
            {
               refreshFocus();
            }
            else
            {
               pendingFocus.getIsOnStageChanged().addOnce(refreshFocus);
            }
         }
      }
      
      private static function refreshFocus() : void
      {
         var stage:Stage = null;
         var focusManager:RiotFocusManager = null;
         var pendingFocusBug:InteractiveObjectProxy = null;
         if(pendingFocus == null)
         {
            return;
         }
         if(pendingFocus.getIsOnStage())
         {
            stage = pendingFocus.getStage();
            if(!stage.nativeWindow.closed && Boolean(stage.nativeWindow.visible))
            {
               if(stage.nativeWindow.active)
               {
                  stage.focus = pendingFocus.getInteractiveAsset();
               }
               else if(stage.nativeWindow.displayState == NativeWindowDisplayState.NORMAL || stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
               {
                  stage.nativeWindow.activate();
                  pendingFocusBug = pendingFocus;
                  getEnterFrame().addOnce(function():void
                  {
                     if(pendingFocus == null)
                     {
                        stage.focus = pendingFocusBug.getInteractiveAsset();
                     }
                  });
               }
               focusManager = stageFocusManagersDict[stage];
               if(focusManager != null)
               {
                  if(pendingShowHighlight)
                  {
                     focusManager.showFocusHighlight();
                  }
                  else
                  {
                     focusManager.hideFocusHighlight();
                  }
               }
            }
            pendingFocus = null;
         }
      }
      
      public function watch(param1:InteractiveObject) : void
      {
         if(Boolean(param1.stage))
         {
            this.configureStage(param1.stage);
         }
         else
         {
            param1.addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         }
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         var _loc2_:InteractiveObject = InteractiveObject(param1.currentTarget);
         _loc2_.removeEventListener(param1.type,this.addedToStageHandler);
         this.configureStage(_loc2_.stage);
      }
      
      private function configureStage(param1:Stage) : void
      {
         stageFocusManagersDict[param1] = this;
         this.stage = param1;
         param1.stageFocusRect = false;
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         param1.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
         param1.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler);
         refreshFocus();
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(this.stage.focus != null && (param1.keyCode == Keyboard.SPACE || param1.keyCode == Keyboard.ENTER))
         {
            if(!this.stage.focus.hasEventListener(KeyboardEvent.KEY_UP) && !this.stage.focus.hasEventListener(KeyboardEvent.KEY_DOWN))
            {
               this.stage.focus.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
      }
      
      private function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         this.showFocusHighlight();
      }
      
      private function mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         this.hideFocusHighlight();
      }
      
      public function showFocusHighlight() : void
      {
         this.focusHighlight.setVisible(false);
         getEnterFrame().add(this.updateSelectionHighlight);
      }
      
      public function hideFocusHighlight() : void
      {
         getEnterFrame().remove(this.updateSelectionHighlight);
         this.focusHighlight.setVisible(false);
      }
      
      private function updateSelectionHighlight() : void
      {
         var _loc1_:InteractiveObject = this.stage.focus;
         if(_loc1_ == null || _loc1_.stage == null)
         {
            this.hideFocusHighlight();
            return;
         }
         if(this.focusHighlight.getAsset() == null || this.focusHighlight.getAsset().parent == null)
         {
            return;
         }
         var _loc2_:DisplayObjectContainer = this.focusHighlight.getAsset().parent;
         var _loc3_:Rectangle = _loc1_.getBounds(_loc2_);
         this.focusHighlight.setVisible(this.getConcatenatedVisible(_loc1_));
         this.focusHighlight.setAlpha(this.getConcatenatedAlpha(_loc1_));
         this.focusHighlight.setExplicitSize(_loc3_.width,_loc3_.height);
         this.focusHighlight.setExplicitPosition(_loc3_.x,_loc3_.y);
      }
      
      private function getConcatenatedAlpha(param1:DisplayObject) : Number
      {
         var _loc2_:Number = param1.alpha;
         var _loc3_:DisplayObjectContainer = param1.parent;
         while(Boolean(_loc3_))
         {
            _loc2_ *= _loc3_.alpha;
            _loc3_ = _loc3_.parent;
         }
         return _loc2_;
      }
      
      private function getConcatenatedVisible(param1:DisplayObject) : Boolean
      {
         if(!param1.visible)
         {
            return false;
         }
         var _loc2_:DisplayObjectContainer = param1.parent;
         while(Boolean(_loc2_))
         {
            if(!_loc2_.visible)
            {
               return false;
            }
            _loc2_ = _loc2_.parent;
         }
         return true;
      }
   }
}

