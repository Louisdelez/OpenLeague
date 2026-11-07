package com.riotgames.platform.gameclient.components.comboBox
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import flash.events.Event;
   import mx.controls.ComboBox;
   import mx.events.DropdownEvent;
   
   public class SoundComboBox extends ComboBox
   {
      
      protected var isOpen:Boolean = false;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      public function SoundComboBox()
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
         addEventListener(DropdownEvent.OPEN,this.botDifficulty_cb_openHandler);
         addEventListener(DropdownEvent.CLOSE,this.botDifficulty_cb_closeHandler);
      }
      
      protected function cb_RollOverHandler(param1:Event) : void
      {
         if(this.isOpen)
         {
            return;
         }
         if(Boolean(this.enabled) && this.soundManager != null)
         {
            this.soundManager.play(AudioKeys.SOUND_CB_ROLLOVER);
         }
         else if(this.soundManager != null)
         {
            this.soundManager.play(AudioKeys.SOUND_CB_ROLLOVER_DISABLED);
         }
      }
      
      protected function botDifficulty_cb_closeHandler(param1:DropdownEvent) : void
      {
         this.isOpen = false;
      }
      
      override protected function initializationComplete() : void
      {
         super.initializationComplete();
      }
      
      protected function botDifficulty_cb_openHandler(param1:DropdownEvent) : void
      {
         if(this.enabled)
         {
            if(this.soundManager != null)
            {
               this.soundManager.play(AudioKeys.SOUND_CB_OPEN);
            }
            this.isOpen = true;
         }
      }
      
      protected function dropdown_itemRollOverHandler(param1:Event) : void
      {
         if(Boolean(this.enabled) && this.soundManager != null)
         {
            this.soundManager.play(AudioKeys.SOUND_CB_ITEM_ROLLOVER);
         }
         else if(this.soundManager != null)
         {
            this.soundManager.play(AudioKeys.SOUND_CB_ITEM_DISABLED_ROLLOVER);
         }
      }
   }
}

