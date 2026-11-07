package mx.binding
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class FunctionReturnWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var functionName:String;
      
      private var document:Object;
      
      private var parameterFunction:Function;
      
      private var events:Object;
      
      private var parentObj:Object;
      
      public var parentWatcher:Watcher;
      
      private var functionGetter:Function;
      
      private var isStyle:Boolean;
      
      public function FunctionReturnWatcher(functionName:String, document:Object, parameterFunction:Function, events:Object, listeners:Array, functionGetter:Function = null, isStyle:Boolean = false)
      {
         super(listeners);
         this.functionName = functionName;
         this.document = document;
         this.parameterFunction = parameterFunction;
         this.events = events;
         this.functionGetter = functionGetter;
         this.isStyle = isStyle;
      }
      
      override public function updateParent(parent:Object) : void
      {
         if(!(parent is Watcher))
         {
            this.setupParentObj(parent);
         }
         else if(parent == this.parentWatcher)
         {
            this.setupParentObj(this.parentWatcher.value);
         }
         this.updateFunctionReturn();
      }
      
      override protected function shallowClone() : Watcher
      {
         return new FunctionReturnWatcher(this.functionName,this.document,this.parameterFunction,this.events,listeners,this.functionGetter);
      }
      
      public function updateFunctionReturn() : void
      {
         wrapUpdate(function():void
         {
            if(functionGetter != null)
            {
               value = functionGetter(functionName).apply(parentObj,parameterFunction.apply(document));
            }
            else
            {
               value = parentObj[functionName].apply(parentObj,parameterFunction.apply(document));
            }
            updateChildren();
         });
      }
      
      private function setupParentObj(newParent:Object) : void
      {
         var eventDispatcher:IEventDispatcher = null;
         var eventName:String = null;
         if(this.parentObj != null && this.parentObj is IEventDispatcher)
         {
            eventDispatcher = this.parentObj as IEventDispatcher;
            if(this.events != null)
            {
               for(eventName in this.events)
               {
                  if(eventName != "__NoChangeEvent__")
                  {
                     eventDispatcher.removeEventListener(eventName,this.eventHandler);
                  }
               }
            }
            if(this.isStyle)
            {
               eventName = this.parameterFunction.apply(this.document) + "Changed";
               eventDispatcher.removeEventListener(eventName,this.eventHandler);
               eventDispatcher.removeEventListener("allStylesChanged",this.eventHandler);
            }
         }
         this.parentObj = newParent;
         if(this.parentObj != null && this.parentObj is IEventDispatcher)
         {
            eventDispatcher = this.parentObj as IEventDispatcher;
            if(this.events != null)
            {
               for(eventName in this.events)
               {
                  if(eventName != "__NoChangeEvent__")
                  {
                     eventDispatcher.addEventListener(eventName,this.eventHandler,false,EventPriority.BINDING,true);
                  }
               }
            }
            if(this.isStyle)
            {
               eventName = this.parameterFunction.apply(this.document) + "Changed";
               eventDispatcher.addEventListener(eventName,this.eventHandler,false,EventPriority.BINDING,true);
               eventDispatcher.addEventListener("allStylesChanged",this.eventHandler,false,EventPriority.BINDING,true);
            }
         }
      }
      
      public function eventHandler(event:Event) : void
      {
         this.updateFunctionReturn();
         if(this.events != null)
         {
            notifyListeners(this.events[event.type]);
         }
         if(this.isStyle)
         {
            notifyListeners(true);
         }
      }
   }
}

