package mx.binding
{
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class RepeaterItemWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var original:Boolean = true;
      
      private var clones:Array;
      
      private var dataProviderWatcher:PropertyWatcher;
      
      public function RepeaterItemWatcher(dataProviderWatcher:PropertyWatcher)
      {
         super();
         this.dataProviderWatcher = dataProviderWatcher;
      }
      
      override protected function shallowClone() : Watcher
      {
         return new RepeaterItemWatcher(dataProviderWatcher);
      }
      
      override public function updateParent(parent:Object) : void
      {
         var dataProvider:ICollectionView = null;
         if(Boolean(dataProviderWatcher))
         {
            dataProvider = ICollectionView(dataProviderWatcher.value);
            if(dataProvider != null)
            {
               dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,changedHandler,false);
            }
         }
         dataProviderWatcher = PropertyWatcher(parent);
         dataProvider = ICollectionView(dataProviderWatcher.value);
         if(Boolean(dataProvider))
         {
            if(original)
            {
               dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,changedHandler,false,0,true);
               updateClones(dataProvider);
            }
            else
            {
               wrapUpdate(function():void
               {
                  var iterator:IViewCursor = dataProvider.createCursor();
                  iterator.seek(CursorBookmark.FIRST,cloneIndex);
                  value = iterator.current;
                  updateChildren();
               });
            }
         }
      }
      
      private function changedHandler(collectionEvent:CollectionEvent) : void
      {
         var dataProvider:ICollectionView = ICollectionView(dataProviderWatcher.value);
         if(Boolean(dataProvider))
         {
            updateClones(dataProvider);
         }
      }
      
      private function updateClones(dataProvider:ICollectionView) : void
      {
         var clone:RepeaterItemWatcher = null;
         if(Boolean(clones))
         {
            clones = clones.splice(0,dataProvider.length);
         }
         else
         {
            clones = [];
         }
         for(var i:int = 0; i < dataProvider.length; i++)
         {
            clone = RepeaterItemWatcher(clones[i]);
            if(!clone)
            {
               clone = RepeaterItemWatcher(deepClone(i));
               clone.original = false;
               clones[i] = clone;
            }
            clone.updateParent(dataProviderWatcher);
         }
      }
   }
}

