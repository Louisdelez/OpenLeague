package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityImplementation;
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import mx.containers.Form;
   import mx.containers.FormHeading;
   import mx.containers.FormItem;
   import mx.controls.Label;
   import mx.core.Container;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.managers.SystemManager;
   
   use namespace mx_internal;
   
   public class AccImpl extends AccessibilityImplementation
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const STATE_SYSTEM_NORMAL:uint = 0;
      
      private static const STATE_SYSTEM_FOCUSABLE:uint = 1048576;
      
      private static const STATE_SYSTEM_FOCUSED:uint = 4;
      
      private static const STATE_SYSTEM_UNAVAILABLE:uint = 1;
      
      private static const EVENT_OBJECT_NAMECHANGE:uint = 32780;
      
      protected var master:UIComponent;
      
      protected var role:uint;
      
      public function AccImpl(master:UIComponent)
      {
         var n:int = 0;
         var i:int = 0;
         super();
         this.master = master;
         stub = false;
         master.accessibilityProperties = new AccessibilityProperties();
         var events:Array = eventsToHandle;
         if(Boolean(events))
         {
            n = int(events.length);
            for(i = 0; i < n; i++)
            {
               master.addEventListener(events[i],eventHandler);
            }
         }
      }
      
      public static function getFormName(component:UIComponent) : String
      {
         var formName:String = "";
         if(component is Container)
         {
            return formName;
         }
         var par:DisplayObjectContainer = component.parent;
         while(Boolean(par && !(par is FormItem)) && Boolean(!(par is SystemManager)) && par != component.root)
         {
            par = par.parent;
         }
         if(Boolean(par) && par is FormItem)
         {
            formName = updateFormItemString(FormItem(par));
         }
         return formName;
      }
      
      private static function updateFormItemString(formItem:FormItem) : String
      {
         var itemLabel:Label = null;
         var accProp:AccessibilityProperties = null;
         var formItemIndex:int = 0;
         var i:int = 0;
         var child:UIComponent = null;
         var formName:String = "";
         itemLabel = formItem.itemLabel;
         accProp = Boolean(itemLabel) ? itemLabel.accessibilityProperties : null;
         if(Boolean(accProp) && accProp.silent)
         {
            return accProp.name;
         }
         var form:UIComponent = UIComponent(formItem.parent);
         if(form is Form)
         {
            formItemIndex = form.getChildIndex(formItem);
            for(i = formItemIndex; i >= 0; i--)
            {
               child = UIComponent(form.getChildAt(i));
               if(child is FormHeading)
               {
                  formName = FormHeading(child).label + " ";
                  break;
               }
            }
         }
         if(formItem.required)
         {
            formName += "Required Field ";
         }
         if(formItem.label != "")
         {
            formName += formItem.label + " ";
         }
         if(Boolean(accProp) && !accProp.silent)
         {
            accProp.silent = true;
            accProp.name = formName;
         }
         return formName;
      }
      
      protected function getName(childID:uint) : String
      {
         return null;
      }
      
      override public function get_accName(childID:uint) : String
      {
         var accName:String = getFormName(master);
         if(Boolean(childID == 0 && master.accessibilityProperties) && Boolean(master.accessibilityProperties.name != null) && master.accessibilityProperties.name != "")
         {
            accName += master.accessibilityProperties.name + " ";
         }
         accName += getName(childID) + getStatusName();
         return accName != null && accName != "" ? accName : null;
      }
      
      override public function get_accRole(childID:uint) : uint
      {
         return role;
      }
      
      protected function eventHandler(event:Event) : void
      {
         $eventHandler(event);
      }
      
      final protected function $eventHandler(event:Event) : void
      {
         switch(event.type)
         {
            case "errorStringChanged":
            case "toolTipChanged":
               Accessibility.sendEvent(master,0,EVENT_OBJECT_NAMECHANGE);
               Accessibility.updateProperties();
         }
      }
      
      override public function getChildIDArray() : Array
      {
         return [];
      }
      
      private function getStatusName() : String
      {
         var statusName:String = "";
         if(Boolean(master.toolTip))
         {
            statusName += " " + master.toolTip;
         }
         if(master is UIComponent && Boolean(UIComponent(master).errorString))
         {
            statusName += " " + UIComponent(master).errorString;
         }
         return statusName;
      }
      
      protected function getState(childID:uint) : uint
      {
         var accState:uint = STATE_SYSTEM_NORMAL;
         if(!UIComponent(master).enabled)
         {
            accState |= STATE_SYSTEM_UNAVAILABLE;
         }
         else
         {
            accState |= STATE_SYSTEM_FOCUSABLE;
            if(UIComponent(master) == UIComponent(master).getFocus())
            {
               accState |= STATE_SYSTEM_FOCUSED;
            }
         }
         return accState;
      }
      
      protected function get eventsToHandle() : Array
      {
         return ["errorStringChanged","toolTipChanged"];
      }
      
      override public function accSelect(selFlag:uint, childID:uint) : void
      {
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
   }
}

