package mx.controls.olapDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.OLAPDataGrid;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.olap.IOLAPMember;
   
   [Style(name="horizontalAlign",type="String",inherit="no")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class OLAPDataGridGroupRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
   {
      
      private var _listData:AdvancedDataGridListData;
      
      private var _data:Object;
      
      private var listOwner:OLAPDataGrid;
      
      protected var label:IUITextField;
      
      public function OLAPDataGridGroupRenderer()
      {
         super();
         mouseEnabled = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            addChild(DisplayObject(label));
         }
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return label;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var labelColor:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var startx:Number = Boolean(_data) ? _listData.indent : 0;
         var horizontalAlign:String = getStyle("horizontalAlign");
         if(horizontalAlign == "left")
         {
            label.x = startx;
         }
         else if(horizontalAlign == "right")
         {
            label.x = unscaledWidth - label.width + 2;
         }
         else
         {
            label.x = (unscaledHeight - label.height) / 2 + startx;
         }
         label.setActualSize(unscaledWidth - label.x,unscaledHeight);
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            label.y = 0;
         }
         else if(verticalAlign == "bottom")
         {
            label.y = unscaledHeight - label.height + 2;
         }
         else
         {
            label.y = (unscaledHeight - label.height) / 2;
         }
         if(Boolean(data) && Boolean(parent))
         {
            if(!enabled)
            {
               labelColor = Number(getStyle("disabledColor"));
            }
            else if(listOwner.isItemHighlighted(listData.uid))
            {
               labelColor = Number(getStyle("textRollOverColor"));
            }
            else if(listOwner.isItemSelected(listData.uid))
            {
               labelColor = Number(getStyle("textSelectedColor"));
            }
            else
            {
               labelColor = Number(getStyle("color"));
            }
            label.setColor(labelColor);
         }
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(_data))
         {
            listOwner = OLAPDataGrid(_listData.owner);
            label.text = _listData.label;
            label.multiline = listOwner.variableRowHeight;
            label.wordWrap = listOwner.wordWrap;
            if(_data is AdvancedDataGridColumn)
            {
               label.wordWrap = listOwner.columnHeaderWordWrap(_data as AdvancedDataGridColumn);
            }
            else
            {
               label.wordWrap = listOwner.rowHeaderWordWrap(_data.members[_listData.columnIndex] as IOLAPMember);
            }
            label.multiline = listOwner.variableRowHeight;
            if(listOwner.showDataTips)
            {
               if(label.textWidth > label.width || listOwner.dataTipFunction != null)
               {
                  toolTip = listOwner.itemToDataTip(_data);
               }
               else
               {
                  toolTip = null;
               }
            }
            else
            {
               toolTip = null;
            }
         }
         else
         {
            label.text = " ";
            toolTip = null;
         }
         invalidateDisplayList();
      }
      
      private function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var toolTip:IToolTip = event.toolTip;
         var xPos:int = DisplayObject(systemManager).mouseX + 11;
         var yPos:int = DisplayObject(systemManager).mouseY + 22;
         var pt:Point = new Point(xPos,yPos);
         pt = DisplayObject(systemManager).localToGlobal(pt);
         pt = DisplayObject(systemManager.getSandboxRoot()).globalToLocal(pt);
         toolTip.move(pt.x,pt.y + (height - toolTip.height) / 2);
         var screen:Rectangle = toolTip.screen;
         var screenRight:Number = screen.x + screen.width;
         if(toolTip.x + toolTip.width > screenRight)
         {
            toolTip.move(screenRight - toolTip.width,toolTip.y);
         }
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = AdvancedDataGridListData(value);
         invalidateProperties();
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      override protected function measure() : void
      {
         super.measure();
         var w:Number = Boolean(_data) ? _listData.indent : 0;
         if(label.width < 4 || label.height < 4)
         {
            label.width = 4;
            label.height = 16;
         }
         if(isNaN(explicitWidth))
         {
            w += label.getExplicitOrMeasuredWidth();
            measuredWidth = w;
         }
         else
         {
            label.width = Math.max(explicitWidth - w,4);
         }
         measuredHeight = label.getExplicitOrMeasuredHeight();
      }
   }
}

