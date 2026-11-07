package com.riotgames.rust.components.list
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.Context;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.rust.components.DumbScroller;
   import com.riotgames.rust.components.list.renderer.ILabelFieldContext;
   import flash.events.MouseEvent;
   
   public class List extends SpriteProxy implements ILabelFieldContext
   {
      
      protected var _listView:ListViewBehavior;
      
      protected var layout:IListLayout;
      
      protected var _allowVariableSpan:Boolean = false;
      
      protected var scrollbar:DumbScroller;
      
      private var _labelField:String = "label";
      
      public function List(param1:Context)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         this._listView = new ListViewBehavior(this);
         this._listView.layoutHelper = new VListLayoutHelper();
         this._listView.viewReady.add(this.onViewReset);
         this.allowVariableSpan = false;
         this.scrollbar = this.wire("scrollbar",DumbScroller);
         this.scrollbar.setScrollModel(this._listView.scrollModel);
         this.scrollbar.stepUpSignal.add(this.doStepUp);
         this.scrollbar.stepDownSignal.add(this.doStepDown);
         this.scrollbar.pageUpSignal.add(this.doPageUp);
         this.scrollbar.pageDownSignal.add(this.doPageDown);
         this.scrollbar.snapSignal.add(this.doSnap);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         super.createChildren();
      }
      
      public function set labelField(param1:String) : void
      {
         this._labelField = param1;
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      protected function doStepUp() : void
      {
         this.layout.step(1);
      }
      
      protected function doStepDown() : void
      {
         this.layout.step(-1);
      }
      
      protected function doPageUp() : void
      {
         this.layout.page(1);
      }
      
      protected function doPageDown() : void
      {
         this.layout.page(-1);
      }
      
      protected function doSnap() : void
      {
         this.layout.snap();
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta < 0)
         {
            this.layout.step(1);
         }
         if(param1.delta > 0)
         {
            this.layout.step(-1);
         }
      }
      
      public function set data(param1:Array) : void
      {
         this.layout.data = param1;
      }
      
      public function get data() : Array
      {
         return this.layout.data;
      }
      
      public function get listView() : ListViewBehavior
      {
         return this._listView;
      }
      
      public function get selectionChanged() : ISignal
      {
         return this.layout.getSelectionChanged();
      }
      
      public function getSelectedIndex() : int
      {
         return this.layout.getSelectedIndex();
      }
      
      public function setSelectedIndex(param1:int) : void
      {
         this.layout.setSelectedIndex(param1);
      }
      
      public function getSelectedIndexes() : Array
      {
         return this.layout.getSelectedIndexes();
      }
      
      public function setSelectedIndexes(param1:Array) : void
      {
         this.layout.setSelectedIndexes(param1);
      }
      
      public function get allowMultiSelection() : Boolean
      {
         return this.layout.allowMultiSelection;
      }
      
      public function set allowMultiSelection(param1:Boolean) : void
      {
         this.layout.allowMultiSelection = param1;
      }
      
      public function set resizeBg(param1:Boolean) : void
      {
         this._listView.resizeBg = param1;
      }
      
      public function get allowVariableSpan() : Boolean
      {
         return this._allowVariableSpan;
      }
      
      public function set allowVariableSpan(param1:Boolean) : void
      {
         var _loc2_:Signal = null;
         if(param1 != this._allowVariableSpan || !this.layout)
         {
            this._allowVariableSpan = param1;
            _loc2_ = Boolean(this.layout) ? this.layout.getSelectionChanged() as Signal : null;
            if(this._allowVariableSpan)
            {
               this.layout = new ListLayoutSmoothVariableNonVirtual(this._listView,_loc2_);
            }
            else
            {
               this.layout = new ListLayoutSmoothFixedVirtual(this._listView,_loc2_);
            }
         }
      }
      
      protected function onViewReset() : void
      {
         this._listView.render.add(this.onRender);
      }
      
      protected function onRender() : void
      {
         this.scrollbar.pageSize = this._listView.getPageSize();
         this._listView.render.remove(this.onRender);
      }
      
      protected function wire(param1:String, param2:Class = null) : *
      {
         if(param2 == null)
         {
            param2 = SpriteProxy;
         }
         var _loc3_:DisplayObjectProxy = new param2(this);
         setTimelineChildByName(param1,_loc3_);
         return _loc3_;
      }
   }
}

