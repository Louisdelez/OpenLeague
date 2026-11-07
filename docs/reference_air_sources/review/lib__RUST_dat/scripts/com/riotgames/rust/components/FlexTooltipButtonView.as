package com.riotgames.rust.components
{
   import blix.components.button.ButtonX;
   import blix.context.Context;
   import flash.events.MouseEvent;
   import mx.core.IToolTip;
   import mx.core.UIComponent;
   import mx.managers.ToolTipManager;
   
   public class FlexTooltipButtonView extends ButtonX
   {
      
      public var flexContext:UIComponent;
      
      public var tooltip:String;
      
      public var tipDX:int = 0;
      
      public var tipDY:int = 0;
      
      private var tip:IToolTip;
      
      public function FlexTooltipButtonView(param1:Context)
      {
         super(param1);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.tooltip))
         {
            _loc2_ = _asset.stage.mouseX + this.tipDX;
            _loc3_ = _asset.stage.mouseY + this.tipDY;
            this.tip = ToolTipManager.createToolTip(this.tooltip,_loc2_,_loc3_,null,this.flexContext);
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         if(Boolean(this.tip) && Boolean(this.tip.stage))
         {
            ToolTipManager.destroyToolTip(this.tip);
         }
      }
   }
}

