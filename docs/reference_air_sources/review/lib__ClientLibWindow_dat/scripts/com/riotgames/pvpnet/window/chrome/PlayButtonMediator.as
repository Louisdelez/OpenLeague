package com.riotgames.pvpnet.window.chrome
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayContainer;
   import blix.components.button.LabelButtonX;
   import com.riotgames.util.logging.getLogger;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   
   public class PlayButtonMediator implements IOverridableButtonProvider
   {
      
      private var playButton:LabelButtonX;
      
      private var currentOverride:PlayButtonOverride;
      
      private var playButtonParent:IDisplayContainer;
      
      private var _defaultCallback:Function;
      
      private var _defaultLabel:String;
      
      private var _defaultTextFormat:TextFormat;
      
      private var _replacementViewOverride:PlayButtonOverride;
      
      public function PlayButtonMediator(param1:LabelButtonX, param2:Function, param3:String = null)
      {
         super();
         this.playButton = param1;
         if(param1.textField.getAsset() != null)
         {
            this.onAssetChanged();
         }
         else
         {
            param1.textField.getAssetChanged().addOnce(this.onAssetChanged);
         }
         this._defaultCallback = param2;
         this._defaultLabel = param3;
         this.setPlayButtonParent(param1.getParentDisplayContainer());
         this.addPlayButtonListeners();
      }
      
      private function onAssetChanged() : void
      {
         this._defaultTextFormat = this.playButton.textField.getDefaultTextFormat();
         this.setPlayButtonText(this._defaultTextFormat,this._defaultLabel != null ? this._defaultLabel : null);
      }
      
      private function addPlayButtonListeners() : void
      {
         if(this.playButton != null)
         {
            this.playButton.addEventListener(Event.ADDED_TO_STAGE,this.playButtonAddedToStage);
            this.playButton.addEventListener(Event.REMOVED_FROM_STAGE,this.playButtonRemovedFromStage);
            this.playButton.addEventListener(MouseEvent.CLICK,this.playButtonClicked);
         }
      }
      
      private function playButtonClicked(param1:MouseEvent) : void
      {
         if(this.currentOverride != null && this.currentOverride.callback != null)
         {
            this.currentOverride.callback.apply(this.currentOverride.owner,[param1]);
         }
         else
         {
            this._defaultCallback();
         }
      }
      
      private function playButtonAddedToStage(param1:Event) : void
      {
         this.setPlayButtonParent(this.playButton.getParentDisplayContainer());
      }
      
      private function playButtonRemovedFromStage(param1:Event) : void
      {
         this.setPlayButtonParent(null);
      }
      
      private function setPlayButtonParent(param1:IDisplayContainer) : void
      {
         if(this.playButtonParent != param1)
         {
            this.removeReplacementView();
            this.playButtonParent = param1;
            this.addReplacementView();
         }
      }
      
      private function removeReplacementView() : void
      {
         if(this.playButtonParent != null && this._replacementViewOverride != null && this._replacementViewOverride.replacementView != null)
         {
            if(this._replacementViewOverride.owner != null)
            {
               this._replacementViewOverride.owner.removeEventListener(Event.REMOVED_FROM_STAGE,this.weakOverrideViewWasRemovedFromStage);
            }
            this.playButtonParent.removeChild(this._replacementViewOverride.replacementView);
            this._replacementViewOverride.replacementView.getScaledBoundsChanged().remove(this.updateReplacementPosition);
            this._replacementViewOverride = null;
            this.playButton.setVisible(true);
         }
      }
      
      private function addReplacementView() : void
      {
         if(this.playButtonParent != null && this._replacementViewOverride != null && this._replacementViewOverride.replacementView != null)
         {
            this.playButton.setVisible(false);
            this.playButtonParent.addChild(this._replacementViewOverride.replacementView);
            this._replacementViewOverride.replacementView.getScaledBoundsChanged().add(this.updateReplacementPosition);
            this._replacementViewOverride.replacementView.setWeight(this.playButton.getWeight() + 1);
            this.updateReplacementPosition();
            if(this._replacementViewOverride.isWeak && this._replacementViewOverride.owner != null)
            {
               this._replacementViewOverride.owner.addEventListener(Event.REMOVED_FROM_STAGE,this.weakOverrideViewWasRemovedFromStage);
            }
         }
      }
      
      private function updateReplacementPosition() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         if(this.playButton != null && this._replacementViewOverride.replacementView != null)
         {
            _loc1_ = this.playButton.getScaledBounds();
            _loc2_ = this._replacementViewOverride.replacementView.getScaledBounds();
            this._replacementViewOverride.replacementView.setExplicitPosition(_loc1_.x,_loc1_.y);
         }
      }
      
      private function registerOverride(param1:PlayButtonOverride) : void
      {
         if(this.currentOverride != null)
         {
            this.unregisterCurrentOverride();
         }
         this.currentOverride = param1;
         if(param1.callback != null)
         {
            if(Boolean(param1.label))
            {
               this.changeText(param1.label);
            }
            if(param1.isWeak && param1.owner != null)
            {
               param1.owner.addEventListener(Event.REMOVED_FROM_STAGE,this.weakOverrideWasRemovedFromStage);
            }
            return;
         }
         getLogger(this).info("Invalid play button override.  Must contain a callback or replacement view at minimum.");
         this.currentOverride = null;
      }
      
      private function unregisterCurrentOverride() : void
      {
         this.changeText(this._defaultLabel != null ? this._defaultLabel : null);
         this.playButton.setEnabled(true);
         this.currentOverride.owner.removeEventListener(Event.REMOVED_FROM_STAGE,this.weakOverrideWasRemovedFromStage);
         this.currentOverride = null;
      }
      
      private function weakOverrideWasRemovedFromStage(param1:Event) : void
      {
         if(this.currentOverride != null && param1.target == this.currentOverride.owner)
         {
            this.unregisterCurrentOverride();
         }
      }
      
      private function weakOverrideViewWasRemovedFromStage(param1:Event) : void
      {
         this.removePlayButtonReplacement(this._replacementViewOverride.replacementView);
      }
      
      private function changeText(param1:String) : void
      {
         this.setPlayButtonText(this._defaultTextFormat,param1);
         var _loc2_:TextFormat = new TextFormat();
         var _loc3_:int = this._defaultTextFormat.size as int;
         while(this.playButton.textField.getTextWidth() > this.playButton.textField.getWidth() && _loc3_ > 1)
         {
            _loc3_--;
            _loc2_.size = _loc3_;
            this.setPlayButtonText(_loc2_,param1);
         }
      }
      
      private function setPlayButtonText(param1:TextFormat, param2:String) : void
      {
         this.playButton.textField.setDefaultTextFormat(param1);
         this.playButton.setText(" ");
         this.playButton.setText(param2);
      }
      
      public function registerPlayButtonCallback(param1:Function, param2:DisplayObjectProxy, param3:Boolean = true) : void
      {
         var _loc4_:PlayButtonOverride = new PlayButtonOverride(param1,null,null,param2,param3);
         this.registerOverride(_loc4_);
      }
      
      public function registerPlayButtonCallbackAndLabel(param1:Function, param2:String, param3:DisplayObjectProxy, param4:Boolean = true) : void
      {
         var _loc5_:PlayButtonOverride = new PlayButtonOverride(param1,null,param2,param3,param4);
         this.registerOverride(_loc5_);
      }
      
      public function setButtonCallbackEnabled(param1:Function, param2:Boolean) : void
      {
         if(this.currentOverride != null && this.currentOverride.callback == param1)
         {
            this.playButton.setEnabled(param2);
         }
      }
      
      public function unregisterPlayButtonCallback(param1:Function) : Boolean
      {
         if(this.currentOverride != null && this.currentOverride.callback == param1)
         {
            this.unregisterCurrentOverride();
            return true;
         }
         return false;
      }
      
      public function replacePlayButton(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:Boolean = false) : void
      {
         this._replacementViewOverride = new PlayButtonOverride(null,param1,null,param2,param3);
         this.addReplacementView();
      }
      
      public function removePlayButtonReplacement(param1:DisplayObjectProxy) : Boolean
      {
         if(this._replacementViewOverride != null && this._replacementViewOverride.replacementView == param1)
         {
            this.removeReplacementView();
            return true;
         }
         return false;
      }
   }
}

import blix.assets.proxy.DisplayObjectProxy;

class PlayButtonOverride
{
   
   public var callback:Function;
   
   public var label:String;
   
   public var owner:DisplayObjectProxy;
   
   public var isWeak:Boolean;
   
   public var replacementView:DisplayObjectProxy;
   
   public function PlayButtonOverride(param1:Function, param2:DisplayObjectProxy, param3:String, param4:DisplayObjectProxy, param5:Boolean)
   {
      super();
      this.callback = param1;
      this.label = param3;
      this.owner = param4;
      this.isWeak = param5;
      this.replacementView = param2;
   }
}
