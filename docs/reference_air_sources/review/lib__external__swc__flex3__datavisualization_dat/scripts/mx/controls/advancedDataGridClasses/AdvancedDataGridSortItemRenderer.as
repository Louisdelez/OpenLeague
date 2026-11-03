package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.text.TextLineMetrics;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="icon",type="Class",inherit="no")]
   [Style(name="proposedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   public class AdvancedDataGridSortItemRenderer extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var iconName:String = "icon";
      
      protected var label:IUITextField;
      
      private var _descending:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var icon:IFlexDisplayObject;
      
      public function AdvancedDataGridSortItemRenderer()
      {
         super();
         visible = false;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var iconX:Number = NaN;
         var iconY:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(unscaledWidth == 0)
         {
            return;
         }
         var paddingLeft:int = int(getStyle("paddingLeft"));
         var paddingRight:int = int(getStyle("paddingRight"));
         var paddingTop:int = int(getStyle("paddingTop"));
         var paddingBottom:int = int(getStyle("paddingBottom"));
         var iconWidth:Number = Boolean(icon) ? Number(icon.width) : 0;
         var iconHeight:Number = Boolean(icon) ? Number(icon.height) : 0;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         if(iconWidth == 0)
         {
            horizontalGap = 0;
         }
         var labelWidth:Number = unscaledWidth - iconWidth - horizontalGap - paddingLeft - paddingRight;
         var labelHeight:Number = unscaledHeight - paddingTop - paddingBottom;
         label.setActualSize(labelWidth,labelHeight);
         var labelX:Number = paddingLeft;
         var labelY:Number = (unscaledHeight - label.height - paddingTop - paddingBottom) / 2 + paddingTop;
         labelY = Math.max(labelY,0);
         label.x = Math.round(labelX);
         label.y = Math.round(labelY);
         if(Boolean(icon))
         {
            iconX = unscaledWidth - iconWidth - paddingRight;
            iconY = (unscaledHeight - iconHeight - paddingTop - paddingBottom) / 2 + paddingTop;
            icon.x = Math.round(iconX);
            icon.y = Math.round(iconY);
            if(!descending)
            {
               icon.scaleY = -1;
               icon.y += iconHeight;
            }
            else
            {
               icon.scaleY = 1;
            }
         }
      }
      
      protected function getFontStyles() : void
      {
         var gridStyle:* = undefined;
         if(Boolean(grid))
         {
            gridStyle = grid.getStyle("sortFontFamily");
            if(gridStyle !== undefined)
            {
               setStyle("fontFamily",gridStyle);
            }
            gridStyle = grid.getStyle("sortFontSize");
            if(gridStyle !== undefined)
            {
               setStyle("fontSize",gridStyle);
            }
            gridStyle = grid.getStyle("sortFontStyle");
            if(gridStyle !== undefined)
            {
               setStyle("fontStyle",gridStyle);
            }
            gridStyle = grid.getStyle("sortFontWeight");
            if(gridStyle !== undefined)
            {
               setStyle("fontWeight",gridStyle);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         getFontStyles();
         var sortInfo:SortInfo = getFieldSortInfo();
         if(Boolean(sortInfo))
         {
            visible = true;
            label.text = sortInfo.sequenceNumber.toString();
            if(sortInfo.status == SortInfo.PROPOSEDSORT)
            {
               label.setColor(getStyle("proposedColor") !== undefined ? uint(getStyle("proposedColor")) : 10066329);
            }
            else
            {
               label.setColor(getStyle("color") !== undefined ? uint(getStyle("color")) : 0);
            }
            descending = sortInfo.descending;
         }
         else
         {
            visible = false;
         }
      }
      
      protected function get grid() : AdvancedDataGrid
      {
         if(Boolean(parent) && Boolean(IUIComponent(parent).owner) && IUIComponent(parent).owner is AdvancedDataGrid)
         {
            return IUIComponent(parent).owner as AdvancedDataGrid;
         }
         return null;
      }
      
      public function set descending(value:Boolean) : void
      {
         if(_descending != value)
         {
            _descending = value;
            invalidateDisplayList();
         }
      }
      
      public function get descending() : Boolean
      {
         return _descending;
      }
      
      override protected function createChildren() : void
      {
         var iconClass:Class = null;
         super.createChildren();
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            addChild(DisplayObject(label));
         }
         if(!icon)
         {
            iconClass = Class(getStyle(iconName));
            if(Boolean(iconClass))
            {
               icon = new iconClass();
               icon.name = iconName;
               if(icon is ISimpleStyleClient)
               {
                  ISimpleStyleClient(icon).styleName = this;
               }
               addChild(DisplayObject(icon));
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var paddingLeft:int = int(getStyle("paddingLeft"));
         var paddingRight:int = int(getStyle("paddingRight"));
         var paddingTop:int = int(getStyle("paddingTop"));
         var paddingBottom:int = int(getStyle("paddingBottom"));
         var lineMetrics:TextLineMetrics = measureText(label.length == 0 ? "2" : label.text);
         var labelWidth:Number = lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
         var labelHeight:Number = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
         var iconWidth:Number = Boolean(icon) ? Number(icon.width) : 0;
         var iconHeight:Number = Boolean(icon) ? Number(icon.height) : 0;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         if(iconWidth == 0)
         {
            horizontalGap = 0;
         }
         var w:Number = labelWidth + horizontalGap + iconWidth;
         var h:Number = Math.max(labelHeight,iconHeight);
         w += getStyle("paddingLeft") + getStyle("paddingRight");
         h += getStyle("paddingTop") + getStyle("paddingBottom");
         measuredMinWidth = measuredWidth = w;
         measuredMinHeight = measuredHeight = h;
      }
      
      protected function getFieldSortInfo() : SortInfo
      {
         var listData:AdvancedDataGridListData = null;
         if(Boolean(grid) && parent is IDropInListItemRenderer)
         {
            listData = (parent as IDropInListItemRenderer).listData as AdvancedDataGridListData;
            if(Boolean(listData) && listData.columnIndex != -1)
            {
               return grid.getFieldSortInfo(grid.columns[listData.columnIndex]);
            }
         }
         return null;
      }
   }
}

