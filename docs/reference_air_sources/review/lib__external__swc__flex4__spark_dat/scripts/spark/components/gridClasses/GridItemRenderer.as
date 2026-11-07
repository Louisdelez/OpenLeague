package spark.components.gridClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IToolTip;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.managers.IToolTipManagerClient;
   import mx.managers.ToolTipManager;
   import mx.utils.PopUpUtil;
   import spark.components.Grid;
   import spark.components.Group;
   import spark.components.supportClasses.TextBase;
   
   [Exclude(name="transitions",kind="property")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class GridItemRenderer extends Group implements IGridItemRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var setCurrentStateNeeded:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var playTransitions:Boolean = false;
      
      private var _column:GridColumn = null;
      
      private var _data:Object = null;
      
      private var _down:Boolean = false;
      
      private var _hovered:Boolean = false;
      
      private var _rowIndex:int = -1;
      
      private var _showsCaret:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _dragging:Boolean = false;
      
      private var _label:String = "";
      
      private var _labelDisplay:TextBase = null;
      
      public function GridItemRenderer()
      {
         super();
         this.setCurrentStateNeeded = true;
         accessibilityEnabled = false;
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,GridItemRenderer.toolTipShowHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function initializeRendererToolTip(renderer:IGridItemRenderer) : void
      {
         var toolTipClient:IToolTipManagerClient = renderer as IToolTipManagerClient;
         if(!toolTipClient)
         {
            return;
         }
         var showDataTips:Boolean = renderer.rowIndex != -1 && Boolean(renderer.column) && renderer.column.getShowDataTips();
         var dataTip:String = toolTipClient.toolTip;
         if(!dataTip && showDataTips)
         {
            toolTipClient.toolTip = "<dataTip>";
         }
         else if(Boolean(dataTip) && !showDataTips)
         {
            toolTipClient.toolTip = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var mirror:Boolean = false;
         var toolTip:IToolTip = event.toolTip;
         var renderer:IGridItemRenderer = event.currentTarget as IGridItemRenderer;
         if(!renderer)
         {
            return;
         }
         var uiComp:IUIComponent = event.currentTarget as IUIComponent;
         if(!uiComp)
         {
            return;
         }
         var rendererR:Rectangle = new Rectangle(renderer.getLayoutBoundsX(),renderer.getLayoutBoundsY(),renderer.getLayoutBoundsWidth(),renderer.getLayoutBoundsHeight());
         var scrollR:Rectangle = renderer.grid.scrollRect;
         if(Boolean(scrollR))
         {
            rendererR = rendererR.intersection(scrollR);
         }
         if(rendererR.height == 0 || rendererR.width == 0)
         {
            return;
         }
         mirror = renderer.layoutDirection == LayoutDirection.RTL;
         toolTip.text = renderer.column.itemToDataTip(renderer.data);
         ToolTipManager.sizeTip(toolTip);
         var x:int = mirror ? int(renderer.width - toolTip.width) : int(rendererR.x - renderer.getLayoutBoundsX());
         var y:int = rendererR.y - renderer.getLayoutBoundsY() + (rendererR.height - toolTip.height) / 2;
         var pt:Point = PopUpUtil.positionOverComponent(DisplayObject(uiComp),uiComp.systemManager,toolTip.width,toolTip.height,NaN,null,new Point(x,y));
         toolTip.move(pt.x,pt.y);
      }
      
      private function dispatchChangeEvent(type:String) : void
      {
         if(hasEventListener(type))
         {
            dispatchEvent(new Event(type));
         }
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition() || !this.labelDisplay)
         {
            return super.baselinePosition;
         }
         var labelPosition:Point = globalToLocal(this.labelDisplay.parent.localToGlobal(new Point(this.labelDisplay.x,this.labelDisplay.y)));
         return labelPosition.y + this.labelDisplay.baselinePosition;
      }
      
      [Bindable("columnChanged")]
      public function get column() : GridColumn
      {
         return this._column;
      }
      
      public function set column(value:GridColumn) : void
      {
         if(this._column == value)
         {
            return;
         }
         this._column = value;
         this.dispatchChangeEvent("columnChanged");
      }
      
      public function get columnIndex() : int
      {
         return Boolean(this.column) ? this.column.columnIndex : -1;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         if(this._data == value)
         {
            return;
         }
         this._data = value;
         var eventType:String = "dataChange";
         if(hasEventListener(eventType))
         {
            dispatchEvent(new FlexEvent(eventType));
         }
      }
      
      public function get down() : Boolean
      {
         return this._down;
      }
      
      public function set down(value:Boolean) : void
      {
         if(value == this._down)
         {
            return;
         }
         this._down = value;
         setCurrentState(this.getCurrentRendererState(),this.playTransitions);
      }
      
      public function get grid() : Grid
      {
         return Boolean(this.column) ? this.column.grid : null;
      }
      
      public function get hovered() : Boolean
      {
         return this._hovered;
      }
      
      public function set hovered(value:Boolean) : void
      {
         if(value == this._hovered)
         {
            return;
         }
         this._hovered = value;
         setCurrentState(this.getCurrentRendererState(),this.playTransitions);
      }
      
      [Bindable("rowIndexChanged")]
      public function get rowIndex() : int
      {
         return this._rowIndex;
      }
      
      public function set rowIndex(value:int) : void
      {
         if(this._rowIndex == value)
         {
            return;
         }
         this._rowIndex = value;
         this.dispatchChangeEvent("rowIndexChanged");
      }
      
      [Bindable("showsCaretChanged")]
      public function get showsCaret() : Boolean
      {
         return this._showsCaret;
      }
      
      public function set showsCaret(value:Boolean) : void
      {
         if(this._showsCaret == value)
         {
            return;
         }
         this._showsCaret = value;
         setCurrentState(this.getCurrentRendererState(),this.playTransitions);
         this.dispatchChangeEvent("labelDisplayChanged");
      }
      
      [Bindable("selectedChanged")]
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         setCurrentState(this.getCurrentRendererState(),this.playTransitions);
         this.dispatchChangeEvent("selectedChanged");
      }
      
      [Bindable("draggingChanged")]
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function set dragging(value:Boolean) : void
      {
         if(this._dragging == value)
         {
            return;
         }
         this._dragging = value;
         setCurrentState(this.getCurrentRendererState(),this.playTransitions);
         this.dispatchChangeEvent("draggingChanged");
      }
      
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         if(this._label == value)
         {
            return;
         }
         this._label = value;
         if(Boolean(this.labelDisplay))
         {
            this.labelDisplay.text = this._label;
         }
         this.dispatchChangeEvent("labelChanged");
      }
      
      [Bindable("labelDisplayChanged")]
      public function get labelDisplay() : TextBase
      {
         return this._labelDisplay;
      }
      
      public function set labelDisplay(value:TextBase) : void
      {
         if(this._labelDisplay == value)
         {
            return;
         }
         this._labelDisplay = value;
         this.dispatchChangeEvent("labelDisplayChanged");
      }
      
      protected function getCurrentRendererState() : String
      {
         if(this.dragging && Boolean(hasState("dragging")))
         {
            return "dragging";
         }
         if(this.selected && this.down && Boolean(hasState("downAndSelected")))
         {
            return "downAndSelected";
         }
         if(this.selected && this.showsCaret && Boolean(hasState("selectedAndShowsCaret")))
         {
            return "selectedAndShowsCaret";
         }
         if(this.hovered && this.showsCaret && Boolean(hasState("hoveredAndShowsCaret")))
         {
            return "hoveredAndShowsCaret";
         }
         if(this.showsCaret && Boolean(hasState("normalAndShowsCaret")))
         {
            return "normalAndShowsCaret";
         }
         if(this.down && Boolean(hasState("down")))
         {
            return "down";
         }
         if(this.selected && Boolean(hasState("selected")))
         {
            return "selected";
         }
         if(this.hovered && Boolean(hasState("hovered")))
         {
            return "hovered";
         }
         if(hasState("normal"))
         {
            return "normal";
         }
         return null;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.setCurrentStateNeeded)
         {
            setCurrentState(this.getCurrentRendererState(),this.playTransitions);
            this.setCurrentStateNeeded = false;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(width,height);
         initializeRendererToolTip(this);
      }
      
      public function prepare(hasBeenRecycled:Boolean) : void
      {
      }
      
      public function discard(willBeRecycled:Boolean) : void
      {
      }
   }
}

