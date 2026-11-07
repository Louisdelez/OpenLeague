package blix.layout
{
   import blix.context.IContext;
   import blix.layout.algorithms.ILayoutAlgorithm;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   import blix.view.View;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class LayoutContainer extends View implements ILayoutContainer
   {
      
      protected var _entries:Vector.<LayoutEntry> = new Vector.<LayoutEntry>();
      
      protected var elementEntryDict:Dictionary = new Dictionary(true);
      
      protected var _entryAdded:Signal = new Signal();
      
      protected var _entryRemoved:Signal = new Signal();
      
      protected var _layoutAlgorithm:ILayoutAlgorithm;
      
      protected var _filteredEntries:Vector.<LayoutEntry>;
      
      protected var _previousOffset:Point = new Point();
      
      public function LayoutContainer(param1:IContext = null)
      {
         super(param1);
      }
      
      public function getLayoutAlgorithm() : ILayoutAlgorithm
      {
         return this._layoutAlgorithm;
      }
      
      public function setLayoutAlgorithm(param1:ILayoutAlgorithm) : void
      {
         if(this._layoutAlgorithm == param1)
         {
            return;
         }
         if(this._layoutAlgorithm != null)
         {
            this._layoutAlgorithm.getLayoutInvalidated().remove(this.layoutInvalidatedHandler);
         }
         this._layoutAlgorithm = param1;
         if(this._layoutAlgorithm != null)
         {
            this._layoutAlgorithm.getLayoutInvalidated().add(this.layoutInvalidatedHandler);
         }
         invalidateLayout();
      }
      
      protected function layoutInvalidatedHandler(param1:ILayoutAlgorithm) : void
      {
         invalidateLayout();
      }
      
      public function getEntryAdded() : ISignal
      {
         return this._entryAdded;
      }
      
      public function getEntryRemoved() : ISignal
      {
         return this._entryRemoved;
      }
      
      protected function unconfigureEntry(param1:LayoutEntry) : void
      {
         delete this.elementEntryDict[param1.element];
         param1.element.getLayoutInvalidated().remove(invalidateLayout);
         if(param1.data != null)
         {
            param1.data.getLayoutDataChanged().remove(invalidateLayout);
         }
      }
      
      protected function configureEntry(param1:LayoutEntry) : void
      {
         this.elementEntryDict[param1.element] = param1;
         param1.element.getLayoutInvalidated().add(invalidateLayout);
         if(param1.data != null)
         {
            param1.data.getLayoutDataChanged().add(invalidateLayout);
         }
      }
      
      public function addElement(param1:ILayoutElement, param2:ILayoutData = null) : void
      {
         if(param1 == null)
         {
            throw new Error("Parameter element cannot be null.");
         }
         this.addElementAt(param1,this._entries.length,param2);
      }
      
      public function addElementAt(param1:ILayoutElement, param2:int, param3:ILayoutData = null) : void
      {
         var _loc4_:LayoutEntry = this.elementEntryDict[param1] as LayoutEntry;
         var _loc5_:LayoutEntry = _loc4_ || new LayoutEntry(param1,param3);
         this.addEntryAt(_loc5_,param2);
      }
      
      private function addEntryAt(param1:LayoutEntry, param2:uint) : void
      {
         var _loc3_:int = this._entries.indexOf(param1);
         if(_loc3_ != -1)
         {
            this._entries.splice(_loc3_,1);
            if(param2 < _loc3_)
            {
               param2--;
            }
         }
         else
         {
            this.configureEntry(param1);
         }
         this._entries.splice(param2,0,param1);
         invalidateLayout();
         this._entryAdded.dispatch(this,param1);
      }
      
      public function getElementAt(param1:int) : ILayoutElement
      {
         return this._entries[param1].element;
      }
      
      public function getElementIndex(param1:ILayoutElement) : int
      {
         var _loc2_:LayoutEntry = this.elementEntryDict[param1];
         return this._entries.indexOf(_loc2_);
      }
      
      public function removeElement(param1:ILayoutElement) : Boolean
      {
         var _loc2_:LayoutEntry = null;
         var _loc3_:int = 0;
         if(param1 in this.elementEntryDict)
         {
            _loc2_ = this.elementEntryDict[param1];
            _loc3_ = this._entries.indexOf(_loc2_);
            if(_loc3_ == -1)
            {
               return false;
            }
            this.removeElementAt(_loc3_);
            return true;
         }
         return false;
      }
      
      public function removeElementAt(param1:int) : Boolean
      {
         if(param1 >= this._entries.length)
         {
            return false;
         }
         var _loc2_:LayoutEntry = this._entries.splice(param1,1)[0];
         this.unconfigureEntry(_loc2_);
         invalidateLayout();
         this._entryRemoved.dispatch(this,_loc2_);
         return true;
      }
      
      public function removeAllElements() : void
      {
         var _loc1_:LayoutEntry = null;
         for each(_loc1_ in this._entries)
         {
            this.unconfigureEntry(_loc1_);
            this._entryRemoved.dispatch(this,_loc1_);
         }
         this._entries.length = 0;
         invalidateLayout();
      }
      
      protected function getEntriesFiltered() : Vector.<LayoutEntry>
      {
         if(this._filteredEntries == null)
         {
            this._filteredEntries = this._entries.filter(this.includedFilter);
         }
         return this._filteredEntries;
      }
      
      protected function includedFilter(param1:LayoutEntry, param2:int, param3:Vector.<LayoutEntry>) : Boolean
      {
         return param1.element.getIncludeInLayout();
      }
      
      override public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         if(this._layoutAlgorithm != null)
         {
            return this._layoutAlgorithm.getSizeConstraints(param1,param2,this.getEntriesFiltered());
         }
         return new SizeConstraints();
      }
      
      override public function invalidate() : void
      {
         this.clearCachedFilteredElements();
         super.invalidate();
      }
      
      protected function clearCachedFilteredElements() : void
      {
         this._filteredEntries = null;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = null;
         if(this._layoutAlgorithm != null)
         {
            _loc3_ = this._layoutAlgorithm.updateLayout(param1,param2,this.getEntriesFiltered());
         }
         else
         {
            _loc3_ = new Rectangle();
         }
         this._previousOffset.x = 0;
         this._previousOffset.y = 0;
         positionIsValidFlag = false;
         return _loc3_;
      }
      
      override protected function updatePosition(param1:Number, param2:Number) : Point
      {
         var _loc5_:LayoutEntry = null;
         var _loc6_:Point = null;
         if(isNaN(param1))
         {
            param1 = 0;
         }
         if(isNaN(param2))
         {
            param2 = 0;
         }
         var _loc3_:Number = param1 - this._previousOffset.x;
         var _loc4_:Number = param2 - this._previousOffset.y;
         if(_loc3_ != 0 || _loc4_ != 0)
         {
            this._previousOffset.x = param1;
            this._previousOffset.y = param2;
            for each(_loc5_ in this.getEntriesFiltered())
            {
               _loc6_ = _loc5_.element.getExplicitPosition();
               _loc5_.element.setExplicitPosition(_loc6_.x + _loc3_,_loc6_.y + _loc4_);
            }
         }
         return new Point(param1,param2);
      }
      
      override public function destroy() : void
      {
         var _loc1_:LayoutEntry = null;
         super.destroy();
         for each(_loc1_ in this._entries)
         {
            this.unconfigureEntry(_loc1_);
         }
         this._entries.length = 0;
         this.clearCachedFilteredElements();
      }
   }
}

