package com.riotgames.rust.components.dropdown
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.rust.components.list.List;
   import com.riotgames.rust.components.list.renderer.DefaultListItem;
   import com.riotgames.rust.components.list.renderer.ILabelFieldContext;
   import com.riotgames.rust.context.popup.IPopupContext;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Dropdown extends SpriteProxy implements ILabelFieldContext
   {
      
      public var listRenderer:Class = DefaultListItem;
      
      public var listLinkage:String;
      
      public var listRendererLinkage:String;
      
      public var button:ButtonX;
      
      public var list:List;
      
      private var _buttonType:Class;
      
      private var _data:Array;
      
      private var _selectedIndex:int;
      
      private var _labelField:String = "label";
      
      public var selectionChanged:Signal = new Signal();
      
      private var isShowingList:Boolean = false;
      
      public function Dropdown(param1:IContext, param2:Class = null)
      {
         this._buttonType = param2;
         super(param1);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override protected function createChildren() : void
      {
         this.createButton();
         this.list = new List(this);
         this.list.allowMultiSelection = false;
         this.list.selectionChanged.add(this.onSelectionChanged);
         this.list.addEventListener(Event.ADDED_TO_STAGE,this.onListAddedToStage);
         this.list.addEventListener(Event.REMOVED_FROM_STAGE,this.onListRemoved);
         this.list.labelField = this._labelField;
         this.button.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
      }
      
      public function set labelField(param1:String) : void
      {
         this._labelField = param1;
         if(Boolean(this.list))
         {
            this.list.labelField = this.labelField;
         }
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         this._selectedIndex = param1;
         this.button.setData(this._data[this._selectedIndex]);
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         if(Boolean(this._data) && this._data.length > 0)
         {
            this.selectedIndex = 0;
         }
      }
      
      private function onButtonDown(param1:MouseEvent) : void
      {
         if(!this.isShowingList)
         {
            this.showList();
         }
         else
         {
            this.hideList();
         }
      }
      
      protected function showList() : void
      {
         this.createList();
         this.list.data = this.data;
         this.isShowingList = true;
         this.button.setSelected(true);
         var _loc1_:IPopupContext = getFirstContext(IPopupContext);
         _loc1_.addPopup(this.list);
         _loc1_.setPosition(this.list,this,this.button.getX(),this.button.getY() + this.button.getHeight());
         invalidateLayout();
      }
      
      public function getBoundsWithDropDown() : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc1_:Rectangle = this.button.getBounds(null);
         if(this.isShowingList)
         {
            _loc2_ = this.list.getBounds(null);
            return new Rectangle(Math.min(_loc1_.x,_loc2_.x),Math.min(_loc1_.y,_loc2_.y),Math.max(_loc1_.width,_loc2_.width),Math.max(_loc1_.height,_loc2_.height));
         }
         return _loc1_;
      }
      
      private function onListAddedToStage(param1:Event) : void
      {
         this.list.getStage().addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDown);
      }
      
      private function onListRemoved(param1:Event) : void
      {
         this.list.getStage().removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDown);
      }
      
      private function onStageMouseDown(param1:MouseEvent) : void
      {
         if(!this.hitTestPoint(param1.stageX,param1.stageY,true) && !this.list.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            this.hideList();
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.hideList();
      }
      
      protected function onSelectionChanged() : void
      {
         this.selectedIndex = this.list.getSelectedIndex();
         this.hideList();
         this.selectionChanged.dispatch(this);
      }
      
      protected function hideList() : void
      {
         var _loc1_:IPopupContext = getFirstContext(IPopupContext);
         _loc1_.removePopup(this.list);
         this.button.setSelected(false);
         this.isShowingList = false;
         invalidateLayout();
      }
      
      protected function createButton() : void
      {
         if(this._buttonType == null)
         {
            this._buttonType = DefaultListItem;
         }
         this.button = this.wire("button",this._buttonType);
      }
      
      protected function createList() : void
      {
         if(Boolean(this.listLinkage))
         {
            this.list.setLinkage(this.listLinkage);
         }
         this.list.listView.rendererType = this.listRenderer;
         if(Boolean(this.listRendererLinkage))
         {
            this.list.listView.rendererLinkage = this.listRendererLinkage;
         }
      }
      
      public function set resizeBg(param1:Boolean) : void
      {
         this.list.resizeBg = param1;
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

