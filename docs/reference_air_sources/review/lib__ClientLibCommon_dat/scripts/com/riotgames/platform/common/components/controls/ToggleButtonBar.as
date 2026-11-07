package com.riotgames.platform.common.components.controls
{
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.controls.ToggleButtonBar;
   import mx.core.IFlexDisplayObject;
   import mx.events.ItemClickEvent;
   
   public class ToggleButtonBar extends mx.controls.ToggleButtonBar
   {
      
      private var _onPrompt:Function = null;
      
      public var mouseOverKey:String = "SOUND_MOUSE_OVER";
      
      private var _pendingClickEvent:MouseEvent;
      
      public var mouseClickKey:String = "SOUND_MOUSE_DOWN";
      
      public var disabledOverKey:String = "SOUND_MOUSE_OVER_DISABLED";
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      private var _pendingSelectedIndex:int = -1;
      
      public function ToggleButtonBar()
      {
         super();
         addEventListener(ItemClickEvent.ITEM_CLICK,this.soundClickHandler);
      }
      
      override protected function initializationComplete() : void
      {
         super.initializationComplete();
      }
      
      public function get onPrompt() : Function
      {
         return this._onPrompt;
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         var _loc3_:Button = null;
         var _loc2_:int = int(getChildIndex(Button(param1.currentTarget)));
         if(_loc2_ == selectedIndex)
         {
            super.clickHandler(param1);
            return;
         }
         this._pendingSelectedIndex = _loc2_;
         param1.stopImmediatePropagation();
         this._pendingClickEvent = param1;
         if(this.onPrompt != null)
         {
            _loc3_ = getChildAt(this._pendingSelectedIndex) as Button;
            _loc3_.selected = false;
            this.onPrompt(this.onPromptComplete);
         }
         else
         {
            this.onPromptComplete(true);
         }
      }
      
      public function set onPrompt(param1:Function) : void
      {
         this._onPrompt = param1;
      }
      
      protected function soundClickHandler(param1:ItemClickEvent) : void
      {
         if(this.enabled)
         {
            this.soundManager.play(this.mouseClickKey);
         }
      }
      
      protected function onPromptComplete(param1:Boolean = true) : void
      {
         if(param1)
         {
            if(Boolean(this._pendingClickEvent))
            {
               super.clickHandler(this._pendingClickEvent);
               this._pendingSelectedIndex = -1;
               this._pendingClickEvent = null;
            }
         }
         else
         {
            this._pendingSelectedIndex = -1;
            this._pendingClickEvent = null;
         }
      }
      
      protected function soundRollOverHandler(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            this.soundManager.play(this.mouseOverKey);
         }
         else
         {
            this.soundManager.play(this.disabledOverKey);
         }
      }
      
      override protected function createNavItem(param1:String, param2:Class = null) : IFlexDisplayObject
      {
         var _loc3_:SoundEffectButton = new SoundEffectButton();
         _loc3_.focusEnabled = false;
         _loc3_.label = param1;
         _loc3_.setStyle("icon",param2);
         _loc3_.addEventListener(MouseEvent.CLICK,this.clickHandler);
         addChild(_loc3_);
         _loc3_.toggle = true;
         _loc3_.buttonMode = true;
         _loc3_.useHandCursor = true;
         _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.soundRollOverHandler);
         return _loc3_;
      }
   }
}

