package mx.controls.menuClasses
{
   import flash.display.DisplayObject;
   import mx.controls.MenuBar;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class MenuBarItem extends UIComponent implements IMenuBarItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _data:Object;
      
      private var _menuBarItemIndex:int = -1;
      
      private var leftMargin:int = 20;
      
      mx_internal var currentSkin:IFlexDisplayObject;
      
      private var _dataProvider:Object;
      
      mx_internal var skinName:String = "itemSkin";
      
      private var checkedDefaultSkin:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _menuBarItemState:String;
      
      private var defaultSkinUsesStates:Boolean = false;
      
      protected var label:IUITextField;
      
      private var _menuBar:MenuBar;
      
      protected var icon:IFlexDisplayObject;
      
      public function MenuBarItem()
      {
         super();
         mouseChildren = false;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(super.enabled == value)
         {
            return;
         }
         super.enabled = value;
         enabledChanged = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         var styleDeclaration:CSSStyleDeclaration;
         super.createChildren();
         styleDeclaration = new CSSStyleDeclaration();
         styleDeclaration.factory = function():void
         {
            this.borderStyle = "none";
         };
         createLabel(-1);
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return label.y + label.baselinePosition;
      }
      
      public function get menuBarItemIndex() : int
      {
         return _menuBarItemIndex;
      }
      
      public function get menuBar() : MenuBar
      {
         return _menuBar;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return label;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      public function get dataProvider() : Object
      {
         return _dataProvider;
      }
      
      override protected function commitProperties() : void
      {
         var iconClass:Class = null;
         var index:int = 0;
         var labelText:String = null;
         super.commitProperties();
         if(hasFontContextChanged() && label != null)
         {
            index = getChildIndex(DisplayObject(label));
            removeLabel();
            createLabel(index);
         }
         if(enabledChanged)
         {
            enabledChanged = false;
            if(Boolean(label))
            {
               label.enabled = enabled;
            }
            if(!enabled)
            {
               menuBarItemState = "itemUpSkin";
            }
         }
         if(Boolean(icon))
         {
            removeChild(DisplayObject(icon));
            icon = null;
         }
         if(Boolean(_data))
         {
            iconClass = menuBar.itemToIcon(data);
            if(Boolean(iconClass))
            {
               icon = new iconClass();
               addChild(DisplayObject(icon));
            }
            label.visible = true;
            if(menuBar.labelFunction != null)
            {
               labelText = menuBar.labelFunction(_data);
            }
            if(labelText == null)
            {
               labelText = menuBar.itemToLabel(_data);
            }
            label.text = labelText;
            label.enabled = enabled;
         }
         else
         {
            label.text = " ";
         }
         invalidateDisplayList();
      }
      
      private function viewSkin(state:String) : void
      {
         var newSkin:IFlexDisplayObject = null;
         var newSkinClass:Class = Class(getStyle(state));
         var stateName:String = "";
         if(!newSkinClass)
         {
            newSkinClass = Class(getStyle(skinName));
            if(state == "itemDownSkin")
            {
               stateName = "down";
            }
            else if(state == "itemOverSkin")
            {
               stateName = "over";
            }
            else if(state == "itemUpSkin")
            {
               stateName = "up";
            }
            if(defaultSkinUsesStates)
            {
               state = skinName;
            }
            if(!checkedDefaultSkin && Boolean(newSkinClass))
            {
               newSkin = IFlexDisplayObject(new newSkinClass());
               if(!(newSkin is IProgrammaticSkin) && newSkin is IStateClient)
               {
                  defaultSkinUsesStates = true;
                  state = skinName;
               }
               if(Boolean(newSkin))
               {
                  checkedDefaultSkin = true;
               }
            }
         }
         newSkin = IFlexDisplayObject(getChildByName(state));
         if(!newSkin)
         {
            if(Boolean(newSkinClass))
            {
               newSkin = new newSkinClass();
               DisplayObject(newSkin).name = state;
               if(newSkin is ISimpleStyleClient)
               {
                  ISimpleStyleClient(newSkin).styleName = this;
               }
               addChildAt(DisplayObject(newSkin),0);
            }
         }
         newSkin.setActualSize(unscaledWidth,unscaledHeight);
         if(Boolean(currentSkin))
         {
            currentSkin.visible = false;
         }
         if(Boolean(newSkin))
         {
            newSkin.visible = true;
         }
         currentSkin = newSkin;
         if(defaultSkinUsesStates && currentSkin is IStateClient)
         {
            IStateClient(currentSkin).currentState = stateName;
         }
      }
      
      public function set menuBarItemState(value:String) : void
      {
         _menuBarItemState = value;
         viewSkin(_menuBarItemState);
      }
      
      public function set menuBarItemIndex(value:int) : void
      {
         _menuBarItemIndex = value;
      }
      
      mx_internal function removeLabel() : void
      {
         if(Boolean(label))
         {
            removeChild(DisplayObject(label));
            label = null;
         }
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
         if(Boolean(icon) && leftMargin < icon.measuredWidth)
         {
            leftMargin = icon.measuredWidth;
         }
         measuredWidth = label.getExplicitOrMeasuredWidth() + leftMargin;
         measuredHeight = label.getExplicitOrMeasuredHeight();
         if(Boolean(icon) && icon.measuredHeight > measuredHeight)
         {
            measuredHeight = icon.measuredHeight + 2;
         }
      }
      
      mx_internal function createLabel(childIndex:int) : void
      {
         if(!label)
         {
            label = IUITextField(createInFontContext(UITextField));
            label.styleName = this;
            label.selectable = false;
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
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set menuBar(value:MenuBar) : void
      {
         _menuBar = value;
      }
      
      public function get menuBarItemState() : String
      {
         return _menuBarItemState;
      }
      
      [Deprecated(replacement="MenuBarItem.data")]
      public function set dataProvider(value:Object) : void
      {
         _dataProvider = value;
         invalidateProperties();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(icon))
         {
            icon.x = (leftMargin - icon.measuredWidth) / 2;
            icon.setActualSize(icon.measuredWidth,icon.measuredHeight);
            label.x = leftMargin;
         }
         else
         {
            label.x = leftMargin / 2;
         }
         label.setActualSize(unscaledWidth - leftMargin,label.getExplicitOrMeasuredHeight());
         label.y = (unscaledHeight - label.height) / 2;
         if(Boolean(icon))
         {
            icon.y = (unscaledHeight - icon.height) / 2;
         }
         menuBarItemState = "itemUpSkin";
      }
   }
}

