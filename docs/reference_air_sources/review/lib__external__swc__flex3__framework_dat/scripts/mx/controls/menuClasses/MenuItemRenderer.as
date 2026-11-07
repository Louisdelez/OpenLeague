package mx.controls.menuClasses
{
   import flash.display.DisplayObject;
   import flash.utils.getDefinitionByName;
   import mx.controls.Menu;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListData;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   
   use namespace mx_internal;
   
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class MenuItemRenderer extends UIComponent implements IDataRenderer, IListItemRenderer, IMenuItemRenderer, IDropInListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _data:Object;
      
      protected var branchIcon:IFlexDisplayObject;
      
      private var _listData:ListData;
      
      protected var typeIcon:IFlexDisplayObject;
      
      private var _menu:Menu;
      
      private var _icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      protected var separatorIcon:IFlexDisplayObject;
      
      public function MenuItemRenderer()
      {
         super();
      }
      
      public function get measuredTypeIconWidth() : Number
      {
         var typeIconClass:Class = null;
         var dataDescriptor:IMenuDataDescriptor = null;
         var isEnabled:Boolean = false;
         var typeVal:String = null;
         var typeIconWidth:Number = NaN;
         var horizontalGap:Number = getStyle("horizontalGap");
         if(Boolean(typeIcon))
         {
            return typeIcon.measuredWidth + horizontalGap;
         }
         if(Boolean(_data))
         {
            dataDescriptor = Menu(_listData.owner).dataDescriptor;
            isEnabled = dataDescriptor.isEnabled(_data);
            typeVal = dataDescriptor.getType(_data);
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
                  typeIcon = new typeIconClass();
                  typeIconWidth = typeIcon.measuredWidth;
                  typeIcon = null;
                  return typeIconWidth + horizontalGap;
               }
            }
         }
         return 0;
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return label.y + label.baselinePosition;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         createLabel(-1);
      }
      
      public function get measuredBranchIconWidth() : Number
      {
         var horizontalGap:Number = getStyle("horizontalGap");
         return Boolean(branchIcon) ? branchIcon.measuredWidth + horizontalGap : 0;
      }
      
      public function get measuredIconWidth() : Number
      {
         var horizontalGap:Number = getStyle("horizontalGap");
         return Boolean(_icon) ? _icon.measuredWidth + horizontalGap : 0;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      public function set menu(value:Menu) : void
      {
         _menu = value;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
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
         if(hasFontContextChanged() && label != null)
         {
            index = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(index);
         }
         if(Boolean(_icon))
         {
            removeChild(DisplayObject(_icon));
            _icon = null;
         }
         if(Boolean(typeIcon))
         {
            removeChild(DisplayObject(typeIcon));
            typeIcon = null;
         }
         if(Boolean(separatorIcon))
         {
            removeChild(DisplayObject(separatorIcon));
            separatorIcon = null;
         }
         if(Boolean(branchIcon))
         {
            removeChild(DisplayObject(branchIcon));
            branchIcon = null;
         }
         if(Boolean(_data))
         {
            dataDescriptor = Menu(_listData.owner).dataDescriptor;
            isEnabled = dataDescriptor.isEnabled(_data);
            type = dataDescriptor.getType(_data);
            if(type.toLowerCase() == "separator")
            {
               label.text = "";
               label.visible = false;
               separatorIconClass = getStyle("separatorSkin");
               separatorIcon = new separatorIconClass();
               addChild(DisplayObject(separatorIcon));
               return;
            }
            label.visible = true;
            if(Boolean(_listData.icon))
            {
               listDataIcon = _listData.icon;
               if(listDataIcon is Class)
               {
                  iconClass = Class(listDataIcon);
               }
               else if(listDataIcon is String)
               {
                  iconClass = Class(getDefinitionByName(String(listDataIcon)));
               }
               _icon = new iconClass();
               addChild(DisplayObject(_icon));
            }
            label.text = _listData.label;
            label.enabled = isEnabled;
            if(dataDescriptor.isToggled(_data))
            {
               typeVal = dataDescriptor.getType(_data);
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
                     typeIcon = new typeIconClass();
                     addChild(DisplayObject(typeIcon));
                  }
               }
            }
            if(dataDescriptor.isBranch(_data))
            {
               branchIconClass = getStyle(isEnabled ? "branchIcon" : "branchDisabledIcon");
               if(Boolean(branchIconClass))
               {
                  branchIcon = new branchIconClass();
                  addChild(DisplayObject(branchIcon));
               }
            }
         }
         else
         {
            label.text = " ";
         }
         invalidateDisplayList();
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = ListData(value);
         invalidateProperties();
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
      
      public function set data(value:Object) : void
      {
         _data = value;
         invalidateProperties();
         invalidateSize();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
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
         if(Boolean(separatorIcon))
         {
            measuredWidth = separatorIcon.measuredWidth;
            measuredHeight = separatorIcon.measuredHeight;
            return;
         }
         if(Boolean(_listData))
         {
            iconWidth = MenuListData(_listData).maxMeasuredIconWidth;
            typeIconWidth = MenuListData(_listData).maxMeasuredTypeIconWidth;
            branchIconWidth = MenuListData(_listData).maxMeasuredBranchIconWidth;
            useTwoColumns = MenuListData(_listData).useTwoColumns;
            leftMargin = Math.max(getStyle("leftIconGap"),useTwoColumns ? iconWidth + typeIconWidth : Math.max(iconWidth,typeIconWidth));
            rightMargin = Math.max(getStyle("rightIconGap"),branchIconWidth);
            if(isNaN(explicitWidth))
            {
               measuredWidth = label.measuredWidth + leftMargin + rightMargin + 7;
            }
            else
            {
               label.width = explicitWidth - leftMargin - rightMargin;
            }
            measuredHeight = label.measuredHeight;
            if(Boolean(_icon) && _icon.measuredHeight > measuredHeight)
            {
               measuredHeight = _icon.measuredHeight;
            }
            if(Boolean(typeIcon) && typeIcon.measuredHeight > measuredHeight)
            {
               measuredHeight = typeIcon.measuredHeight;
            }
            if(Boolean(branchIcon) && branchIcon.measuredHeight > measuredHeight)
            {
               measuredHeight = branchIcon.measuredHeight;
            }
         }
      }
      
      public function get menu() : Menu
      {
         return _menu;
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      mx_internal function createLabel(childIndex:int) : void
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
      
      protected function set icon(value:IFlexDisplayObject) : void
      {
         _icon = value;
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
         if(Boolean(_listData))
         {
            if(Menu(_listData.owner).dataDescriptor.getType(_data).toLowerCase() == "separator")
            {
               if(Boolean(separatorIcon))
               {
                  separatorIcon.x = 2;
                  separatorIcon.y = (unscaledHeight - separatorIcon.measuredHeight) / 2;
                  separatorIcon.setActualSize(unscaledWidth - 4,separatorIcon.measuredHeight);
               }
               return;
            }
            iconWidth = MenuListData(_listData).maxMeasuredIconWidth;
            typeIconWidth = MenuListData(_listData).maxMeasuredTypeIconWidth;
            branchIconWidth = MenuListData(_listData).maxMeasuredBranchIconWidth;
            useTwoColumns = MenuListData(_listData).useTwoColumns;
            leftMargin = Math.max(getStyle("leftIconGap"),useTwoColumns ? iconWidth + typeIconWidth : Math.max(iconWidth,typeIconWidth));
            rightMargin = Math.max(getStyle("rightIconGap"),branchIconWidth);
            if(useTwoColumns)
            {
               left = (leftMargin - (iconWidth + typeIconWidth)) / 2;
               if(Boolean(_icon))
               {
                  _icon.x = left + (iconWidth - _icon.measuredWidth) / 2;
                  _icon.setActualSize(_icon.measuredWidth,_icon.measuredHeight);
               }
               if(Boolean(typeIcon))
               {
                  typeIcon.x = left + iconWidth + (typeIconWidth - typeIcon.measuredWidth) / 2;
                  typeIcon.setActualSize(typeIcon.measuredWidth,typeIcon.measuredHeight);
               }
            }
            else
            {
               if(Boolean(_icon))
               {
                  _icon.x = (leftMargin - _icon.measuredWidth) / 2;
                  _icon.setActualSize(_icon.measuredWidth,_icon.measuredHeight);
               }
               if(Boolean(typeIcon))
               {
                  typeIcon.x = (leftMargin - typeIcon.measuredWidth) / 2;
                  typeIcon.setActualSize(typeIcon.measuredWidth,typeIcon.measuredHeight);
               }
            }
            if(Boolean(branchIcon))
            {
               branchIcon.x = unscaledWidth - rightMargin + (rightMargin - branchIcon.measuredWidth) / 2;
               branchIcon.setActualSize(branchIcon.measuredWidth,branchIcon.measuredHeight);
            }
            label.x = leftMargin;
            label.setActualSize(unscaledWidth - leftMargin - rightMargin,label.getExplicitOrMeasuredHeight());
            if(Boolean(_listData) && !Menu(_listData.owner).showDataTips)
            {
               label.text = _listData.label;
               if(label.truncateToFit())
               {
                  toolTip = _listData.label;
               }
               else
               {
                  toolTip = null;
               }
            }
            verticalAlign = getStyle("verticalAlign");
            if(verticalAlign == "top")
            {
               label.y = 0;
               if(Boolean(_icon))
               {
                  _icon.y = 0;
               }
               if(Boolean(typeIcon))
               {
                  typeIcon.y = 0;
               }
               if(Boolean(branchIcon))
               {
                  branchIcon.y = 0;
               }
            }
            else if(verticalAlign == "bottom")
            {
               label.y = unscaledHeight - label.height + 2;
               if(Boolean(_icon))
               {
                  _icon.y = unscaledHeight - _icon.height;
               }
               if(Boolean(typeIcon))
               {
                  typeIcon.y = unscaledHeight - typeIcon.height;
               }
               if(Boolean(branchIcon))
               {
                  branchIcon.y = unscaledHeight - branchIcon.height;
               }
            }
            else
            {
               label.y = (unscaledHeight - label.height) / 2;
               if(Boolean(_icon))
               {
                  _icon.y = (unscaledHeight - _icon.height) / 2;
               }
               if(Boolean(typeIcon))
               {
                  typeIcon.y = (unscaledHeight - typeIcon.height) / 2;
               }
               if(Boolean(branchIcon))
               {
                  branchIcon.y = (unscaledHeight - branchIcon.height) / 2;
               }
            }
            if(Boolean(data) && Boolean(parent))
            {
               if(!enabled)
               {
                  labelColor = getStyle("disabledColor");
               }
               else if(Menu(listData.owner).isItemHighlighted(listData.uid))
               {
                  labelColor = getStyle("textRollOverColor");
               }
               else if(Menu(listData.owner).isItemSelected(listData.uid))
               {
                  labelColor = getStyle("textSelectedColor");
               }
               else
               {
                  labelColor = getStyle("color");
               }
               label.setColor(labelColor);
            }
         }
      }
      
      protected function get icon() : IFlexDisplayObject
      {
         var dataDescriptor:IMenuDataDescriptor = null;
         var type:String = null;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            if(Boolean(_data))
            {
               dataDescriptor = Menu(_listData.owner).dataDescriptor;
               type = dataDescriptor.getType(_data);
               if(type.toLowerCase() == "separator")
               {
                  return separatorIcon;
               }
            }
            if(Boolean(typeIcon))
            {
               return typeIcon;
            }
            return _icon;
         }
         return _icon;
      }
      
      mx_internal function removeLabel() : void
      {
         if(Boolean(label))
         {
            removeChild(DisplayObject(label));
            label = null;
         }
      }
   }
}

