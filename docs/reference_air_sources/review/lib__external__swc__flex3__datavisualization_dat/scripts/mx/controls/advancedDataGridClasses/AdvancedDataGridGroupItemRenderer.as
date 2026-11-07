package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.AdvancedDataGridEvent;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class AdvancedDataGridGroupItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      protected var disclosureIcon:IFlexDisplayObject;
      
      private var _listData:AdvancedDataGridListData;
      
      private var _data:Object;
      
      protected var label:IUITextField;
      
      private var listOwner:AdvancedDataGrid;
      
      protected var icon:IFlexDisplayObject;
      
      public function AdvancedDataGridGroupItemRenderer()
      {
         super();
         mouseEnabled = false;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return label;
      }
      
      override protected function commitProperties() : void
      {
         var oldIconX:Number = NaN;
         var oldDisclosureIconX:Number = NaN;
         var index:int = 0;
         var column:AdvancedDataGridColumn = null;
         var dataTips:Boolean = false;
         var disclosureIconClass:Class = null;
         var disclosureInstance:* = undefined;
         var wrapper:SpriteAsset = null;
         var iconClass:Class = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && label != null)
         {
            index = int(getChildIndex(DisplayObject(label)));
            removeLabel();
            createLabel(index);
         }
         if(Boolean(icon))
         {
            oldIconX = Number(icon.x);
            removeChild(DisplayObject(icon));
            icon = null;
         }
         if(Boolean(disclosureIcon))
         {
            oldDisclosureIconX = Number(disclosureIcon.x);
            disclosureIcon.removeEventListener(MouseEvent.MOUSE_DOWN,disclosureMouseDownHandler);
            removeChild(DisplayObject(disclosureIcon));
            disclosureIcon = null;
         }
         if(_data != null)
         {
            listOwner = AdvancedDataGrid(_listData.owner);
            column = listOwner.columns[_listData.columnIndex];
            if(Boolean(_listData.disclosureIcon))
            {
               disclosureIconClass = _listData.disclosureIcon;
               disclosureInstance = new disclosureIconClass();
               if(!(disclosureInstance is InteractiveObject))
               {
                  wrapper = new SpriteAsset();
                  wrapper.addChild(disclosureInstance as DisplayObject);
                  disclosureIcon = wrapper as IFlexDisplayObject;
               }
               else
               {
                  disclosureIcon = disclosureInstance;
               }
               addChild(disclosureIcon as DisplayObject);
               if(Boolean(oldDisclosureIconX))
               {
                  disclosureIcon.x = oldDisclosureIconX;
               }
               disclosureIcon.addEventListener(MouseEvent.MOUSE_DOWN,disclosureMouseDownHandler);
            }
            if(Boolean(_listData.icon))
            {
               iconClass = _listData.icon;
               icon = new iconClass();
               addChild(DisplayObject(icon));
               if(Boolean(oldIconX))
               {
                  icon.x = oldIconX;
               }
            }
            label.text = _listData.label;
            label.multiline = listOwner.variableRowHeight;
            label.wordWrap = listOwner.columnWordWrap(column);
            dataTips = listOwner.showDataTips;
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
               if(!(_data is AdvancedDataGridColumn) && (Boolean(label.textWidth > label.width || column.dataTipFunction || column.dataTipField || listOwner.dataTipFunction) || Boolean(listOwner.dataTipField)))
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
         else
         {
            label.text = " ";
            toolTip = null;
         }
         invalidateDisplayList();
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
      
      protected function createLabel(childIndex:int) : void
      {
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            if(childIndex == -1)
            {
               addChild(DisplayObject(label));
            }
            else
            {
               addChildAt(DisplayObject(label),childIndex);
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var w:Number = Boolean(_data) ? _listData.indent : 0;
         if(Boolean(disclosureIcon))
         {
            w += disclosureIcon.width;
         }
         if(Boolean(icon))
         {
            w += icon.measuredWidth;
         }
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
         if(Boolean(icon) && icon.measuredHeight > measuredHeight)
         {
            measuredHeight = icon.measuredHeight;
         }
      }
      
      protected function removeLabel() : void
      {
         if(label != null)
         {
            removeChild(DisplayObject(label));
            label = null;
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createLabel(-1);
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,toolTipShowHandler);
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
      public function get data() : Object
      {
         return _data;
      }
      
      private function disclosureMouseDownHandler(event:Event) : void
      {
         event.stopPropagation();
         if(listOwner.isOpening || !listOwner.enabled)
         {
            return;
         }
         var open:Boolean = _listData.open;
         _listData.open = !open;
         listOwner.dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,_listData.item,this,event,!open,true,true);
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDisclosureIcon() : IFlexDisplayObject
      {
         return disclosureIcon;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var labelColor:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var startx:Number = Boolean(_data) ? _listData.indent : 0;
         if(Boolean(disclosureIcon))
         {
            disclosureIcon.x = startx;
            startx = disclosureIcon.x + disclosureIcon.width;
            disclosureIcon.setActualSize(disclosureIcon.width,disclosureIcon.height);
            disclosureIcon.visible = Boolean(_data) ? _listData.hasChildren : false;
            if(disclosureIcon.visible)
            {
               disclosureIcon.visible = startx < unscaledWidth;
            }
         }
         if(Boolean(icon))
         {
            icon.x = startx;
            startx = icon.x + icon.measuredWidth;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
            if(icon.x > unscaledWidth)
            {
               icon.visible = false;
            }
            else if(startx > unscaledWidth)
            {
               icon.setActualSize(unscaledWidth - icon.x,icon.measuredHeight);
            }
         }
         label.x = startx;
         label.setActualSize(unscaledWidth - startx,unscaledHeight);
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            label.y = 0;
            if(Boolean(icon))
            {
               icon.y = 0;
            }
            if(Boolean(disclosureIcon))
            {
               disclosureIcon.y = 0;
            }
         }
         else if(verticalAlign == "bottom")
         {
            label.y = unscaledHeight - label.height + 2;
            if(Boolean(icon))
            {
               icon.y = unscaledHeight - icon.height;
            }
            if(Boolean(disclosureIcon))
            {
               disclosureIcon.y = unscaledHeight - disclosureIcon.height;
            }
         }
         else
         {
            label.y = (unscaledHeight - label.height) / 2;
            if(Boolean(icon))
            {
               icon.y = (unscaledHeight - icon.height) / 2;
            }
            if(Boolean(disclosureIcon))
            {
               disclosureIcon.y = (unscaledHeight - disclosureIcon.height) / 2;
            }
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
   }
}

