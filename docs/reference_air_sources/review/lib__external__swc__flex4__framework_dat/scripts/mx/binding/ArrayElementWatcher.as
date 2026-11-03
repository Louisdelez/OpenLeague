package mx.binding
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class ArrayElementWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var document:Object;
      
      private var accessorFunc:Function;
      
      public var arrayWatcher:Watcher;
      
      public function ArrayElementWatcher(document:Object, accessorFunc:Function, listeners:Array)
      {
         super(listeners);
         this.document = document;
         this.accessorFunc = accessorFunc;
      }
      
      override public function updateParent(parent:Object) : void
      {
         if(this.arrayWatcher.value != null)
         {
            wrapUpdate(function():void
            {
               value = arrayWatcher.value[accessorFunc.apply(document)];
               updateChildren();
            });
         }
      }
      
      override protected function shallowClone() : Watcher
      {
         return new ArrayElementWatcher(this.document,this.accessorFunc,listeners);
      }
   }
}

