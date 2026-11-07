package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityProperties;
   import flash.events.Event;
   import mx.controls.FormItemLabel;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class UIComponentAccProps extends AccessibilityProperties
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      protected var master:UIComponent;
      
      private var oldErrorString:String;
      
      private var oldToolTip:String;
      
      public function UIComponentAccProps(component:UIComponent)
      {
         var formName:String = null;
         super();
         master = component;
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
         if(master is ScrollBar)
         {
            silent = true;
         }
         else if(master is FormItemLabel)
         {
            name = AccImpl.getFormName(master);
            silent = true;
         }
         else
         {
            formName = AccImpl.getFormName(master);
            if(Boolean(formName) && formName.length != 0)
            {
               name = formName + name;
            }
            if(Boolean(master.toolTip) && master.toolTip.length != 0)
            {
               oldToolTip = " " + master.toolTip;
               name += oldToolTip;
            }
            if(Boolean(master.errorString) && master.errorString.length != 0)
            {
               oldErrorString = " " + master.errorString;
               name += oldErrorString;
            }
            master.addEventListener("toolTipChanged",eventHandler);
            master.addEventListener("errorStringChanged",eventHandler);
         }
      }
      
      public static function enableAccessibility() : void
      {
         UIComponent.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(component:UIComponent) : void
      {
         component.accessibilityProperties = new UIComponentAccProps(component);
      }
      
      protected function eventHandler(event:Event) : void
      {
         var pos:int = 0;
         switch(event.type)
         {
            case "errorStringChanged":
               if(Boolean(name) && Boolean(name.length != 0) && Boolean(oldErrorString))
               {
                  pos = name.indexOf(oldErrorString);
                  if(pos != -1)
                  {
                     name = name.substring(0,pos) + name.substring(pos + oldErrorString.length);
                  }
                  oldErrorString = null;
               }
               if(Boolean(master.errorString) && master.errorString.length != 0)
               {
                  if(!name)
                  {
                     name = "";
                  }
                  oldErrorString = " " + master.errorString;
                  name += oldErrorString;
               }
               Accessibility.updateProperties();
               break;
            case "toolTipChanged":
               if(Boolean(name) && Boolean(name.length != 0) && Boolean(oldToolTip))
               {
                  pos = name.indexOf(oldToolTip);
                  if(pos != -1)
                  {
                     name = name.substring(0,pos) + name.substring(pos + oldToolTip.length);
                  }
                  oldToolTip = null;
               }
               if(Boolean(master.toolTip) && master.toolTip.length != 0)
               {
                  if(!name)
                  {
                     name = "";
                  }
                  oldToolTip = " " + master.toolTip;
                  name += oldToolTip;
               }
               Accessibility.updateProperties();
         }
      }
   }
}

