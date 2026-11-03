package spark.skins.spark
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import spark.components.Group;
   import spark.components.supportClasses.ItemRenderer;
   
   public class DefaultComplexItemRenderer extends ItemRenderer
   {
      
      private var _809612678contentGroup:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DefaultComplexItemRenderer()
      {
         super();
         mx_internal::_document = this;
         this.autoDrawBackground = true;
         this.mxmlContent = [this._DefaultComplexItemRenderer_Group1_i()];
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
      
      [Bindable("dataChanged")]
      override public function set data(value:Object) : void
      {
         var i:int = 0;
         super.data = value;
         this.contentGroup.removeAllElements();
         if(value is Array)
         {
            for(i = 0; i < value.length; i++)
            {
               this.contentGroup.addElement(IVisualElement(value[i]));
            }
         }
         else if(value is IVisualElement)
         {
            this.contentGroup.addElement(IVisualElement(value));
         }
      }
      
      private function _DefaultComplexItemRenderer_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.verticalCenter = 0;
         _loc1_.left = 2;
         _loc1_.right = 2;
         _loc1_.top = 2;
         _loc1_.bottom = 2;
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get contentGroup() : Group
      {
         return this._809612678contentGroup;
      }
      
      public function set contentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
   }
}

