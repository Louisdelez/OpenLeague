package mx.states
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.core.ComponentDescriptor;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Event(name="handler",type="Object")]
   public class SetEventHandler extends EventDispatcher implements IOverride
   {
      
      private static var installedHandlers:Dictionary;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var handlerFunction:Function;
      
      [Inspectable(category="General")]
      public var name:String;
      
      [Inspectable(category="General")]
      public var target:EventDispatcher;
      
      private var oldHandlerFunction:Function;
      
      public function SetEventHandler(target:EventDispatcher = null, name:String = null)
      {
         super();
         this.target = target;
         this.name = name;
      }
      
      public function apply(parent:UIComponent) : void
      {
         var descriptor:ComponentDescriptor = null;
         var obj:EventDispatcher = Boolean(target) ? target : parent;
         var uiObj:UIComponent = obj as UIComponent;
         if(!installedHandlers)
         {
            installedHandlers = new Dictionary(true);
         }
         if(Boolean(installedHandlers[obj]) && Boolean(installedHandlers[obj][name]))
         {
            oldHandlerFunction = installedHandlers[obj][name];
            obj.removeEventListener(name,oldHandlerFunction);
         }
         else if(Boolean(uiObj) && Boolean(uiObj.descriptor))
         {
            descriptor = uiObj.descriptor;
            if(Boolean(descriptor.events) && Boolean(descriptor.events[name]))
            {
               oldHandlerFunction = uiObj.document[descriptor.events[name]];
               obj.removeEventListener(name,oldHandlerFunction);
            }
         }
         if(handlerFunction != null)
         {
            obj.addEventListener(name,handlerFunction,false,0,true);
            if(installedHandlers[obj] == undefined)
            {
               installedHandlers[obj] = {};
            }
            installedHandlers[obj][name] = handlerFunction;
         }
      }
      
      public function initialize() : void
      {
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(type == "handler")
         {
            handlerFunction = listener;
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function remove(parent:UIComponent) : void
      {
         var deleteObj:Boolean = false;
         var i:String = null;
         var obj:EventDispatcher = Boolean(target) ? target : parent;
         if(handlerFunction != null)
         {
            obj.removeEventListener(name,handlerFunction);
         }
         if(oldHandlerFunction != null)
         {
            obj.addEventListener(name,oldHandlerFunction,false,0,true);
         }
         if(Boolean(installedHandlers[obj]))
         {
            deleteObj = true;
            delete installedHandlers[obj][name];
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
      }
   }
}

