package com.riotgames.platform.gameclient.components.button
{
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   
   public class SoundEffectButton extends Button
   {
      
      private var _mouseDownSoundKey:String = "";
      
      private var _mouseOverSoundKey:String = "";
      
      private var soundManager:ISoundProvider;
      
      public function SoundEffectButton()
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
         this.soundManager = SoundProviderProxy.instance;
      }
      
      override protected function rollOverHandler(param1:MouseEvent) : void
      {
         super.rollOverHandler(param1);
         if(this.enabled)
         {
            this.soundManager.playMouseOverButton(this._mouseOverSoundKey);
         }
      }
      
      public function set mouseOverSoundKey(param1:String) : void
      {
         this._mouseOverSoundKey = param1;
      }
      
      public function set mouseDownSoundKey(param1:String) : void
      {
         this._mouseDownSoundKey = param1;
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         super.clickHandler(param1);
         if(this.enabled)
         {
            this.soundManager.playMouseDownButton(this._mouseDownSoundKey);
         }
      }
      
      override protected function initializationComplete() : void
      {
         super.initializationComplete();
      }
   }
}

