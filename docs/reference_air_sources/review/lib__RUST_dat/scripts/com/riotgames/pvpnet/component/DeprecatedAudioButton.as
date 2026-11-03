package com.riotgames.pvpnet.component
{
   import blix.context.Context;
   import com.riotgames.rust.components.FlexTooltipButtonView;
   import com.riotgames.rust.context.IButtonAudio;
   import flash.events.MouseEvent;
   
   public class DeprecatedAudioButton extends FlexTooltipButtonView
   {
      
      private var _mouseOverSoundKey:String = "";
      
      private var _mouseDownSoundKey:String = "";
      
      public function DeprecatedAudioButton(param1:Context, param2:String = "", param3:String = "")
      {
         super(param1);
         this._mouseOverSoundKey = param2;
         this._mouseDownSoundKey = param3;
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var _loc2_:IButtonAudio = getDependency(IButtonAudio);
         if(Boolean(_loc2_))
         {
            _loc2_.playMouseOverButton(this._mouseOverSoundKey);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:IButtonAudio = getDependency(IButtonAudio);
         if(Boolean(_loc2_))
         {
            _loc2_.playMouseDownButton(this._mouseDownSoundKey);
         }
      }
   }
}

