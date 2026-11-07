package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.tooltip.assignToolTip;
   import blix.context.Context;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.pvpnet.chrome.ChromeController;
   import com.riotgames.pvpnet.chrome.model.ChromeModel;
   import com.riotgames.pvpnet.component.AudioButton;
   import flash.events.MouseEvent;
   import mx.resources.ResourceManager;
   
   public class ChromePlayButton extends AudioButton
   {
      
      private var _textField:TextFieldProxy;
      
      private var _model:ChromeModel;
      
      public function ChromePlayButton(param1:Context)
      {
         super(param1,AudioKeys.SOUND_PLAY_BUTTON_ROLL_OVER,AudioKeys.SOUND_PLAY_BUTTON_CLICK);
         this._model = getDependency(ChromeModel);
         this._model.playButtonEnabledChanged.add(this.updateEnabled);
         this.updateEnabled();
      }
      
      override protected function createChildren() : void
      {
         this._textField = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._textField);
         this._textField.setText(ResourceManager.getInstance().getString("resources","navigator_playGameLabel"));
         assignToolTip(this,ResourceManager.getInstance().getString("resources","navigator_playGame_tooltip"));
         super.createChildren();
      }
      
      private function updateEnabled() : void
      {
         setEnabled(this._model.playButtonEnabled);
      }
      
      private function get controller() : ChromeController
      {
         return getDependency(ChromeController);
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         super.onClick(param1);
         this.controller.navigateToGameFlow();
      }
   }
}

