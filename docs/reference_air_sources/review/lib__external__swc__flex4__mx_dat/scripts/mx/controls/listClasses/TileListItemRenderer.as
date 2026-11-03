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
   
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class TileListItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var listOwner:TileBase;
      
      private var iconClass:Class;
      
      private var iconOnly:Boolean = false;
      
      private var _data:Object;
      
      protected var icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      private var _listData:ListData;
      
      public function TileListItemRenderer()
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
         this.createLabel(-1);
      }
      
      override protected function commitProperties() : void
      {
         var index:int = 0;
         var newIconClass:Class = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.label != null)
         {
            index = int(getChildIndex(DisplayObject(this.label)));
            this.removeLabel();
            this.createLabel(index);
         }
         if(Boolean(this.icon) && !this._data)
         {
            removeChild(DisplayObject(this.icon));
            this.icon = null;
            this.iconClass = null;
         }
         if(Boolean(this._data))
         {
            this.listOwner = TileBase(this._listData.owner);
            if(Boolean(this._listData.icon))
            {
               newIconClass = this._listData.icon;
               if(this.iconClass != newIconClass)
               {
                  this.iconClass = newIconClass;
                  if(Boolean(this.icon))
                  {
                     removeChild(DisplayObject(this.icon));
                  }
                  this.icon = new this.iconClass();
                  addChild(DisplayObject(this.icon));
               }
            }
            this.label.text = this._listData.label;
            this.label.multiline = this.listOwner.variableRowHeight;
            this.label.wordWrap = this.listOwner.wordWrap;
         }
         else
         {
            this.label.text = " ";
            toolTip = null;
         }
      }
      
      override protected function measure() : void
      {
         var paddingLeft:Number = NaN;
         super.measure();
         var h:Number = 0;
         if(Boolean(this.icon))
         {
            h += this.icon.measuredHeight;
         }
         if(this.label.text == "" || this.label.text == " " || this.label.text == null)
         {
            this.label.explicitHeight = 0;
            this.iconOnly = true;
         }
         else
         {
            this.label.explicitHeight = NaN;
            h += getStyle("verticalGap");
            this.iconOnly = false;
         }
         measuredHeight = this.label.getExplicitOrMeasuredHeight() + h;
         paddingLeft = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         measuredWidth = this.label.getExplicitOrMeasuredWidth() + paddingLeft + paddingRight;
         if(Boolean(this.icon) && this.icon.measuredWidth + paddingLeft + paddingRight > measuredWidth)
         {
            measuredWidth = this.icon.measuredWidth + paddingLeft + paddingRight;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var startY:Number = NaN;
         var labelColor:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var verticalGap:Number = this.iconOnly ? 0 : Number(getStyle("verticalGap"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         if(Boolean(this.icon))
         {
            this.icon.width = Math.min(unscaledWidth - (paddingLeft + paddingRight),this.icon.measuredWidth);
            this.icon.height = Math.min(Math.max(unscaledHeight - verticalGap - this.label.getExplicitOrMeasuredHeight(),0),this.icon.measuredHeight);
            this.icon.x = paddingLeft + (unscaledWidth - paddingLeft - paddingRight - this.icon.width) / 2;
         }
         this.label.width = unscaledWidth - (paddingLeft + paddingRight);
         this.label.height = Math.min(this.label.getExplicitOrMeasuredHeight(),Boolean(this.icon) ? Math.max(unscaledHeight - verticalGap - this.icon.height,0) : unscaledHeight);
         this.label.x = paddingLeft;
         if(Boolean(this.listOwner) && this.listOwner.showDataTips)
         {
            if(Boolean(this.label.textWidth > this.label.width) || Boolean(this.listOwner.dataTipField && this.listOwner.dataTipField != "label") || this.listOwner.dataTipFunction != null)
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
         var totalHeight:Number = Number(this.label.height);
         if(Boolean(this.icon))
         {
            totalHeight += this.icon.height + verticalGap;
         }
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            startY = 0;
            if(Boolean(this.icon))
            {
               this.icon.y = startY;
               startY += verticalGap + this.icon.height;
            }
            this.label.y = startY;
         }
         else if(verticalAlign == "bottom")
         {
            startY = unscaledHeight - this.label.height;
            this.label.y = startY;
            if(Boolean(this.icon))
            {
               startY -= verticalGap + this.icon.height;
               this.icon.y = startY;
            }
         }
         else
         {
            startY = (unscaledHeight - totalHeight) / 2;
            if(Boolean(this.icon))
            {
               this.icon.y = startY;
               startY += verticalGap + this.icon.height;
            }
            this.label.y = startY;
         }
         if(Boolean(this.data) && Boolean(parent))
         {
            if(!enabled)
            {
               labelColor = Number(getStyle("disabledColor"));
            }
            else if(this.listOwner.isItemSelected(this.listData.uid))
            {
               labelColor = Number(getStyle("textSelectedColor"));
            }
            else if(this.listOwner.isItemHighlighted(this.listData.uid))
            {
               labelColor = Number(getStyle("textRollOverColor"));
            }
            else
            {
               labelColor = Number(getStyle("color"));
            }
            this.label.setColor(labelColor);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createLabel(childIndex:int) : void
      {
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
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeLabel() : void
      {
         if(Boolean(this.label))
         {
            removeChild(DisplayObject(this.label));
            this.label = null;
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

