package mx.controls.listClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.utils.PopUpUtil;
   
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class ListItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var listOwner:ListBase;
      
      private var _data:Object;
      
      protected var icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      private var _listData:ListData;
      
      public function ListItemRenderer()
      {
         super();
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,this.toolTipShowHandler);
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.label.y + this.label.baselinePosition;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = ListData(value);
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.label)
         {
            this.label = IUITextField(createInFontContext(UITextField));
            this.label.styleName = this;
            addChild(DisplayObject(this.label));
         }
      }
      
      override protected function commitProperties() : void
      {
         var iconClass:Class = null;
         super.commitProperties();
         var childIndex:int = -1;
         if(Boolean(hasFontContextChanged()) && this.label != null)
         {
            childIndex = int(getChildIndex(DisplayObject(this.label)));
            removeChild(DisplayObject(this.label));
            this.label = null;
         }
         if(!this.label)
         {
            this.label = IUITextField(createInFontContext(UITextField));
            this.label.styleName = this;
            if(childIndex == -1)
            {
               addChild(DisplayObject(this.label));
            }
            else
            {
               addChildAt(DisplayObject(this.label),childIndex);
            }
         }
         if(Boolean(this.icon))
         {
            removeChild(DisplayObject(this.icon));
            this.icon = null;
         }
         if(this._data != null)
         {
            this.listOwner = ListBase(this._listData.owner);
            if(Boolean(this._listData.icon))
            {
               iconClass = this._listData.icon;
               this.icon = new iconClass();
               addChild(DisplayObject(this.icon));
            }
            this.label.text = Boolean(this._listData.label) ? this._listData.label : " ";
            this.label.multiline = this.listOwner.variableRowHeight;
            this.label.wordWrap = this.listOwner.wordWrap;
            if(this.listOwner.showDataTips)
            {
               if(this.label.textWidth > this.label.width || this.listOwner.dataTipFunction != null)
               {
                  toolTip = this.listOwner.itemToDataTip(this._data);
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
            this.label.text = " ";
            toolTip = null;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var w:Number = 0;
         if(Boolean(this.icon))
         {
            w = Number(this.icon.measuredWidth);
         }
         if(this.label.width < 4 || this.label.height < 4)
         {
            this.label.width = 4;
            this.label.height = 16;
         }
         if(isNaN(explicitWidth))
         {
            w += this.label.getExplicitOrMeasuredWidth();
            measuredWidth = w;
            measuredHeight = this.label.getExplicitOrMeasuredHeight();
         }
         else
         {
            measuredWidth = explicitWidth;
            this.label.setActualSize(Math.max(explicitWidth - w,4),this.label.height);
            measuredHeight = this.label.getExplicitOrMeasuredHeight();
            if(Boolean(this.icon) && this.icon.measuredHeight > measuredHeight)
            {
               measuredHeight = this.icon.measuredHeight;
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var labelColor:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var startX:Number = 0;
         if(Boolean(this.icon))
         {
            this.icon.x = startX;
            startX = this.icon.x + this.icon.measuredWidth;
            this.icon.setActualSize(this.icon.measuredWidth,this.icon.measuredHeight);
         }
         this.label.x = startX;
         this.label.setActualSize(unscaledWidth - startX,measuredHeight);
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            this.label.y = 0;
            if(Boolean(this.icon))
            {
               this.icon.y = 0;
            }
         }
         else if(verticalAlign == "bottom")
         {
            this.label.y = unscaledHeight - this.label.height + 2;
            if(Boolean(this.icon))
            {
               this.icon.y = unscaledHeight - this.icon.height;
            }
         }
         else
         {
            this.label.y = (unscaledHeight - this.label.height) / 2;
            if(Boolean(this.icon))
            {
               this.icon.y = (unscaledHeight - this.icon.height) / 2;
            }
         }
         if(Boolean(this.data) && Boolean(parent))
         {
            if(!enabled)
            {
               labelColor = Number(getStyle("disabledColor"));
            }
            else if(this.listOwner.isItemHighlighted(this.listData.uid))
            {
               labelColor = Number(getStyle("textRollOverColor"));
            }
            else if(this.listOwner.isItemSelected(this.listData.uid))
            {
               labelColor = Number(getStyle("textSelectedColor"));
            }
            else
            {
               labelColor = Number(getStyle("color"));
            }
            this.label.setColor(labelColor);
         }
      }
      
      protected function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var toolTip:IToolTip = event.toolTip;
         var pt:Point = PopUpUtil.positionOverComponent(DisplayObject(this.label),systemManager,toolTip.width,toolTip.height,height / 2);
         toolTip.move(pt.x,pt.y);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return this.label;
      }
   }
}

