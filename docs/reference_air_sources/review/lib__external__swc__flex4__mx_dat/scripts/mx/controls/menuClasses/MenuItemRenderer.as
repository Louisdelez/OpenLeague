package mx.controls.menuClasses
{
   import flash.display.DisplayObject;
   import flash.utils.getDefinitionByName;
   import mx.controls.Menu;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListData;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class MenuItemRenderer extends UIComponent implements IDataRenderer, IListItemRenderer, IMenuItemRenderer, IDropInListItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      protected var branchIcon:IFlexDisplayObject;
      
      private var _data:Object;
      
      private var _icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      private var _listData:ListData;
      
      private var _menu:Menu;
      
      protected var separatorIcon:IFlexDisplayObject;
      
      protected var typeIcon:IFlexDisplayObject;
      
      public function MenuItemRenderer()
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
         invalidateSize();
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
      
      protected function get icon() : IFlexDisplayObject
      {
         return this._icon;
      }
      
      protected function set icon(value:IFlexDisplayObject) : void
      {
         this._icon = value;
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
      
      public function get menu() : Menu
      {
         return this._menu;
      }
      
      public function set menu(value:Menu) : void
      {
         this._menu = value;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createLabel(-1);
      }
      
      override protected function commitProperties() : void
      {
         var iconClass:Class = null;
         var typeIconClass:Class = null;
         var separatorIconClass:Class = null;
         var branchIconClass:Class = null;
         var index:int = 0;
         var dataDescriptor:IMenuDataDescriptor = null;
         var isEnabled:Boolean = false;
         var type:String = null;
         var listDataIcon:Object = null;
         var typeVal:String = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.label != null)
         {
            index = int(getChildIndex(DisplayObject(this.label)));
            this.removeLabel();
            this.createLabel(index);
         }
         if(Boolean(this._icon))
         {
            removeChild(DisplayObject(this._icon));
            this._icon = null;
         }
         if(Boolean(this.typeIcon))
         {
            removeChild(DisplayObject(this.typeIcon));
            this.typeIcon = null;
         }
         if(Boolean(this.separatorIcon))
         {
            removeChild(DisplayObject(this.separatorIcon));
            this.separatorIcon = null;
         }
         if(Boolean(this.branchIcon))
         {
            removeChild(DisplayObject(this.branchIcon));
            this.branchIcon = null;
         }
         if(Boolean(this._data))
         {
            dataDescriptor = Menu(this._listData.owner).dataDescriptor;
            isEnabled = Boolean(dataDescriptor.isEnabled(this._data));
            type = dataDescriptor.getType(this._data);
            if(type.toLowerCase() == "separator")
            {
               this.label.text = "";
               this.label.visible = false;
               separatorIconClass = getStyle("separatorSkin");
               this.separatorIcon = new separatorIconClass();
               addChild(DisplayObject(this.separatorIcon));
               return;
            }
            this.label.visible = true;
            if(Boolean(this._listData.icon))
            {
               listDataIcon = this._listData.icon;
               if(listDataIcon is Class)
               {
                  iconClass = Class(listDataIcon);
               }
               else if(listDataIcon is String)
               {
                  iconClass = Class(getDefinitionByName(String(listDataIcon)));
               }
               this._icon = new iconClass();
               addChild(DisplayObject(this._icon));
            }
            this.label.text = this._listData.label;
            this.label.enabled = isEnabled;
            if(dataDescriptor.isToggled(this._data))
            {
               typeVal = dataDescriptor.getType(this._data);
               if(Boolean(typeVal))
               {
                  typeVal = typeVal.toLowerCase();
                  if(typeVal == "radio")
                  {
                     typeIconClass = getStyle(isEnabled ? "radioIcon" : "radioDisabledIcon");
                  }
                  else if(typeVal == "check")
                  {
                     typeIconClass = getStyle(isEnabled ? "checkIcon" : "checkDisabledIcon");
                  }
                  if(Boolean(typeIconClass))
                  {
                     this.typeIcon = new typeIconClass();
                     addChild(DisplayObject(this.typeIcon));
                  }
               }
            }
            if(dataDescriptor.isBranch(this._data))
            {
               branchIconClass = getStyle(isEnabled ? "branchIcon" : "branchDisabledIcon");
               if(Boolean(branchIconClass))
               {
                  this.branchIcon = new branchIconClass();
                  addChild(DisplayObject(this.branchIcon));
               }
            }
         }
         else
         {
            this.label.text = " ";
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var iconWidth:Number = NaN;
         var typeIconWidth:Number = NaN;
         var branchIconWidth:Number = NaN;
         var useTwoColumns:Boolean = false;
         var leftMargin:Number = NaN;
         var rightMargin:Number = NaN;
         super.measure();
         if(Boolean(this.separatorIcon))
         {
            measuredWidth = this.separatorIcon.measuredWidth;
            measuredHeight = this.separatorIcon.measuredHeight;
            return;
         }
         if(Boolean(this._listData))
         {
            iconWidth = MenuListData(this._listData).maxMeasuredIconWidth;
            typeIconWidth = MenuListData(this._listData).maxMeasuredTypeIconWidth;
            branchIconWidth = MenuListData(this._listData).maxMeasuredBranchIconWidth;
            useTwoColumns = MenuListData(this._listData).useTwoColumns;
            leftMargin = Math.max(getStyle("leftIconGap"),useTwoColumns ? iconWidth + typeIconWidth : Math.max(iconWidth,typeIconWidth));
            rightMargin = Math.max(getStyle("rightIconGap"),branchIconWidth);
            if(isNaN(explicitWidth))
            {
               measuredWidth = this.label.measuredWidth + leftMargin + rightMargin + 7;
            }
            else
            {
               this.label.width = explicitWidth - leftMargin - rightMargin;
            }
            measuredHeight = this.label.measuredHeight;
            if(Boolean(this._icon) && this._icon.measuredHeight > measuredHeight)
            {
               measuredHeight = this._icon.measuredHeight;
            }
            if(Boolean(this.typeIcon) && this.typeIcon.measuredHeight > measuredHeight)
            {
               measuredHeight = this.typeIcon.measuredHeight;
            }
            if(Boolean(this.branchIcon) && this.branchIcon.measuredHeight > measuredHeight)
            {
               measuredHeight = this.branchIcon.measuredHeight;
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var iconWidth:Number = NaN;
         var typeIconWidth:Number = NaN;
         var branchIconWidth:Number = NaN;
         var useTwoColumns:Boolean = false;
         var leftMargin:Number = NaN;
         var rightMargin:Number = NaN;
         var verticalAlign:String = null;
         var labelColor:Number = NaN;
         var left:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this._listData))
         {
            if(Menu(this._listData.owner).dataDescriptor.getType(this._data).toLowerCase() == "separator")
            {
               if(Boolean(this.separatorIcon))
               {
                  this.separatorIcon.x = 2;
                  this.separatorIcon.y = (unscaledHeight - this.separatorIcon.measuredHeight) / 2;
                  this.separatorIcon.setActualSize(unscaledWidth - 4,this.separatorIcon.measuredHeight);
               }
               return;
            }
            iconWidth = MenuListData(this._listData).maxMeasuredIconWidth;
            typeIconWidth = MenuListData(this._listData).maxMeasuredTypeIconWidth;
            branchIconWidth = MenuListData(this._listData).maxMeasuredBranchIconWidth;
            useTwoColumns = MenuListData(this._listData).useTwoColumns;
            leftMargin = Math.max(getStyle("leftIconGap"),useTwoColumns ? iconWidth + typeIconWidth : Math.max(iconWidth,typeIconWidth));
            rightMargin = Math.max(getStyle("rightIconGap"),branchIconWidth);
            if(useTwoColumns)
            {
               left = (leftMargin - (iconWidth + typeIconWidth)) / 2;
               if(Boolean(this._icon))
               {
                  this._icon.x = left + (iconWidth - this._icon.measuredWidth) / 2;
                  this._icon.setActualSize(this._icon.measuredWidth,this._icon.measuredHeight);
               }
               if(Boolean(this.typeIcon))
               {
                  this.typeIcon.x = left + iconWidth + (typeIconWidth - this.typeIcon.measuredWidth) / 2;
                  this.typeIcon.setActualSize(this.typeIcon.measuredWidth,this.typeIcon.measuredHeight);
               }
            }
            else
            {
               if(Boolean(this._icon))
               {
                  this._icon.x = (leftMargin - this._icon.measuredWidth) / 2;
                  this._icon.setActualSize(this._icon.measuredWidth,this._icon.measuredHeight);
               }
               if(Boolean(this.typeIcon))
               {
                  this.typeIcon.x = (leftMargin - this.typeIcon.measuredWidth) / 2;
                  this.typeIcon.setActualSize(this.typeIcon.measuredWidth,this.typeIcon.measuredHeight);
               }
            }
            if(Boolean(this.branchIcon))
            {
               this.branchIcon.x = unscaledWidth - rightMargin + (rightMargin - this.branchIcon.measuredWidth) / 2;
               this.branchIcon.setActualSize(this.branchIcon.measuredWidth,this.branchIcon.measuredHeight);
            }
            this.label.x = leftMargin;
            this.label.setActualSize(unscaledWidth - leftMargin - rightMargin,this.label.getExplicitOrMeasuredHeight());
            if(Boolean(this._listData) && !Menu(this._listData.owner).showDataTips)
            {
               this.label.text = this._listData.label;
               if(this.label.truncateToFit())
               {
                  toolTip = this._listData.label;
               }
               else
               {
                  toolTip = null;
               }
            }
            verticalAlign = getStyle("verticalAlign");
            if(verticalAlign == "top")
            {
               this.label.y = 0;
               if(Boolean(this._icon))
               {
                  this._icon.y = 0;
               }
               if(Boolean(this.typeIcon))
               {
                  this.typeIcon.y = 0;
               }
               if(Boolean(this.branchIcon))
               {
                  this.branchIcon.y = 0;
               }
            }
            else if(verticalAlign == "bottom")
            {
               this.label.y = unscaledHeight - this.label.height + 2;
               if(Boolean(this._icon))
               {
                  this._icon.y = unscaledHeight - this._icon.height;
               }
               if(Boolean(this.typeIcon))
               {
                  this.typeIcon.y = unscaledHeight - this.typeIcon.height;
               }
               if(Boolean(this.branchIcon))
               {
                  this.branchIcon.y = unscaledHeight - this.branchIcon.height;
               }
            }
            else
            {
               this.label.y = (unscaledHeight - this.label.height) / 2;
               if(Boolean(this._icon))
               {
                  this._icon.y = (unscaledHeight - this._icon.height) / 2;
               }
               if(Boolean(this.typeIcon))
               {
                  this.typeIcon.y = (unscaledHeight - this.typeIcon.height) / 2;
               }
               if(Boolean(this.branchIcon))
               {
                  this.branchIcon.y = (unscaledHeight - this.branchIcon.height) / 2;
               }
            }
            if(Boolean(this.data) && Boolean(parent))
            {
               if(!enabled)
               {
                  labelColor = Number(getStyle("disabledColor"));
               }
               else if(Menu(this.listData.owner).isItemHighlighted(this.listData.uid))
               {
                  labelColor = Number(getStyle("textRollOverColor"));
               }
               else if(Menu(this.listData.owner).isItemSelected(this.listData.uid))
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
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!styleProp || styleProp == "styleName" || styleProp.toLowerCase().indexOf("icon") != -1)
         {
            invalidateSize();
            invalidateDisplayList();
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return this.label;
      }
      
      public function get measuredIconWidth() : Number
      {
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         return Boolean(this._icon) ? this._icon.measuredWidth + horizontalGap : 0;
      }
      
      public function get measuredTypeIconWidth() : Number
      {
         var typeIconClass:Class = null;
         var dataDescriptor:IMenuDataDescriptor = null;
         var isEnabled:Boolean = false;
         var typeVal:String = null;
         var typeIconWidth:Number = NaN;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         if(Boolean(this.typeIcon))
         {
            return this.typeIcon.measuredWidth + horizontalGap;
         }
         if(Boolean(this._data))
         {
            dataDescriptor = Menu(this._listData.owner).dataDescriptor;
            isEnabled = Boolean(dataDescriptor.isEnabled(this._data));
            typeVal = dataDescriptor.getType(this._data);
            if(Boolean(typeVal))
            {
               typeVal = typeVal.toLowerCase();
               if(typeVal == "radio")
               {
                  typeIconClass = getStyle(isEnabled ? "radioIcon" : "radioDisabledIcon");
               }
               else if(typeVal == "check")
               {
                  typeIconClass = getStyle(isEnabled ? "checkIcon" : "checkDisabledIcon");
               }
               if(Boolean(typeIconClass))
               {
                  this.typeIcon = new typeIconClass();
                  typeIconWidth = Number(this.typeIcon.measuredWidth);
                  this.typeIcon = null;
                  return typeIconWidth + horizontalGap;
               }
            }
         }
         return 0;
      }
      
      public function get measuredBranchIconWidth() : Number
      {
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         return Boolean(this.branchIcon) ? this.branchIcon.measuredWidth + horizontalGap : 0;
      }
   }
}

