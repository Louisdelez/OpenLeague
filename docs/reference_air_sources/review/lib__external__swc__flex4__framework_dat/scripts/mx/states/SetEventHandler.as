package mx.states
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.core.ComponentDescriptor;
   import mx.core.IStateClient2;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Event(name="handler",type="Object")]
   public class SetEventHandler extends OverrideBase
   {
      
      private static var installedHandlers:Dictionary;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var oldHandlerFunction:Function;
      
      [Inspectable(category="General")]
      public var name:String;
      
      public var handlerFunction:Function;
      
      public var originalHandlerFunction:Function;
      
      [Inspectable(category="General")]
      public var target:Object;
      
      private var appliedTarget:Object;
      
      public function SetEventHandler(target:EventDispatcher = null, name:String = null)
      {
         super();
         this.target = target;
         this.name = name;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(type == "handler")
         {
            this.handlerFunction = listener;
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function apply(parent:UIComponent) : void
      {
         var uiObj:UIComponent = null;
         var descriptor:ComponentDescriptor = null;
         parentContext = parent;
         var obj:* = getOverrideContext(this.target,parent);
         if(obj != null)
         {
            this.appliedTarget = obj;
            uiObj = obj as UIComponent;
            if(!installedHandlers)
            {
               installedHandlers = new Dictionary(true);
            }
            if(Boolean(installedHandlers[obj]) && Boolean(installedHandlers[obj][this.name]))
            {
               this.oldHandlerFunction = installedHandlers[obj][this.name];
               obj.removeEventListener(this.name,this.oldHandlerFunction);
            }
            else if(this.originalHandlerFunction != null)
            {
               this.oldHandlerFunction = this.originalHandlerFunction;
               obj.removeEventListener(this.name,this.oldHandlerFunction);
            }
            else if(Boolean(uiObj) && Boolean(uiObj.descriptor))
            {
               descriptor = uiObj.descriptor;
               if(Boolean(descriptor.events) && Boolean(descriptor.events[this.name]))
               {
                  this.oldHandlerFunction = uiObj.document[descriptor.events[this.name]];
                  obj.removeEventListener(this.name,this.oldHandlerFunction);
               }
            }
            if(this.handlerFunction != null)
            {
               obj.addEventListener(this.name,this.handlerFunction,false,0,true);
               if(!(parent.document is IStateClient2))
               {
                  if(installedHandlers[obj] == undefined)
                  {
                     installedHandlers[obj] = {};
                  }
                  installedHandlers[obj][this.name] = this.handlerFunction;
               }
               enableBindings(obj,parent,this.name,false);
            }
         }
         else if(!applied)
         {
            addContextListener(this.target);
         }
         applied = true;
      }
      
      override public function remove(parent:UIComponent) : void
      {
         var deleteObj:Boolean = false;
         var i:String = null;
         var obj:* = getOverrideContext(this.appliedTarget,parent);
         if(obj != null && Boolean(this.appliedTarget))
         {
            if(this.handlerFunction != null)
            {
               obj.removeEventListener(this.name,this.handlerFunction);
            }
            if(this.oldHandlerFunction != null)
            {
               obj.addEventListener(this.name,this.oldHandlerFunction,false,0,true);
            }
            if(Boolean(installedHandlers[obj]))
            {
               deleteObj = true;
               delete installedHandlers[obj][this.name];
               var _loc5_:int = 0;
               var _loc6_:* = installedHandlers[obj];
               for(i in _loc6_)
               {
                  deleteObj = false;
               }
               if(deleteObj)
               {
                  delete installedHandlers[obj];
               }
            }
            enableBindings(obj,parent,this.name);
         }
         else
         {
            removeContextListener();
         }
         applied = false;
         parentContext = null;
         this.appliedTarget = null;
      }
   }
}

