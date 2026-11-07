package spark.components.gridClasses
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.collections.IList;
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import spark.components.ComboBox;
   import spark.events.DropDownEvent;
   import spark.primitives.Rect;
   
   public class ComboBoxGridItemEditor extends GridItemEditor implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1391998104bgFill:SolidColor;
      
      private var _1391644727bgRect:Rect;
      
      private var _612318883comboBox:ComboBox;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _dataProvider:IList;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      public function ComboBoxGridItemEditor()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._ComboBoxGridItemEditor_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_components_gridClasses_ComboBoxGridItemEditorWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ComboBoxGridItemEditor[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._ComboBoxGridItemEditor_Rect1_i(),this._ComboBoxGridItemEditor_ComboBox1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ComboBoxGridItemEditor._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function get value() : Object
      {
         return this.comboBox.selectedItem;
      }
      
      override public function set value(newValue:Object) : void
      {
         this.comboBox.selectedItem = newValue;
      }
      
      [Bindable("comboBoxGridItemEditorDataProviderChanged")]
      public function get dataProvider() : IList
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(value:IList) : void
      {
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         dispatchEvent(new Event("comboBoxGridItemEditorDataProviderChanged"));
      }
      
      override public function prepare() : void
      {
         super.prepare();
         this.comboBox.addEventListener(DropDownEvent.OPEN,this.dropDown_openHandler);
         this.comboBox.openDropDown();
      }
      
      override public function setFocus() : void
      {
         this.comboBox.setFocus();
      }
      
      private function dropDown_openHandler(event:DropDownEvent) : void
      {
         if(Boolean(this.comboBox.dataGroup))
         {
            this.comboBox.dataGroup.addEventListener(MouseEvent.MOUSE_DOWN,this.dataGroup_mouseClickHandler,false,0,true);
         }
      }
      
      private function dataGroup_mouseClickHandler(event:MouseEvent) : void
      {
         callLater(dataGrid.endItemEditorSession);
      }
      
      private function _ComboBoxGridItemEditor_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.top = 1;
         _loc1_.left = 1;
         _loc1_.bottom = 1;
         _loc1_.right = 1;
         _loc1_.fill = this._ComboBoxGridItemEditor_SolidColor1_i();
         _loc1_.initialized(this,"bgRect");
         this.bgRect = _loc1_;
         BindingManager.executeBindings(this,"bgRect",this.bgRect);
         return _loc1_;
      }
      
      private function _ComboBoxGridItemEditor_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.bgFill = _loc1_;
         BindingManager.executeBindings(this,"bgFill",this.bgFill);
         return _loc1_;
      }
      
      private function _ComboBoxGridItemEditor_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.percentWidth = 100;
         _loc1_.id = "comboBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.comboBox = _loc1_;
         BindingManager.executeBindings(this,"comboBox",this.comboBox);
         return _loc1_;
      }
      
      private function _ComboBoxGridItemEditor_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"comboBox.dataProvider","dataProvider");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get bgFill() : SolidColor
      {
         return this._1391998104bgFill;
      }
      
      public function set bgFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1391998104bgFill;
         if(_loc2_ !== param1)
         {
            this._1391998104bgFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgFill",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bgRect() : Rect
      {
         return this._1391644727bgRect;
      }
      
      public function set bgRect(param1:Rect) : void
      {
         var _loc2_:Object = this._1391644727bgRect;
         if(_loc2_ !== param1)
         {
            this._1391644727bgRect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgRect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get comboBox() : ComboBox
      {
         return this._612318883comboBox;
      }
      
      public function set comboBox(param1:ComboBox) : void
      {
         var _loc2_:Object = this._612318883comboBox;
         if(_loc2_ !== param1)
         {
            this._612318883comboBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"comboBox",_loc2_,param1));
            }
         }
      }
   }
}

