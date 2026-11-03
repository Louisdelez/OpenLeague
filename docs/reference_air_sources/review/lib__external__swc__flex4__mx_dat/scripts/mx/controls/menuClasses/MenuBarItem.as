package mx.controls.menuClasses
{
   import flash.display.DisplayObject;
   import mx.controls.MenuBar;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
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
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   public class MenuBarItem extends UIComponent implements IMenuBarItemRenderer, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var leftMargin:int = 20;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var currentSkin:IFlexDisplayObject;
      
      protected var icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var skinName:String = "itemSkin";
      
      private var defaultSkinUsesStates:Boolean = false;
      
      private var checkedDefaultSkin:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _data:Object;
      
      private var _menuBar:MenuBar;
      
      private var _menuBarItemIndex:int = -1;
      
      private var _menuBarItemState:String;
      
      private var _dataProvider:Object;
      
      public function MenuBarItem()
      {
         super();
         mouseChildren = false;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.label.y + this.label.baselinePosition;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(super.enabled == value)
         {
            return;
         }
         super.enabled = value;
         this.enabledChanged = true;
         invalidateProperties();
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
      
      public function get menuBar() : MenuBar
      {
         return this._menuBar;
      }
      
      public function set menuBar(value:MenuBar) : void
      {
         this._menuBar = value;
      }
      
      public function get menuBarItemIndex() : int
      {
         return this._menuBarItemIndex;
      }
      
      public function set menuBarItemIndex(value:int) : void
      {
         this._menuBarItemIndex = value;
      }
      
      public function get menuBarItemState() : String
      {
         return this._menuBarItemState;
      }
      
      public function set menuBarItemState(value:String) : void
      {
         this._menuBarItemState = value;
         this.viewSkin(this._menuBarItemState);
      }
      
      public function get dataProvider() : Object
      {
         return this._dataProvider;
      }
      
      [Deprecated(replacement="MenuBarItem.data")]
      public function set dataProvider(value:Object) : void
      {
         this._dataProvider = value;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         var styleDeclaration:CSSStyleDeclaration;
         super.createChildren();
         styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         styleDeclaration.factory = function():void
         {
            this.borderStyle = "none";
         };
         this.createLabel(-1);
      }
      
      override protected function commitProperties() : void
      {
         var iconClass:Class = null;
         var index:int = 0;
         var labelText:String = null;
         super.commitProperties();
         if(Boolean(hasFontContextChanged()) && this.label != null)
         {
            index = int(getChildIndex(DisplayObject(this.label)));
            this.removeLabel();
            this.createLabel(index);
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            if(Boolean(this.label))
            {
               this.label.enabled = enabled;
            }
            if(!enabled)
            {
               this.menuBarItemState = "itemUpSkin";
            }
         }
         if(Boolean(this.icon))
         {
            removeChild(DisplayObject(this.icon));
            this.icon = null;
         }
         if(Boolean(this._data))
         {
            iconClass = this.menuBar.itemToIcon(this.data);
            if(Boolean(iconClass))
            {
               this.icon = new iconClass();
               addChild(DisplayObject(this.icon));
            }
            this.label.visible = true;
            if(this.menuBar.labelFunction != null)
            {
               labelText = this.menuBar.labelFunction(this._data);
            }
            if(labelText == null)
            {
               labelText = this.menuBar.itemToLabel(this._data);
            }
            this.label.text = labelText;
            this.label.enabled = enabled;
         }
         else
         {
            this.label.text = " ";
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(Boolean(this.icon) && this.leftMargin < this.icon.measuredWidth)
         {
            this.leftMargin = this.icon.measuredWidth;
         }
         measuredWidth = this.label.getExplicitOrMeasuredWidth() + this.leftMargin;
         measuredHeight = this.label.getExplicitOrMeasuredHeight();
         if(Boolean(this.icon) && this.icon.measuredHeight > measuredHeight)
         {
            measuredHeight = this.icon.measuredHeight + 2;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.icon))
         {
            this.icon.x = (this.leftMargin - this.icon.measuredWidth) / 2;
            this.icon.setActualSize(this.icon.measuredWidth,this.icon.measuredHeight);
            this.label.x = this.leftMargin;
         }
         else
         {
            this.label.x = this.leftMargin / 2;
         }
         this.label.setActualSize(unscaledWidth - this.leftMargin,this.label.getExplicitOrMeasuredHeight());
         this.label.y = (unscaledHeight - this.label.height) / 2;
         if(Boolean(this.icon))
         {
            this.icon.y = (unscaledHeight - this.icon.height) / 2;
         }
         this.menuBarItemState = "itemUpSkin";
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createLabel(childIndex:int) : void
      {
         if(!this.label)
         {
            this.label = IUITextField(createInFontContext(UITextField));
            this.label.styleName = this;
            this.label.selectable = false;
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
      
      private function viewSkin(state:String) : void
      {
         var newSkin:IFlexDisplayObject = null;
         var newSkinClass:Class = Class(getStyle(state));
         var stateName:String = "";
         if(!newSkinClass)
         {
            newSkinClass = Class(getStyle(this.skinName));
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
            if(this.defaultSkinUsesStates)
            {
               state = this.skinName;
            }
            if(!this.checkedDefaultSkin && Boolean(newSkinClass))
            {
               newSkin = IFlexDisplayObject(new newSkinClass());
               if(!(newSkin is IProgrammaticSkin) && newSkin is IStateClient)
               {
                  this.defaultSkinUsesStates = true;
                  state = this.skinName;
               }
               if(Boolean(newSkin))
               {
                  this.checkedDefaultSkin = true;
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
         if(Boolean(this.currentSkin))
         {
            this.currentSkin.visible = false;
         }
         if(Boolean(newSkin))
         {
            newSkin.visible = true;
         }
         this.currentSkin = newSkin;
         if(this.defaultSkinUsesStates && this.currentSkin is IStateClient)
         {
            IStateClient(this.currentSkin).currentState = stateName;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLabel() : IUITextField
      {
         return this.label;
      }
   }
}

