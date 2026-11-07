package com.riotgames.pvpnet.cap.renderers.dropdown
{
   import blix.components.renderer.SelectableRenderer;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CapDropdownRenderer extends SelectableRenderer
   {
      
      private static const _tooltipConfig:ToolTipConfig = new ToolTipConfig();
      
      private var _tooltipClass:Class;
      
      private const TOOLTIP_OFFSET_X:int = 4;
      
      private const TOOLTIP_OFFSET_Y:int = 0;
      
      public function CapDropdownRenderer(param1:IContext, param2:String = "CapDropDownItemRenderer", param3:String = "name", param4:Class = null)
      {
         super(param1);
         _tooltipConfig.showDelay = 0;
         _tooltipConfig.gap = new Point(this.TOOLTIP_OFFSET_X,this.TOOLTIP_OFFSET_Y);
         _tooltipConfig.toolTipPosition = new RectPosition(RectPosition.LEFT_MIDDLE,RectPosition.RIGHT_MIDDLE);
         _tooltipConfig.cacheView = false;
         this._tooltipClass = param4;
         setLinkage(param2);
         setLabelField(param3);
      }
      
      override public function destroy() : void
      {
         unassignToolTip(this);
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return _asset.getBounds(null);
      }
      
      override public function setData(param1:*) : void
      {
         if(this._tooltipClass)
         {
            TipsProviderProxy.instance.assignCustomToolTip(this,param1,this._tooltipClass,_tooltipConfig);
         }
         super.setData(param1);
      }
   }
}

