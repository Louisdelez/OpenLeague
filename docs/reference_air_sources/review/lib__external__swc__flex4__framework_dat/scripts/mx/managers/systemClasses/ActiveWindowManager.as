package mx.managers.systemClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import mx.core.IChildList;
   import mx.core.IFlexModuleFactory;
   import mx.core.IRawChildrenContainer;
   import mx.core.IUIComponent;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.Request;
   import mx.managers.IActiveWindowManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   [Mixin]
   [ExcludeClass]
   public class ActiveWindowManager extends EventDispatcher implements IActiveWindowManager
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var systemManager:ISystemManager;
      
      mx_internal var forms:Array = [];
      
      mx_internal var form:Object;
      
      private var _numModalWindows:int = 0;
      
      public function ActiveWindowManager(systemManager:ISystemManager = null)
      {
         super();
         if(!systemManager)
         {
            return;
         }
         this.systemManager = systemManager;
         if(systemManager.isTopLevelRoot() || systemManager.getSandboxRoot() == systemManager)
         {
            systemManager.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,true);
         }
      }
      
      public static function init(fbs:IFlexModuleFactory) : void
      {
         Singleton.registerClass("mx.managers::IActiveWindowManager",ActiveWindowManager);
      }
      
      private static function areRemotePopUpsEqual(form1:Object, form2:Object) : Boolean
      {
         if(!(form1 is RemotePopUp))
         {
            return false;
         }
         if(!(form2 is RemotePopUp))
         {
            return false;
         }
         var remotePopUp1:RemotePopUp = RemotePopUp(form1);
         var remotePopUp2:RemotePopUp = RemotePopUp(form2);
         if(Boolean(remotePopUp1.window == remotePopUp2.window) && Boolean(remotePopUp1.bridge) && Boolean(remotePopUp2.bridge))
         {
            return true;
         }
         return false;
      }
      
      private static function getChildListIndex(childList:IChildList, f:Object) : int
      {
         var index:int = -1;
         try
         {
            index = childList.getChildIndex(DisplayObject(f));
         }
         catch(e:ArgumentError)
         {
         }
         return index;
      }
      
      public function get numModalWindows() : int
      {
         return this._numModalWindows;
      }
      
      public function set numModalWindows(value:int) : void
      {
         this._numModalWindows = value;
         this.systemManager.numModalWindows = value;
      }
      
      public function activate(f:Object) : void
      {
         this.activateForm(f);
      }
      
      private function activateForm(f:Object) : void
      {
         var e:DynamicEvent = null;
         var e2:DynamicEvent = null;
         var z:IFocusManagerContainer = null;
         if(Boolean(this.form))
         {
            if(this.form != f && this.forms.length > 1)
            {
               if(hasEventListener("activateForm"))
               {
                  e = new DynamicEvent("activateForm",false,true);
                  e.form = f;
               }
               if(!e || dispatchEvent(e))
               {
                  z = IFocusManagerContainer(this.form);
                  z.focusManager.deactivate();
               }
            }
         }
         this.form = f;
         if(hasEventListener("activatedForm"))
         {
            e2 = new DynamicEvent("activatedForm",false,true);
            e2.form = f;
         }
         if(!e2 || dispatchEvent(e2))
         {
            if(Boolean(f.focusManager))
            {
               f.focusManager.activate();
            }
         }
      }
      
      public function deactivate(f:Object) : void
      {
         this.deactivateForm(Object(f));
      }
      
      private function deactivateForm(f:Object) : void
      {
         var e:DynamicEvent = null;
         var e2:DynamicEvent = null;
         if(Boolean(this.form))
         {
            if(this.form == f && this.forms.length > 1)
            {
               if(hasEventListener("deactivateForm"))
               {
                  e = new DynamicEvent("deactivateForm",false,true);
                  e.form = this.form;
               }
               if(!e || dispatchEvent(e))
               {
                  this.form.focusManager.deactivate();
               }
               this.form = this.findLastActiveForm(f);
               if(Boolean(this.form))
               {
                  if(hasEventListener("deactivatedForm"))
                  {
                     e2 = new DynamicEvent("deactivatedForm",false,true);
                     e2.form = this.form;
                  }
                  if(!e2 || dispatchEvent(e2))
                  {
                     if(Boolean(this.form))
                     {
                        this.form.focusManager.activate();
                     }
                  }
               }
            }
         }
      }
      
      private function findLastActiveForm(f:Object) : Object
      {
         var n:int = int(this.forms.length);
         for(var i:int = this.forms.length - 1; i >= 0; i--)
         {
            if(!this.areFormsEqual(this.forms[i],f) && this.canActivatePopUp(this.forms[i]))
            {
               return this.forms[i];
            }
         }
         return null;
      }
      
      private function areFormsEqual(form1:Object, form2:Object) : Boolean
      {
         if(form1 == form2)
         {
            return true;
         }
         if(form1 is RemotePopUp && form2 is RemotePopUp)
         {
            return areRemotePopUpsEqual(form1,form2);
         }
         return false;
      }
      
      private function canActivatePopUp(f:Object) : Boolean
      {
         var e:Request = null;
         if(hasEventListener("canActivateForm"))
         {
            e = new Request("canActivateForm",false,true);
            e.value = f;
            if(!dispatchEvent(e))
            {
               return e.value;
            }
         }
         if(this.canActivateLocalComponent(f))
         {
            return true;
         }
         return false;
      }
      
      private function canActivateLocalComponent(o:Object) : Boolean
      {
         if(o is Sprite && o is IUIComponent && Sprite(o).visible && IUIComponent(o).enabled)
         {
            return true;
         }
         return false;
      }
      
      public function addFocusManager(f:IFocusManagerContainer) : void
      {
         this.forms.push(f);
      }
      
      public function removeFocusManager(f:IFocusManagerContainer) : void
      {
         var n:int = int(this.forms.length);
         for(var i:int = 0; i < n; i++)
         {
            if(this.forms[i] == f)
            {
               if(this.form == f)
               {
                  this.deactivate(f);
               }
               if(hasEventListener("removeFocusManager"))
               {
                  dispatchEvent(new FocusEvent("removeFocusManager",false,false,InteractiveObject(f)));
               }
               this.forms.splice(i,1);
               return;
            }
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         var n:int = 0;
         var p:DisplayObject = null;
         var isApplication:Boolean = false;
         var i:int = 0;
         var form_i:Object = null;
         var request:Request = null;
         var j:int = 0;
         var index:int = 0;
         var newIndex:int = 0;
         var childList:IChildList = null;
         var f:DisplayObject = null;
         var isRemotePopUp:Boolean = false;
         var fChildIndex:int = 0;
         if(hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            if(!dispatchEvent(new FocusEvent(MouseEvent.MOUSE_DOWN,false,true,InteractiveObject(event.target))))
            {
               return;
            }
         }
         if(this.numModalWindows == 0)
         {
            if(!this.systemManager.isTopLevelRoot() || this.forms.length > 1)
            {
               n = int(this.forms.length);
               p = DisplayObject(event.target);
               isApplication = this.systemManager.document is IRawChildrenContainer ? IRawChildrenContainer(this.systemManager.document).rawChildren.contains(p) : Boolean(this.systemManager.document.contains(p));
               loop0:
               while(Boolean(p))
               {
                  i = 0;
                  while(true)
                  {
                     if(i >= n)
                     {
                        p = p.parent;
                        continue loop0;
                     }
                     form_i = this.forms[i];
                     if(hasEventListener("actualForm"))
                     {
                        request = new Request("actualForm",false,true);
                        request.value = this.forms[i];
                        if(!dispatchEvent(request))
                        {
                           form_i = this.forms[i].window;
                        }
                     }
                     if(form_i == p)
                     {
                        break;
                     }
                     i++;
                  }
                  j = 0;
                  if(p != this.form && p is IFocusManagerContainer || !this.systemManager.isTopLevelRoot() && p == this.form)
                  {
                     if(this.systemManager.isTopLevelRoot())
                     {
                        this.activate(IFocusManagerContainer(p));
                     }
                     if(p == this.systemManager.document)
                     {
                        if(hasEventListener("activateApplication"))
                        {
                           dispatchEvent(new Event("activateApplication"));
                        }
                     }
                     else if(p is DisplayObject)
                     {
                        if(hasEventListener("activateWindow"))
                        {
                           dispatchEvent(new FocusEvent("activateWindow",false,false,InteractiveObject(p)));
                        }
                     }
                  }
                  if(this.systemManager.popUpChildren.contains(p))
                  {
                     childList = this.systemManager.popUpChildren;
                  }
                  else
                  {
                     childList = this.systemManager;
                  }
                  index = childList.getChildIndex(p);
                  newIndex = index;
                  n = int(this.forms.length);
                  for(j = 0; j < n; j++)
                  {
                     isRemotePopUp = false;
                     if(hasEventListener("isRemote"))
                     {
                        request = new Request("isRemote",false,true);
                        request.value = this.forms[j];
                        isRemotePopUp = false;
                        if(!dispatchEvent(request))
                        {
                           isRemotePopUp = request.value as Boolean;
                        }
                     }
                     if(isRemotePopUp)
                     {
                        if(this.forms[j].window is String)
                        {
                           continue;
                        }
                        f = this.forms[j].window;
                     }
                     else
                     {
                        f = this.forms[j];
                     }
                     if(isRemotePopUp)
                     {
                        fChildIndex = getChildListIndex(childList,f);
                        if(fChildIndex > index)
                        {
                           newIndex = Math.max(fChildIndex,newIndex);
                        }
                     }
                     else if(childList.contains(f))
                     {
                        if(childList.getChildIndex(f) > index)
                        {
                           newIndex = Math.max(childList.getChildIndex(f),newIndex);
                        }
                     }
                  }
                  if(newIndex > index && !isApplication)
                  {
                     childList.setChildIndex(p,newIndex);
                  }
                  return;
               }
            }
            else if(hasEventListener("activateApplication"))
            {
               dispatchEvent(new Event("activateApplication"));
            }
         }
      }
   }
}

