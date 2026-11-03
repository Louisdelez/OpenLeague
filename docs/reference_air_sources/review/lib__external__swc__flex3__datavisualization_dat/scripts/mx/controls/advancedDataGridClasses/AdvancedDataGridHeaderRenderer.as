package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextLineMetrics;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   [Style(name="separatorColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class AdvancedDataGridHeaderRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var partsSeparatorSkin:DisplayObject;
      
      protected var label:IUITextField;
      
      private var grid:AdvancedDataGrid;
      
      private var _listData:AdvancedDataGridListData;
      
      private var _data:Object;
      
      private var _sortItemRenderer:IFactory;
      
      private var partsSeparatorSkinClass:Class;
      
      private var sortItemRendererChanged:Boolean = false;
      
      private var sortItemRendererInstance:UIComponent;
      
      protected var background:Sprite;
      
      private var oldUnscaledWidth:Number = -1;
      
      public function AdvancedDataGridHeaderRenderer()
      {
         super();
         tabEnabled = false;
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return label;
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = AdvancedDataGridListData(value);
         grid = AdvancedDataGrid(_listData.owner);
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var column:AdvancedDataGridColumn = null;
         var dataTips:Boolean = false;
         super.commitProperties();
         if(!initialized)
         {
            label.styleName = this;
         }
         if(!sortItemRendererInstance || sortItemRendererChanged)
         {
            if(!sortItemRenderer)
            {
               sortItemRenderer = ClassFactory(grid.sortItemRenderer);
            }
            if(Boolean(sortItemRenderer))
            {
               sortItemRendererInstance = sortItemRenderer.newInstance();
               addChild(DisplayObject(sortItemRendererInstance));
            }
            sortItemRendererChanged = false;
         }
         var oldPartsSeparatorSkinClass:Class = partsSeparatorSkinClass;
         if(!partsSeparatorSkinClass || partsSeparatorSkinClass != grid.getStyle("headerSortSeparatorSkin"))
         {
            partsSeparatorSkinClass = grid.getStyle("headerSortSeparatorSkin");
         }
         if(grid.sortExpertMode || partsSeparatorSkinClass != oldPartsSeparatorSkinClass)
         {
            if(Boolean(partsSeparatorSkin))
            {
               removeChild(partsSeparatorSkin);
            }
            if(!grid.sortExpertMode)
            {
               partsSeparatorSkin = new partsSeparatorSkinClass();
               addChild(partsSeparatorSkin);
            }
         }
         if(Boolean(partsSeparatorSkin))
         {
            partsSeparatorSkin.visible = !(_data is AdvancedDataGridColumnGroup);
         }
         if(_data != null)
         {
            label.text = Boolean(listData.label) ? listData.label : " ";
            label.multiline = grid.variableRowHeight;
            if(_data is AdvancedDataGridColumn)
            {
               label.wordWrap = grid.columnHeaderWordWrap(_data as AdvancedDataGridColumn);
            }
            else
            {
               label.wordWrap = grid.wordWrap;
            }
            if(_data is AdvancedDataGridColumn)
            {
               column = _data as AdvancedDataGridColumn;
               dataTips = grid.showDataTips;
               if(column.showDataTips == true)
               {
                  dataTips = true;
               }
               if(column.showDataTips == false)
               {
                  dataTips = false;
               }
               if(dataTips)
               {
                  if(Boolean(label.textWidth > label.width || column.dataTipFunction || column.dataTipField) || Boolean(grid.dataTipFunction) || Boolean(grid.dataTipField))
                  {
                     toolTip = column.itemToDataTip(_data);
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
         }
         else
         {
            label.text = " ";
            toolTip = null;
         }
         if(sortItemRendererInstance is IInvalidating)
         {
            IInvalidating(sortItemRendererInstance).invalidateProperties();
         }
      }
      
      override public function get baselinePosition() : Number
      {
         return label.baselinePosition;
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      override protected function measure() : void
      {
         var lineMetrics:TextLineMetrics = null;
         super.measure();
         var paddingLeft:int = int(getStyle("paddingLeft"));
         var paddingRight:int = int(getStyle("paddingRight"));
         var paddingTop:int = int(getStyle("paddingTop"));
         var paddingBottom:int = int(getStyle("paddingBottom"));
         var sortItemRendererWidth:Number = Boolean(sortItemRendererInstance) ? Number(sortItemRendererInstance.getExplicitOrMeasuredWidth()) : 0;
         var sortItemRendererHeight:Number = Boolean(sortItemRendererInstance) ? Number(sortItemRendererInstance.getExplicitOrMeasuredHeight()) : 0;
         if(grid.sortExpertMode && getFieldSortInfo() == null)
         {
            sortItemRendererWidth = 0;
            sortItemRendererHeight = 0;
         }
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         if(sortItemRendererWidth == 0)
         {
            horizontalGap = 0;
         }
         var labelWidth:Number = 0;
         var labelHeight:Number = 0;
         var w:Number = 0;
         var h:Number = 0;
         if(!isNaN(explicitWidth))
         {
            w = Number(explicitWidth);
            labelWidth = w - sortItemRendererWidth - horizontalGap - (Boolean(partsSeparatorSkin) ? partsSeparatorSkin.width + 10 : 0) - paddingLeft - paddingRight;
            label.width = labelWidth;
            labelHeight = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         }
         else
         {
            lineMetrics = measureText(label.text);
            labelWidth = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
            labelHeight = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
            w = labelWidth + horizontalGap + (Boolean(partsSeparatorSkin) ? partsSeparatorSkin.width : 0) + sortItemRendererWidth;
         }
         h = Math.max(labelHeight,sortItemRendererHeight);
         h = Math.max(h,Boolean(partsSeparatorSkin) ? partsSeparatorSkin.height : 0);
         w += paddingLeft + paddingRight;
         h += paddingTop + paddingBottom;
         measuredMinWidth = measuredWidth = w;
         measuredMinHeight = measuredHeight = h;
      }
      
      public function mouseEventToHeaderPart(event:MouseEvent) : String
      {
         var point:Point = new Point(event.stageX,event.stageY);
         point = globalToLocal(point);
         return point.x < sortItemRendererInstance.x ? AdvancedDataGrid.HEADER_TEXT_PART : AdvancedDataGrid.HEADER_ICON_PART;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            addChild(DisplayObject(label));
         }
         if(!background)
         {
            background = new UIComponent();
            addChild(background);
         }
      }
      
      public function set sortItemRenderer(value:IFactory) : void
      {
         _sortItemRenderer = value;
         sortItemRendererChanged = true;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("sortItemRendererChanged"));
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      protected function getFieldSortInfo() : SortInfo
      {
         return grid.getFieldSortInfo(grid.columns[listData.columnIndex]);
      }
      
      [Inspectable(category="Data")]
      public function get sortItemRenderer() : IFactory
      {
         return _sortItemRenderer;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      protected function toolTipShowHandler(event:ToolTipEvent) : void
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
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var labelX:Number = NaN;
         var labelY:Number = NaN;
         var labelColor:Number = NaN;
         var sortItemRendererX:Number = NaN;
         var sortItemRendererY:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(unscaledWidth == 0)
         {
            return;
         }
         var paddingLeft:int = int(getStyle("paddingLeft"));
         var paddingRight:int = int(getStyle("paddingRight"));
         var paddingTop:int = int(getStyle("paddingTop"));
         var paddingBottom:int = int(getStyle("paddingBottom"));
         var sortItemRendererWidth:Number = Boolean(sortItemRendererInstance) ? Number(sortItemRendererInstance.getExplicitOrMeasuredWidth()) : 0;
         var sortItemRendererHeight:Number = Boolean(sortItemRendererInstance) ? Number(sortItemRendererInstance.getExplicitOrMeasuredHeight()) : 0;
         if(Boolean(sortItemRendererInstance))
         {
            sortItemRendererInstance.setActualSize(sortItemRendererWidth,sortItemRendererHeight);
         }
         if(grid.sortExpertMode && getFieldSortInfo() == null)
         {
            sortItemRendererWidth = 0;
            sortItemRendererHeight = 0;
         }
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         if(sortItemRendererWidth == 0)
         {
            horizontalGap = 0;
         }
         var MINIMUM_SIZE:TextLineMetrics = measureText("w");
         var lineMetrics:TextLineMetrics = measureText(label.text);
         var labelWidth:Number = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
         var maxLabelWidth:int = unscaledWidth - sortItemRendererWidth - horizontalGap - paddingLeft - paddingRight;
         if(maxLabelWidth < 0)
         {
            maxLabelWidth = 0;
         }
         var truncate:Boolean = false;
         if(maxLabelWidth < labelWidth)
         {
            truncate = true;
            labelWidth = maxLabelWidth;
         }
         var labelHeight:Number = label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
         var maxLabelHeight:int = unscaledHeight - paddingTop - paddingBottom;
         if(maxLabelHeight < labelHeight)
         {
            truncate = true;
            labelHeight = maxLabelHeight;
         }
         label.setActualSize(labelWidth,labelHeight);
         if(truncate && !label.multiline)
         {
            label.truncateToFit();
         }
         var horizontalAlign:String = getStyle("horizontalAlign");
         if(horizontalAlign == "left")
         {
            labelX = paddingLeft;
         }
         else if(horizontalAlign == "right")
         {
            labelX = unscaledWidth - paddingRight - sortItemRendererWidth - horizontalGap - labelWidth;
         }
         else
         {
            labelX = (unscaledWidth - labelWidth - paddingLeft - paddingRight - horizontalGap - sortItemRendererWidth) / 2 + paddingLeft;
         }
         labelX = Math.max(labelX,0);
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            labelY = paddingTop;
         }
         else if(verticalAlign == "bottom")
         {
            labelY = unscaledHeight - labelHeight - paddingBottom + 2;
         }
         else
         {
            labelY = (unscaledHeight - labelHeight - paddingBottom - paddingTop) / 2 + paddingTop;
         }
         labelY = Math.max(labelY,0);
         label.x = Math.round(labelX);
         label.y = Math.round(labelY);
         if(Boolean(sortItemRendererInstance))
         {
            sortItemRendererX = unscaledWidth - sortItemRendererWidth - paddingRight;
            sortItemRendererY = (unscaledHeight - sortItemRendererHeight - paddingTop - paddingBottom) / 2 + paddingTop;
            sortItemRendererInstance.x = Math.round(sortItemRendererX);
            sortItemRendererInstance.y = Math.round(sortItemRendererY);
         }
         graphics.clear();
         if(Boolean(sortItemRendererInstance) && Boolean(!grid.sortExpertMode) && !(_data is AdvancedDataGridColumnGroup))
         {
            if(!partsSeparatorSkinClass)
            {
               graphics.lineStyle(1,getStyle("separatorColor") !== undefined ? uint(getStyle("separatorColor")) : 13421772);
               graphics.moveTo(sortItemRendererInstance.x - 1,1);
               graphics.lineTo(sortItemRendererInstance.x - 1,unscaledHeight - 1);
            }
            else
            {
               partsSeparatorSkin.x = sortItemRendererInstance.x - horizontalGap - partsSeparatorSkin.width;
               partsSeparatorSkin.y = (unscaledHeight - partsSeparatorSkin.height) / 2;
            }
         }
         if(Boolean(data) && Boolean(parent))
         {
            if(!enabled)
            {
               labelColor = Number(getStyle("disabledColor"));
            }
            else if(grid.isItemHighlighted(listData.uid))
            {
               labelColor = Number(getStyle("textRollOverColor"));
            }
            else if(grid.isItemSelected(listData.uid))
            {
               labelColor = Number(getStyle("textSelectedColor"));
            }
            else
            {
               labelColor = Number(getStyle("color"));
            }
            label.setColor(labelColor);
         }
         if(Boolean(background))
         {
            background.graphics.clear();
            background.graphics.beginFill(16777215,0);
            background.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
            background.graphics.endFill();
            setChildIndex(DisplayObject(background),0);
         }
      }
   }
}

