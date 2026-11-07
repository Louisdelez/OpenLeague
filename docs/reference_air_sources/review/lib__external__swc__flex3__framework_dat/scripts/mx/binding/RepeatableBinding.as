package mx.binding
{
   import flash.events.Event;
   import mx.core.IRepeaterClient;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class RepeatableBinding extends Binding
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function RepeatableBinding(document:Object, srcFunc:Function, destFunc:Function, destString:String)
      {
         super(document,srcFunc,destFunc,destString);
      }
      
      public function eventHandler(event:Event) : void
      {
         if(isHandlingEvent)
         {
            return;
         }
         isHandlingEvent = true;
         execute();
         isHandlingEvent = false;
      }
      
      override public function execute(o:Object = null) : void
      {
         var id:String = null;
         var components:Array = null;
         if(isExecuting)
         {
            return;
         }
         isExecuting = true;
         if(!o)
         {
            id = destString.substring(0,destString.indexOf("."));
            o = document[id];
         }
         else if(typeof o == "number")
         {
            id = destString.substring(0,destString.indexOf("."));
            components = document[id] as Array;
            if(Boolean(components))
            {
               o = components[o];
            }
            else
            {
               o = null;
            }
         }
         if(Boolean(o))
         {
            recursivelyProcessIDArray(o);
         }
         isExecuting = false;
      }
      
      private function recursivelyProcessIDArray(o:Object) : void
      {
         var array:Array = null;
         var n:int = 0;
         var i:int = 0;
         var client:IRepeaterClient = null;
         if(o is Array)
         {
            array = o as Array;
            n = int(array.length);
            for(i = 0; i < n; i++)
            {
               recursivelyProcessIDArray(array[i]);
            }
         }
         else if(o is IRepeaterClient)
         {
            client = IRepeaterClient(o);
            wrapFunctionCall(this,function():void
            {
               var value:Object = wrapFunctionCall(this,srcFunc,null,client.instanceIndices,client.repeaterIndices);
               if(Boolean(BindingManager.debugDestinationStrings[destString]))
               {
                  trace("RepeatableBinding: destString = " + destString + ", srcFunc result = " + value);
               }
               destFunc(value,client.instanceIndices);
            },o);
         }
      }
   }
}

