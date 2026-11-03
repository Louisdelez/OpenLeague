package mx.controls
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IToggleButton;
   import mx.core.UITextField;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerGroup;
   import mx.styles.CSSStyleDeclaration;
   
   [Alternative(replacement="spark.components.RadioButton",since="4.0")]
   [ResourceBundle("controls")]
   [IconFile("RadioButton.png")]
   [AccessibilityClass(implementation="mx.accessibility.RadioButtonAccImpl")]
   [Exclude(name="toggle",kind="property")]
   [Exclude(name="emphasized",kind="property")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   public class RadioButton extends Button implements IFocusManagerGroup, IToggleButton
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var indexNumber:int = 0;
      
      private var _group:RadioButtonGroup;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _groupName:String;
      
      private var groupChanged:Boolean = false;
      
      private var _value:Object;
      
      public function RadioButton()
      {
         super();
         _labelPlacement = "";
         _toggle = true;
         this.groupName = "radioGroup";
         addEventListener(FlexEvent.ADD,this.addHandler);
         centerContent = false;
         extraSpacing = 8;
      }
      
      [Inspectable(environment="none")]
      override public function get emphasized() : Boolean
      {
         return false;
      }
      
      [Inspectable(category="General",enumeration="left,right,top,bottom",defaultValue="right")]
      [Bindable("labelPlacementChanged")]
      override public function get labelPlacement() : String
      {
         var value:String = ButtonLabelPlacement.RIGHT;
         if(_labelPlacement != "")
         {
            value = _labelPlacement;
         }
         else if(Boolean(this._group) && this._group.labelPlacement != "")
         {
            value = this._group.labelPlacement;
         }
         return value;
      }
      
      override public function set moduleFactory(factory:IFlexModuleFactory) : void
      {
         var typeSelector:CSSStyleDeclaration = null;
         super.moduleFactory = factory;
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            typeSelector = styleManager.getStyleDeclaration("mx.controls.RadioButton");
            if(Boolean(typeSelector))
            {
               if(typeSelector.getStyle("cornerRadius") === undefined)
               {
                  typeSelector.setStyle("cornerRadius",7);
               }
            }
         }
      }
      
      [Inspectable(environment="none")]
      override public function get toggle() : Boolean
      {
         return super.toggle;
      }
      
      override public function set toggle(value:Boolean) : void
      {
      }
      
      public function get group() : RadioButtonGroup
      {
         var g:RadioButtonGroup = null;
         if(!document)
         {
            return this._group;
         }
         if(!this._group)
         {
            if(Boolean(this.groupName) && this.groupName != "")
            {
               try
               {
                  g = RadioButtonGroup(document[this.groupName]);
               }
               catch(e:Error)
               {
                  if(Boolean(document.automaticRadioButtonGroups) && Boolean(document.automaticRadioButtonGroups[groupName]))
                  {
                     g = RadioButtonGroup(document.automaticRadioButtonGroups[groupName]);
                  }
               }
               if(!g)
               {
                  g = new RadioButtonGroup(IFlexDisplayObject(document));
                  if(!document.automaticRadioButtonGroups)
                  {
                     document.automaticRadioButtonGroups = {};
                  }
                  document.automaticRadioButtonGroups[this.groupName] = g;
               }
               else if(!(g is RadioButtonGroup))
               {
                  return null;
               }
               this._group = g;
            }
         }
         return this._group;
      }
      
      public function set group(value:RadioButtonGroup) : void
      {
         this._group = value;
      }
      
      [Inspectable(category="General",defaultValue="radioGroup")]
      [Bindable("groupNameChanged")]
      public function get groupName() : String
      {
         return this._groupName;
      }
      
      public function set groupName(value:String) : void
      {
         var FX_GROUP_NAME_PREFIX:String = null;
         var message:String = null;
         if(!value || value == "")
         {
            return;
         }
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            FX_GROUP_NAME_PREFIX = "_fx_";
            if(value.indexOf(FX_GROUP_NAME_PREFIX) == 0)
            {
               message = resourceManager.getString("controls","invalidGroupName",[value,FX_GROUP_NAME_PREFIX]);
               throw ArgumentError(message);
            }
         }
         this.deleteGroup();
         this._groupName = value;
         this.groupChanged = true;
         invalidateProperties();
         invalidateDisplayList();
         dispatchEvent(new Event("groupNameChanged"));
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("valueChanged")]
      public function get value() : Object
      {
         return this._value;
      }
      
      public function set value(value:Object) : void
      {
         this._value = value;
         dispatchEvent(new Event("valueChanged"));
         if(selected && Boolean(this.group))
         {
            this.group.dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(RadioButton.createAccessibilityImplementation != null)
         {
            RadioButton.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.groupChanged)
         {
            this.addToGroup();
            this.groupChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var lineMetrics:TextLineMetrics = null;
         var textH:Number = NaN;
         super.measure();
         if(!label && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0 && getQualifiedClassName(currentIcon).indexOf(".spark") >= 0)
         {
            lineMetrics = measureText(label);
            textH = lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
            textH += getStyle("paddingTop") + getStyle("paddingBottom");
            measuredMinHeight = measuredHeight = Math.max(textH,measuredMinHeight);
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.groupChanged)
         {
            this.addToGroup();
            this.groupChanged = false;
         }
         if(Boolean(this._group) && Boolean(_selected) && this._group.selection != this)
         {
            this.group.setSelection(this,false);
         }
      }
      
      private function addToGroup() : Object
      {
         var g:RadioButtonGroup = this.group;
         if(Boolean(g))
         {
            g.addInstance(this);
         }
         return g;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function deleteGroup() : void
      {
         try
         {
            if(Boolean(document[this.groupName]))
            {
               delete document[this.groupName];
            }
         }
         catch(e:Error)
         {
            try
            {
               if(Boolean(document.automaticRadioButtonGroups[groupName]))
               {
                  delete document.automaticRadioButtonGroups[groupName];
               }
            }
            catch(e1:Error)
            {
            }
         }
      }
      
      private function setPrev(moveSelection:Boolean = true) : void
      {
         var radioButton:RadioButton = null;
         var g:RadioButtonGroup = this.group;
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         for(var i:int = 1; i <= this.indexNumber; i++)
         {
            radioButton = g.getRadioButtonAt(this.indexNumber - i);
            if(Boolean(radioButton) && radioButton.enabled)
            {
               if(moveSelection)
               {
                  g.setSelection(radioButton);
               }
               radioButton.setFocus();
               return;
            }
         }
         if(moveSelection && g.getRadioButtonAt(this.indexNumber) != g.selection)
         {
            g.setSelection(this);
         }
         this.drawFocus(true);
      }
      
      private function setNext(moveSelection:Boolean = true) : void
      {
         var radioButton:RadioButton = null;
         var g:RadioButtonGroup = this.group;
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         for(var i:int = this.indexNumber + 1; i < g.numRadioButtons; i++)
         {
            radioButton = g.getRadioButtonAt(i);
            if(Boolean(radioButton) && radioButton.enabled)
            {
               if(moveSelection)
               {
                  g.setSelection(radioButton);
               }
               radioButton.setFocus();
               return;
            }
         }
         if(moveSelection && g.getRadioButtonAt(this.indexNumber) != g.selection)
         {
            g.setSelection(this);
         }
         this.drawFocus(true);
      }
      
      private function setThis() : void
      {
         if(!this._group)
         {
            this.addToGroup();
         }
         var g:RadioButtonGroup = this.group;
         if(g.selection != this)
         {
            g.setSelection(this);
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         switch(keyCode)
         {
            case Keyboard.DOWN:
               this.setNext(!event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.UP:
               this.setPrev(!event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.LEFT:
               this.setPrev(!event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.RIGHT:
               this.setNext(!event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
               this.setThis();
               _toggle = false;
            default:
               super.keyDownHandler(event);
         }
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         super.keyUpHandler(event);
         if(event.keyCode == Keyboard.SPACE && !_toggle)
         {
            _toggle = true;
         }
      }
      
      private function addHandler(event:FlexEvent) : void
      {
         if(!this._group && Boolean(initialized))
         {
            this.addToGroup();
         }
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         if(!enabled || selected)
         {
            return;
         }
         if(!this._group)
         {
            this.addToGroup();
         }
         super.clickHandler(event);
         this.group.setSelection(this);
         var itemClickEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         itemClickEvent.label = label;
         itemClickEvent.index = this.indexNumber;
         itemClickEvent.relatedObject = this;
         itemClickEvent.item = this.value;
         this.group.dispatchEvent(itemClickEvent);
      }
   }
}

