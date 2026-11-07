package blix.components.dropdown
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.list.IRendererFactory;
   import blix.components.list.RendererFactory;
   import blix.components.list.SelectionBehavior;
   import blix.components.renderer.SelectableRenderer;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.layout.LayoutEntry;
   import blix.layout.data.SizeLayoutData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class DropDown extends LabelButtonX
   {
      
      private var _stageWatch:Stage;
      
      private var _defaultRendererFactory:RendererFactory;
      
      protected var _dropDownList:DropDownList;
      
      private var _noneSelectedLabel:String;
      
      private var _labelFunction:Function;
      
      private var _labelField:String;
      
      private var _listRendererLinkage:String = "DropDownRenderer";
      
      private var stageProxy:DisplayObjectContainerProxy;
      
      private var listContainer:DisplayObjectContainerProxy;
      
      public function DropDown(param1:IContext)
      {
         super(param1);
         this.initializeUi();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:SizeLayoutData = null;
         super.createChildren();
         if(this._dropDownList == null)
         {
            this._dropDownList = new DropDownList(this);
            this._dropDownList.setLinkage("DropDownList");
         }
         this._dropDownList.getDataScroller().getSelectionBehavior().allowMultipleSelection = false;
         this._dropDownList.getDataScroller().getSelectionBehavior().getSelectedItemsChanged().add(this.selectedItemsChangedHandler);
         if(this._defaultRendererFactory == null)
         {
            _loc1_ = new SizeLayoutData();
            _loc1_.setWidthPercent(1);
            this._defaultRendererFactory = new RendererFactory(SelectableRenderer,[this],_loc1_);
            this._defaultRendererFactory.getEntryConstructed().add(this.defaultRendererConstructedHandler);
         }
         this.stageProxy = new DisplayObjectContainerProxy(this);
         this.listContainer = new DisplayObjectContainerProxy(this,new Sprite());
         this.stageProxy.addChild(this.listContainer);
      }
      
      override protected function setIsOnStage(param1:Boolean) : void
      {
         super.setIsOnStage(param1);
         this.stageProxy.setAsset(_stage);
      }
      
      protected function defaultRendererConstructedHandler(param1:LayoutEntry, param2:*) : void
      {
         if(!(param1.element is SelectableRenderer))
         {
            return;
         }
         var _loc3_:SelectableRenderer = param1.element as SelectableRenderer;
         _loc3_.setLinkage(this._listRendererLinkage);
         _loc3_.setLabelField(this._labelField);
         _loc3_.setLabelFunction(this._labelFunction);
      }
      
      protected function selectedItemsChangedHandler() : void
      {
         this.refreshLabel();
         if(!this._dropDownList.getDataScroller().getSelectionBehavior().allowMultipleSelection)
         {
            this.close();
         }
      }
      
      protected function initializeUi() : void
      {
         getSelectedChanged().add(this.refreshListVisibility);
         getIsOnStageChanged().add(this.refreshListVisibility);
         addEventListener(MouseEvent.CLICK,this.dropDownClickHandler);
      }
      
      protected function dropDownClickHandler(param1:MouseEvent) : void
      {
         setSelected(!getSelected());
      }
      
      protected function refreshListVisibility() : void
      {
         if(getSelected() && Boolean(getIsOnStage()))
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
         setTimeout(this.watchStage,10);
         if(this._dropDownList.getRendererFactory() == null)
         {
            this._dropDownList.setRendererFactory(this._defaultRendererFactory);
         }
         this.listContainer.addChild(this._dropDownList);
         this._dropDownList.show(this);
      }
      
      private function watchStage() : void
      {
         if(!this.getIsOpened())
         {
            return;
         }
         this._stageWatch = _stage;
         if(this._stageWatch != null)
         {
            this._stageWatch.addEventListener(MouseEvent.CLICK,this.stageClickHandler,false,0,true);
         }
      }
      
      protected function hideList() : void
      {
         if(Boolean(this._stageWatch))
         {
            this._stageWatch.removeEventListener(MouseEvent.CLICK,this.stageClickHandler);
            this._stageWatch = null;
         }
         this._dropDownList.hide();
         this.listContainer.removeChild(this._dropDownList);
      }
      
      private function stageClickHandler(param1:MouseEvent) : void
      {
         if(this._dropDownList.owns(param1.target as DisplayObject))
         {
            return;
         }
         this.close();
      }
      
      public function getListLinkage() : String
      {
         return this._dropDownList.getLinkage();
      }
      
      public function setListLinkage(param1:String) : void
      {
         this._dropDownList.setLinkage(param1);
      }
      
      public function getListRendererLinkage() : String
      {
         return this._listRendererLinkage;
      }
      
      public function setListRendererLinkage(param1:String) : void
      {
         this._listRendererLinkage = param1;
         this._dropDownList.invalidateRendererCache();
      }
      
      public function getIsOpened() : Boolean
      {
         return getSelected();
      }
      
      public function getDropDownList() : DropDownList
      {
         return this._dropDownList;
      }
      
      public function open() : void
      {
         setSelected(true);
      }
      
      public function close() : void
      {
         setSelected(false);
      }
      
      public function getDataProvider() : IListX
      {
         return this._dropDownList.getDataScroller().getDataProvider();
      }
      
      public function setDataProvider(param1:IListX) : void
      {
         this._dropDownList.getDataScroller().setDataProvider(param1);
      }
      
      public function getRendererFactory() : IRendererFactory
      {
         return this._dropDownList.getRendererFactory();
      }
      
      public function getDefaultRendererFactory() : RendererFactory
      {
         return this._defaultRendererFactory;
      }
      
      public function setRendererFactory(param1:IRendererFactory) : void
      {
         this._dropDownList.setRendererFactory(param1);
      }
      
      public function setNoneSelectedLabel(param1:String) : void
      {
         this._noneSelectedLabel = param1;
         this.refreshLabel();
      }
      
      public function getLabelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function setLabelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.refreshLabel();
      }
      
      public function getLabelField() : String
      {
         return this._labelField;
      }
      
      public function setLabelField(param1:String) : void
      {
         if(this._labelField == param1)
         {
            return;
         }
         if(param1 == "")
         {
            param1 = null;
         }
         this._labelField = param1;
         this.refreshLabel();
      }
      
      protected function refreshLabel() : void
      {
         var _loc1_:Object = null;
         if(this._labelFunction != null)
         {
            this._labelFunction(this._dropDownList.getDataScroller().getSelectionBehavior());
         }
         else
         {
            _loc1_ = this._dropDownList.getDataScroller().getSelectionBehavior().getSelectedItem();
            if(_loc1_ == null)
            {
               setText(this._noneSelectedLabel || "");
            }
            else if(this._labelField != null)
            {
               setText(_loc1_[this._labelField]);
            }
            else
            {
               setText(_loc1_.toString());
            }
         }
      }
      
      public function getSelectionBehavior() : SelectionBehavior
      {
         return this._dropDownList.getDataScroller().getSelectionBehavior();
      }
      
      override public function destroy() : void
      {
         this.close();
         this.stageProxy.destroy();
         this._dropDownList.destroy();
         this._defaultRendererFactory.destroy();
         super.destroy();
      }
   }
}

