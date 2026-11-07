package mx.controls.treeClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.controls.Tree;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.events.TreeEvent;
   import mx.utils.PopUpUtil;
   
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class TreeItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var listOwner:Tree;
      
      private var _data:Object;
      
      protected var disclosureIcon:IFlexDisplayObject;
      
      protected var icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      private var _listData:TreeListData;
      
      public function TreeItemRenderer()
      {
         super();
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
         this._listData = TreeListData(value);
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createLabel(-1);
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,this.toolTipShowHandler);
      }
      
      override protected function commitProperties() : void
      {
         var index:int = 0;
         var disclosureIconClass:Class = null;
         var disclosureInstance:* = undefined;
         var wrapper:SpriteAsset = null;
         var iconClass:Class = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.label != null)
         {
            index = int(getChildIndex(DisplayObject(this.label)));
            this.removeLabel();
            this.createLabel(index);
         }
         if(Boolean(this.icon))
         {
            removeChild(DisplayObject(this.icon));
            this.icon = null;
         }
         if(Boolean(this.disclosureIcon))
         {
            this.disclosureIcon.removeEventListener(MouseEvent.MOUSE_DOWN,this.disclosureIcon_mouseDownHandler);
            this.disclosureIcon.removeEventListener(MouseEvent.CLICK,this.disclosureIcon_clickHandler);
            removeChild(DisplayObject(this.disclosureIcon));
            this.disclosureIcon = null;
         }
         if(this._data != null)
         {
            this.listOwner = Tree(this._listData.owner);
            if(Boolean(this._listData.disclosureIcon))
            {
               disclosureIconClass = this._listData.disclosureIcon;
               disclosureInstance = new disclosureIconClass();
               if(!(disclosureInstance is InteractiveObject))
               {
                  wrapper = new SpriteAsset();
                  wrapper.addChild(disclosureInstance as DisplayObject);
                  this.disclosureIcon = wrapper as IFlexDisplayObject;
               }
               else
               {
                  this.disclosureIcon = disclosureInstance;
               }
               if(this.disclosureIcon is ILayoutDirectionElement)
               {
                  ILayoutDirectionElement(this.disclosureIcon).layoutDirection = null;
               }
               addChild(this.disclosureIcon as DisplayObject);
               this.disclosureIcon.addEventListener(MouseEvent.MOUSE_DOWN,this.disclosureIcon_mouseDownHandler);
               this.disclosureIcon.addEventListener(MouseEvent.CLICK,this.disclosureIcon_clickHandler);
            }
            if(Boolean(this._listData.icon))
            {
               iconClass = this._listData.icon;
               this.icon = new iconClass();
               addChild(DisplayObject(this.icon));
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
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         super.measure();
         var w:Number = Boolean(this._data) ? this._listData.indent : 0;
         if(Boolean(this.disclosureIcon))
         {
            w += this.disclosureIcon.width;
         }
         if(Boolean(this.icon))
         {
            w += this.icon.measuredWidth;
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
            this.label.width = Math.max(explicitWidth - w,4);
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
         var startx:Number = Boolean(this._data) ? this._listData.indent : 0;
         if(Boolean(this.disclosureIcon))
         {
            this.disclosureIcon.x = startx;
            startx = this.disclosureIcon.x + this.disclosureIcon.width;
            this.disclosureIcon.setActualSize(this.disclosureIcon.width,this.disclosureIcon.height);
            this.disclosureIcon.visible = Boolean(this._data) ? this._listData.hasChildren : false;
         }
         if(Boolean(this.icon))
         {
            this.icon.x = startx;
            startx = this.icon.x + this.icon.measuredWidth;
            this.icon.setActualSize(this.icon.measuredWidth,this.icon.measuredHeight);
         }
         this.label.x = startx;
         this.label.setActualSize(unscaledWidth - startx,measuredHeight);
         var verticalAlign:String = getStyle("verticalAlign");
         if(verticalAlign == "top")
         {
            this.label.y = 0;
            if(Boolean(this.icon))
            {
               this.icon.y = 0;
            }
            if(Boolean(this.disclosureIcon))
            {
               this.disclosureIcon.y = 0;
            }
         }
         else if(verticalAlign == "bottom")
         {
            this.label.y = unscaledHeight - this.label.height + 2;
            if(Boolean(this.icon))
            {
               this.icon.y = unscaledHeight - this.icon.height;
            }
            if(Boolean(this.disclosureIcon))
            {
               this.disclosureIcon.y = unscaledHeight - this.disclosureIcon.height;
            }
         }
         else
         {
            this.label.y = (unscaledHeight - this.label.height) / 2;
            if(Boolean(this.icon))
            {
               this.icon.y = (unscaledHeight - this.icon.height) / 2;
            }
            if(Boolean(this.disclosureIcon))
            {
               this.disclosureIcon.y = (unscaledHeight - this.disclosureIcon.height) / 2;
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
         if(this._data != null)
         {
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
         if(this.label != null)
         {
            removeChild(DisplayObject(this.label));
            this.label = null;
         }
      }
      
      private function toolTipShowHandler(event:ToolTipEvent) : void
      {
         var toolTip:IToolTip = event.toolTip;
         var pt:Point = PopUpUtil.positionOverComponent(DisplayObject(this.label),systemManager,toolTip.width,toolTip.height,height / 2);
         toolTip.move(pt.x,pt.y);
      }
      
      private function disclosureIcon_mouseDownHandler(event:Event) : void
      {
         event.stopPropagation();
         if(this.listOwner.isOpening || !this.listOwner.enabled)
         {
            return;
         }
         var open:Boolean = this._listData.open;
         this._listData.open = !open;
         this.listOwner.dispatchTreeEvent(TreeEvent.ITEM_OPENING,this._listData.item,this,event,!open,true,true);
      }
      
      private function disclosureIcon_clickHandler(event:Event) : void
      {
         event.stopPropagation();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return this.label;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDisclosureIcon() : IFlexDisplayObject
      {
         return this.disclosureIcon;
      }
   }
}

