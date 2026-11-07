package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityProperties;
   import flash.events.Event;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class UIComponentAccProps extends AccessibilityProperties
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var oldToolTip:String;
      
      private var oldErrorString:String;
      
      protected var master:UIComponent;
      
      public function UIComponentAccProps(component:UIComponent)
      {
         super();
         this.master = component;
         if(Boolean(component.accessibilityProperties))
         {
            silent = component.accessibilityProperties.silent;
            forceSimple = component.accessibilityProperties.forceSimple;
            noAutoLabeling = component.accessibilityProperties.noAutoLabeling;
            if(Boolean(component.accessibilityProperties.name))
            {
               name = component.accessibilityProperties.name;
            }
            if(Boolean(component.accessibilityProperties.description))
            {
               description = component.accessibilityProperties.description;
            }
            if(Boolean(component.accessibilityProperties.shortcut))
            {
               shortcut = component.accessibilityProperties.shortcut;
            }
         }
         if(Boolean(AccImpl.getMatchingDefinition(this.master,AccImpl.getDefinitions("ScrollBar",this.master.moduleFactory))))
         {
            silent = true;
            return;
         }
         if(this.isFormItemLabel(this.master))
         {
            name = AccImpl.getFormName(this.master);
            silent = true;
            return;
         }
         if(mx_internal::componentShouldBeSilent(component))
         {
            name = "";
            return;
         }
         if(AccImpl.isFormHeading(this.master) && this.master.tabIndex > 0)
         {
            try
            {
               if(Object(this.master).labelDisplay.tabIndex == -1)
               {
                  Object(this.master).labelDisplay.tabIndex = this.master.tabIndex;
               }
            }
            catch(e:Error)
            {
            }
         }
         var formName:String = AccImpl.getFormName(this.master);
         if(Boolean(formName) && formName.length != 0)
         {
            name = formName + name;
         }
         if(Boolean(this.master.toolTip) && this.master.toolTip.length != 0)
         {
            if(!component.accessibilityProperties || Boolean(component.accessibilityProperties) && Boolean(!component.accessibilityProperties.name))
            {
               this.oldToolTip = " " + this.master.toolTip;
               name += this.oldToolTip;
            }
         }
         if(Boolean(this.master.errorString) && this.master.errorString.length != 0)
         {
            this.oldErrorString = " " + this.master.errorString;
            name += this.oldErrorString;
         }
         this.master.addEventListener("toolTipChanged",this.eventHandler);
         this.master.addEventListener("errorStringChanged",this.eventHandler);
      }
      
      public static function enableAccessibility() : void
      {
         UIComponent.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityProperties = new UIComponentAccProps(component);
      }
      
      mx_internal static function componentShouldBeSilent(component:UIComponent) : Boolean
      {
         var groupClass:Class = Class(AccImpl.getDefinition("spark.components.Group",component.moduleFactory));
         if(!groupClass)
         {
            return false;
         }
         var formItem:UIComponent = AccImpl.findMatchingAncestor(component,AccImpl.isFormItem);
         if(!formItem)
         {
            return false;
         }
         try
         {
            if(component is groupClass && component.parent.parent === formItem)
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         var imageClass:Class = Class(AccImpl.getDefinition("spark.components.Image",component.moduleFactory));
         if(!imageClass)
         {
            return false;
         }
         try
         {
            if(component is imageClass && component.parent is groupClass && component.parent.parent.parent === formItem)
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      protected function isFormItemLabel(component:UIComponent) : Boolean
      {
         var thisName:String = this.master.name;
         if(thisName == "labelDisplay" || thisName == "sequenceLabelDisplay" || thisName == "helpContentGroup" || thisName == "errorTextDisplay")
         {
            return true;
         }
         return Boolean(AccImpl.getMatchingDefinition(this.master,AccImpl.getDefinitions("FormItemLabel",this.master.moduleFactory)));
      }
      
      protected function eventHandler(event:Event) : void
      {
         var pos:int = 0;
         switch(event.type)
         {
            case "errorStringChanged":
               if(Boolean(name) && Boolean(name.length != 0) && Boolean(this.oldErrorString))
               {
                  pos = name.indexOf(this.oldErrorString);
                  if(pos != -1)
                  {
                     name = name.substring(0,pos) + name.substring(pos + this.oldErrorString.length);
                  }
                  this.oldErrorString = null;
               }
               if(Boolean(this.master.errorString) && this.master.errorString.length != 0)
               {
                  if(!name)
                  {
                     name = "";
                  }
                  this.oldErrorString = " " + this.master.errorString;
                  name += this.oldErrorString;
               }
               Accessibility.updateProperties();
               break;
            case "toolTipChanged":
               if(Boolean(name) && Boolean(name.length != 0) && Boolean(this.oldToolTip))
               {
                  pos = name.indexOf(this.oldToolTip);
                  if(pos != -1)
                  {
                     name = name.substring(0,pos) + name.substring(pos + this.oldToolTip.length);
                  }
                  this.oldToolTip = null;
               }
               if(Boolean(this.master.toolTip) && this.master.toolTip.length != 0)
               {
                  if(!this.master.accessibilityProperties || Boolean(this.master.accessibilityProperties) && Boolean(!this.master.accessibilityProperties.name))
                  {
                     if(!name)
                     {
                        name = "";
                     }
                     this.oldToolTip = " " + this.master.toolTip;
                     name += this.oldToolTip;
                  }
               }
               Accessibility.updateProperties();
         }
      }
   }
}

