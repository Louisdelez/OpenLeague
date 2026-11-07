package com.riotgames.platform.common.components.controls
{
   import flash.events.FocusEvent;
   import flash.geom.Point;
   import mx.controls.TextInput;
   import mx.controls.ToolTip;
   import mx.managers.ToolTipManager;
   
   public class TextInput extends mx.controls.TextInput
   {
      
      private var _errorString:String;
      
      public var errorTooltip:ToolTip;
      
      public function TextInput()
      {
         super();
      }
      
      override public function set errorString(param1:String) : void
      {
         var _loc2_:Point = null;
         if(this.errorTooltip != null)
         {
            this.errorTooltip.visible = false;
            ToolTipManager.destroyToolTip(this.errorTooltip);
            this.errorTooltip = null;
            if(focusManager != null && focusManager.getFocus() == this)
            {
            }
         }
         this._errorString = param1;
         if(this.errorString != null && this.errorString != "" && this.errorTooltip == null)
         {
            _loc2_ = new Point(this.width,this.y);
            _loc2_ = this.contentToGlobal(_loc2_);
            this.errorTooltip = ToolTipManager.createToolTip(this._errorString,_loc2_.x,_loc2_.y,"errorTipRight",this) as ToolTip;
            this.errorTooltip.setStyle("styleName","errorTip");
            this.errorTooltip.visible = true;
         }
      }
      
      override public function get errorString() : String
      {
         return this._errorString;
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         if(this.errorTooltip != null)
         {
            super.setStyle("themeColor",734012);
         }
         else
         {
            super.setStyle("themeColor",16777215);
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.setStyle("themeColor",16777215);
         super.focusInHandler(param1);
      }
   }
}

