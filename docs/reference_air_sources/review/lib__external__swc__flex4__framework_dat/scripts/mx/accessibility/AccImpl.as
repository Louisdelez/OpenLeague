package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityImplementation;
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.managers.ISystemManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   public class AccImpl extends AccessibilityImplementation
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var typeMap:Object = {
         "Container":["spark.components.SkinnableContainer","mx.core.Container"],
         "Form":["spark.components.Form","mx.containers.Form"],
         "FormHeading":["spark.components.FormHeading","mx.containers.FormHeading"],
         "FormItem":["spark.components.FormItem","mx.containers.FormItem"],
         "FormItemLabel":["mx.controls.FormItemLabel"],
         "ScrollBar":["mx.controls.scrollClasses.ScrollBar","spark.components.supportClasses.ScrollBarBase"]
      };
      
      protected var master:UIComponent;
      
      protected var role:uint;
      
      public function AccImpl(master:UIComponent)
      {
         var n:int = 0;
         var i:int = 0;
         super();
         this.master = master;
         stub = false;
         if(!master.accessibilityProperties)
         {
            master.accessibilityProperties = new AccessibilityProperties();
         }
         var events:Array = this.eventsToHandle;
         if(Boolean(events))
         {
            n = int(events.length);
            for(i = 0; i < n; i++)
            {
               master.addEventListener(events[i],this.eventHandler);
            }
         }
      }
      
      mx_internal static function getDefinition(name:String, moduleFactory:IFlexModuleFactory) : Object
      {
         var currentDomain:ApplicationDomain = null;
         if(Boolean(moduleFactory))
         {
            currentDomain = moduleFactory.info()["currentDomain"];
         }
         else
         {
            currentDomain = ApplicationDomain.currentDomain;
         }
         if(currentDomain.hasDefinition(name))
         {
            return currentDomain.getDefinition(name);
         }
         return null;
      }
      
      mx_internal static function getDefinitions(typeName:String, moduleFactory:IFlexModuleFactory) : Array
      {
         var thisClass:Class = null;
         var className:String = null;
         var defs:Array = [];
         for each(className in typeMap[typeName])
         {
            thisClass = Class(getDefinition(className,moduleFactory));
            if(Boolean(thisClass))
            {
               defs.push(thisClass);
            }
         }
         return defs;
      }
      
      mx_internal static function getMatchingDefinition(obj:Object, classes:Array) : Class
      {
         var thisClass:Class = null;
         if(!obj)
         {
            return null;
         }
         for each(thisClass in classes)
         {
            if(obj is thisClass)
            {
               return thisClass;
            }
         }
         return null;
      }
      
      mx_internal static function findMatchingAncestor(component:Object, f:Function) : UIComponent
      {
         while(Boolean(component && component is UIComponent) && Boolean(!(component is ISystemManager)) && component != UIComponent(component).root)
         {
            if(Boolean(f(component)))
            {
               return UIComponent(component);
            }
            component = UIComponent(component).parent;
         }
         return null;
      }
      
      public static function isAncestorDisabled(component:UIComponent) : Boolean
      {
         return findMatchingAncestor(component.parent,isComponentDisabled) != null;
      }
      
      mx_internal static function isComponentDisabled(component:UIComponent) : Boolean
      {
         return !component.enabled;
      }
      
      mx_internal static function isForm(component:UIComponent) : Boolean
      {
         var formClasses:Array = getDefinitions("Form",component.moduleFactory);
         return getMatchingDefinition(component,formClasses) != null;
      }
      
      mx_internal static function isFormHeading(component:UIComponent) : Boolean
      {
         var formHeadingClasses:Array = getDefinitions("FormHeading",component.moduleFactory);
         return getMatchingDefinition(component,formHeadingClasses) != null;
      }
      
      mx_internal static function isFormItem(component:UIComponent) : Boolean
      {
         var formItemClasses:Array = getDefinitions("FormItem",component.moduleFactory);
         return getMatchingDefinition(component,formItemClasses) != null;
      }
      
      public static function getFormName(component:UIComponent) : String
      {
         if(Boolean(getMatchingDefinition(component,getDefinitions("Container",component.moduleFactory))))
         {
            return "";
         }
         var formItem:UIComponent = findMatchingAncestor(component.parent,isFormItem);
         if(!formItem)
         {
            return "";
         }
         return determineFormItemString(formItem);
      }
      
      private static function joinWithSpace(s1:String, s2:String) : String
      {
         if(s1 == " ")
         {
            s1 = "";
         }
         if(s2 == " ")
         {
            s2 = "";
         }
         if(Boolean(s1) && Boolean(s2))
         {
            s1 += " " + s2;
         }
         else if(Boolean(s2))
         {
            s1 = s2;
         }
         return s1;
      }
      
      private static function determineFormItemString(formItem:Object) : String
      {
         var formHeadingClasses:Array = null;
         var formItemIndex:int = 0;
         var i:int = 0;
         var child:UIComponent = null;
         var formHeadingClass:Class = null;
         var formName:String = "";
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var formItemParent:UIComponent = UIComponent(formItem.parent);
         if(Boolean(findMatchingAncestor(formItemParent,isForm)))
         {
            formHeadingClasses = getDefinitions("FormHeading",formItem.moduleFactory);
            formItemIndex = formItemParent.getChildIndex(DisplayObject(formItem));
            for(i = formItemIndex; i >= 0; i--)
            {
               child = UIComponent(formItemParent.getChildAt(i));
               formHeadingClass = getMatchingDefinition(child,formHeadingClasses);
               if(Boolean(formHeadingClass))
               {
                  if(Boolean(formHeadingClass(child).accessibilityProperties))
                  {
                     formName = formHeadingClass(child).accessibilityProperties.name;
                  }
                  if(formName == "")
                  {
                     formName = formHeadingClass(child).label;
                  }
                  break;
               }
            }
         }
         if(Boolean(formItem.required))
         {
            formName = joinWithSpace(formName,resourceManager.getString("controls","requiredField"));
         }
         var f:String = "";
         if(Boolean(formItem.accessibilityProperties))
         {
            f = formItem.accessibilityProperties.name;
         }
         if(f == "")
         {
            f = formItem.label;
         }
         formName = joinWithSpace(formName,f);
         try
         {
            if(Boolean(formItem.labelDisplay) && Boolean(formItem.labelDisplay.accessibilityEnabled))
            {
               formItem.labelDisplay.accessibilityEnabled = false;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(Boolean(formItem.sequenceLabelDisplay) && Boolean(formItem.sequenceLabelDisplay.accessibilityEnabled))
            {
               formItem.sequenceLabelDisplay.accessibilityEnabled = false;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(Boolean(formItem.helpContentGroup) && Boolean(formItem.helpContentGroup.accessibilityEnabled))
            {
               formItem.helpContentGroup.accessibilityEnabled = false;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(Boolean(formItem.errorTextDisplay) && Boolean(formItem.errorTextDisplay.accessibilityEnabled))
            {
               formItem.errorTextDisplay.accessibilityEnabled = false;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(Boolean(formItem.itemLabel) && Boolean(formItem.itemLabel.accessibilityEnabled))
            {
               formItem.itemLabel.accessibilityEnabled = false;
            }
         }
         catch(e:Error)
         {
         }
         return formName;
      }
      
      private static function componentNeedsSkinnableTextBaseException(component:UIComponent) : Boolean
      {
         var richEditableTextClass:Class;
         var skinnableTextBaseClass:Class;
         var sharesMyAccessibilityProperties:Function;
         var matchingAncestor:UIComponent;
         var myAccessibilityProperties:Object = null;
         myAccessibilityProperties = component.accessibilityProperties;
         if(!myAccessibilityProperties)
         {
            return false;
         }
         richEditableTextClass = Class(getDefinition("spark.components.RichEditableText",component.moduleFactory));
         if(!richEditableTextClass || !(component is richEditableTextClass))
         {
            return false;
         }
         skinnableTextBaseClass = Class(getDefinition("spark.components.supportClasses.SkinnableTextBase",component.moduleFactory));
         if(!skinnableTextBaseClass)
         {
            return false;
         }
         sharesMyAccessibilityProperties = function(c:UIComponent):Boolean
         {
            return c.accessibilityProperties === myAccessibilityProperties;
         };
         matchingAncestor = findMatchingAncestor(component.parent,sharesMyAccessibilityProperties);
         if(!matchingAncestor)
         {
            return false;
         }
         return matchingAncestor is skinnableTextBaseClass;
      }
      
      protected function get eventsToHandle() : Array
      {
         return ["errorStringChanged","toolTipChanged","show","hide"];
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return this.role;
      }
      
      override public function get_accName(childID:uint) : String
      {
         var accName:String = null;
         if(Boolean(childID))
         {
            accName = this.getName(childID);
            return accName != null && accName != "" ? accName : null;
         }
         accName = getFormName(this.master);
         if(Boolean(this.master.accessibilityProperties && this.master.accessibilityProperties.name != null) && Boolean(this.master.accessibilityProperties.name != "") && !componentNeedsSkinnableTextBaseException(this.master))
         {
            accName = joinWithSpace(accName,this.master.accessibilityProperties.name);
         }
         else
         {
            accName = joinWithSpace(accName,this.getName(0) || this.master.toolTip);
         }
         accName = joinWithSpace(accName,this.getStatusName());
         return accName != null && accName != "" ? accName : null;
      }
      
      override public function getChildIDArray() : Array
      {
         return [];
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
      }
      
      protected function getName(childID:uint) : String
      {
         return null;
      }
      
      protected function getState(childID:uint) : uint
      {
         var accState:uint = AccConst.STATE_SYSTEM_NORMAL;
         if(!UIComponent(this.master).enabled || isAncestorDisabled(this.master))
         {
            accState &= ~AccConst.STATE_SYSTEM_FOCUSABLE;
            accState |= AccConst.STATE_SYSTEM_UNAVAILABLE;
         }
         else
         {
            accState |= AccConst.STATE_SYSTEM_FOCUSABLE;
            if(UIComponent(this.master) == UIComponent(this.master).getFocus() && childID == 0)
            {
               accState |= AccConst.STATE_SYSTEM_FOCUSED;
            }
         }
         return accState;
      }
      
      private function getStatusName() : String
      {
         var statusName:String = "";
         if(this.master is UIComponent && Boolean(UIComponent(this.master).errorString))
         {
            statusName = UIComponent(this.master).errorString;
         }
         return statusName;
      }
      
      protected function createChildIDArray(n:int) : Array
      {
         var a:Array = new Array(n);
         for(var i:int = 0; i < n; i++)
         {
            a[i] = i + 1;
         }
         return a;
      }
      
      protected function eventHandler(event:Event) : void
      {
         this.$eventHandler(event);
      }
      
      final protected function $eventHandler(event:Event) : void
      {
         switch(event.type)
         {
            case "errorStringChanged":
            case "toolTipChanged":
               Accessibility.sendEvent(this.master,0,AccConst.EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
               break;
            case "show":
               Accessibility.sendEvent(this.master,0,AccConst.EVENT_OBJECT_SHOW);
               Accessibility.updateProperties();
               break;
            case "hide":
               Accessibility.sendEvent(this.master,0,AccConst.EVENT_OBJECT_HIDE);
               Accessibility.updateProperties();
         }
      }
   }
}

