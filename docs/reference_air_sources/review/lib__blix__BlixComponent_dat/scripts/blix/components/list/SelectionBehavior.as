package blix.components.list
{
   import blix.IDestructible;
   import blix.components.renderer.ISelectableRenderer;
   import blix.ds.IListX;
   import blix.layout.LayoutEntry;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.math.clamp;
   import flash.utils.Dictionary;
   
   public class SelectionBehavior implements IDestructible
   {
      
      public var autoMultipleSelection:Boolean = false;
      
      public var allowMultipleSelection:Boolean = true;
      
      public var enabled:Boolean = true;
      
      protected var selectedDict:Dictionary = new Dictionary(true);
      
      protected var _selectedItemsChanged:Signal = new Signal();
      
      protected var _rendererFactory:IRendererFactory;
      
      protected var _dataProvider:IListX;
      
      protected var renderers:Dictionary = new Dictionary(true);
      
      protected var lastSelectedItem:Object;
      
      public function SelectionBehavior(param1:IRendererFactory = null, param2:IListX = null)
      {
         super();
         this.setRendererFactory(param1);
         this.setDataProvider(param2);
      }
      
      public function getSelectedItemsChanged() : ISignal
      {
         return this._selectedItemsChanged;
      }
      
      public function getDataProvider() : IListX
      {
         return this._dataProvider;
      }
      
      public function setDataProvider(param1:IListX) : void
      {
         this._dataProvider = param1;
      }
      
      public function setRendererFactory(param1:IRendererFactory) : void
      {
         if(this._rendererFactory != null)
         {
            this._rendererFactory.getEntryActivated().remove(this.entryActivatedHandler);
            this._rendererFactory.getEntryDeactivated().remove(this.entryDeactivatedHandler);
            this.removeAllRenderers();
         }
         this._rendererFactory = param1;
         if(this._rendererFactory != null)
         {
            this._rendererFactory.getEntryActivated().add(this.entryActivatedHandler);
            this._rendererFactory.getEntryDeactivated().add(this.entryDeactivatedHandler);
         }
      }
      
      protected function entryActivatedHandler(param1:LayoutEntry, param2:*) : void
      {
         var _loc3_:ISelectableRenderer = null;
         var _loc4_:Boolean = false;
         if(param1.element is ISelectableRenderer)
         {
            _loc3_ = param1.element as ISelectableRenderer;
            this.addRenderer(_loc3_);
            _loc4_ = param2 in this.selectedDict;
            if(_loc3_.getSelected() != _loc4_)
            {
               _loc3_.setSelected(_loc4_);
            }
         }
      }
      
      protected function entryDeactivatedHandler(param1:LayoutEntry) : void
      {
         if(param1.element is ISelectableRenderer)
         {
            this.removeRenderer(param1.element as ISelectableRenderer);
         }
      }
      
      public function addRenderer(param1:ISelectableRenderer) : void
      {
         if(param1 in this.renderers)
         {
            return;
         }
         this.renderers[param1] = true;
         param1.getSelectionRequested().add(this.itemSelectionRequestHandler);
         var _loc2_:Boolean = param1.getData() in this.selectedDict;
         if(param1.getSelected() != _loc2_)
         {
            param1.setSelected(_loc2_);
         }
      }
      
      public function removeRenderer(param1:ISelectableRenderer) : void
      {
         if(!(param1 in this.renderers))
         {
            return;
         }
         delete this.renderers[param1];
         param1.getSelectionRequested().remove(this.itemSelectionRequestHandler);
      }
      
      public function removeAllRenderers() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.renderers)
         {
            this.removeRenderer(_loc1_ as ISelectableRenderer);
         }
      }
      
      protected function itemSelectionRequestHandler(param1:ISelectableRenderer, param2:Boolean, param3:Boolean) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!this.enabled)
         {
            return;
         }
         var _loc4_:Boolean = param1.getSelected();
         var _loc5_:Object = param1.getData();
         var _loc6_:Boolean = param2 && !param3 || this.autoMultipleSelection && !param3;
         var _loc7_:Boolean = false;
         if(this.allowMultipleSelection && _loc6_)
         {
            this.lastSelectedItem = _loc4_ ? null : _loc5_;
            this.setItemIsSelected(_loc5_,!_loc4_,_loc7_);
         }
         else if(this.allowMultipleSelection && param3 && this.lastSelectedItem != null)
         {
            if(this._dataProvider == null)
            {
               return;
            }
            _loc8_ = int(this._dataProvider.getItemIndex(this.lastSelectedItem));
            _loc9_ = int(this._dataProvider.getItemIndex(_loc5_));
            if(!param2)
            {
               this.clearSelection(_loc7_);
            }
            this.setRangeSelected(_loc8_,_loc9_,true,_loc7_);
         }
         else
         {
            this.clearSelection(_loc7_);
            if(!_loc6_ || !_loc4_)
            {
               this.setItemIsSelected(_loc5_,true,_loc7_);
            }
            this.lastSelectedItem = _loc5_;
         }
         this.refreshRenderers();
         this._selectedItemsChanged.dispatch();
      }
      
      public function getSelectedItems() : Vector.<Object>
      {
         var _loc2_:Object = null;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         for each(_loc2_ in this._dataProvider)
         {
            if(_loc2_ in this.selectedDict)
            {
               _loc1_[_loc1_.length] = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function setSelectedItems(param1:Vector.<Object>, param2:Boolean = true) : void
      {
         this.selectedDict = new Dictionary(true);
         this.setItemsSelected(param1,true,false);
         if(param2)
         {
            this.refreshRenderers();
            this._selectedItemsChanged.dispatch();
         }
      }
      
      public function getSelectedItem() : Object
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._dataProvider)
         {
            if(_loc1_ in this.selectedDict)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function setSelectedItem(param1:Object, param2:Boolean = true) : void
      {
         this.selectedDict = new Dictionary(true);
         this.setItemIsSelected(param1,true,false);
         if(param2)
         {
            this.refreshRenderers();
            this._selectedItemsChanged.dispatch();
         }
      }
      
      public function getItemIsSelected(param1:Object) : Boolean
      {
         return param1 in this.selectedDict;
      }
      
      public function setItemIsSelected(param1:Object, param2:Boolean, param3:Boolean = true) : void
      {
         if(param1 in this.selectedDict == param2)
         {
            return;
         }
         if(param2)
         {
            this.selectedDict[param1] = true;
         }
         else
         {
            delete this.selectedDict[param1];
         }
         if(param3)
         {
            this.refreshRenderers();
            this._selectedItemsChanged.dispatch();
         }
      }
      
      public function setItemsSelected(param1:Vector.<Object>, param2:Boolean, param3:Boolean = true) : void
      {
         var _loc4_:Object = null;
         for each(_loc4_ in param1)
         {
            if(param2)
            {
               this.selectedDict[_loc4_] = true;
            }
            else
            {
               delete this.selectedDict[_loc4_];
            }
         }
         if(param3)
         {
            this.refreshRenderers();
            this._selectedItemsChanged.dispatch();
         }
      }
      
      public function setRangeSelected(param1:int, param2:int, param3:Boolean, param4:Boolean = true) : void
      {
         var _loc9_:Object = null;
         if(this._dataProvider == null)
         {
            throw new Error("data provider not set.");
         }
         var _loc5_:int = Math.min(param1,param2);
         var _loc6_:int = Math.max(param1,param2);
         var _loc7_:int = this._dataProvider.getLength() - 1;
         _loc5_ = int(clamp(_loc5_,0,_loc7_));
         _loc6_ = int(clamp(_loc6_,0,_loc7_));
         var _loc8_:int = _loc5_;
         while(_loc8_ <= _loc6_)
         {
            _loc9_ = this._dataProvider.getItemAt(_loc8_);
            if(param3)
            {
               this.selectedDict[_loc9_] = true;
            }
            else
            {
               delete this.selectedDict[_loc9_];
            }
            _loc8_++;
         }
         if(param4)
         {
            this.refreshRenderers();
            this._selectedItemsChanged.dispatch();
         }
      }
      
      protected function refreshRenderers() : void
      {
         var _loc1_:ISelectableRenderer = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         for(_loc3_ in this.renderers)
         {
            _loc1_ = _loc3_;
            _loc2_ = _loc1_.getData() in this.selectedDict;
            _loc1_.setSelected(_loc2_);
         }
      }
      
      public function selectAll(param1:Boolean = true) : void
      {
         this.setRangeSelected(0,int.MAX_VALUE,true,param1);
      }
      
      public function clearSelection(param1:Boolean = true) : void
      {
         this.selectedDict = new Dictionary(true);
         if(param1)
         {
            this.refreshRenderers();
            this._selectedItemsChanged.dispatch();
         }
      }
      
      public function destroy() : void
      {
         this._selectedItemsChanged.removeAll();
         this.removeAllRenderers();
         this.setRendererFactory(null);
         this.lastSelectedItem = null;
         this.selectedDict = null;
      }
   }
}

