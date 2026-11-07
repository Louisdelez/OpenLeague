package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TextOnlyLabelButton extends LabelButtonX
   {
      
      private var _textFormat:TextFormat;
      
      public function TextOnlyLabelButton(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._textFormat = textField.getDefaultTextFormat() || new TextFormat();
         this._textFormat.underline = true;
         textField.setDefaultTextFormat(this._textFormat);
         textField.setMultiline(false);
         textField.setWordWrap(false);
         textField.setAutoSize(TextFieldAutoSize.LEFT);
      }
   }
}

