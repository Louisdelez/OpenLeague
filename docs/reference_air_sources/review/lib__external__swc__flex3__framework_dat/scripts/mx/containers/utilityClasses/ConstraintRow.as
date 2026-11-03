package mx.containers.utilityClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.IInvalidating;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Exclude(name="container",kind="property")]
   public class ConstraintRow extends EventDispatcher implements IMXMLObject
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _container:IInvalidating;
      
      mx_internal var _height:Number;
      
      private var _explicitMinHeight:Number;
      
      private var _y:Number;
      
      private var _percentHeight:Number;
      
      private var _explicitMaxHeight:Number;
      
      mx_internal var contentSize:Boolean = false;
      
      private var _explicitHeight:Number;
      
      private var _id:String;
      
      public function ConstraintRow()
      {
         super();
      }
      
      public function get container() : IInvalidating
      {
         return _container;
      }
      
      public function set container(value:IInvalidating) : void
      {
         _container = value;
      }
      
      public function set y(value:Number) : void
      {
         if(value != _y)
         {
            _y = value;
            dispatchEvent(new Event("yChanged"));
         }
      }
      
      public function set height(value:Number) : void
      {
         if(explicitHeight != value)
         {
            explicitHeight = value;
            if(_height != value)
            {
               _height = value;
               if(Boolean(container))
               {
                  container.invalidateSize();
                  container.invalidateDisplayList();
               }
               dispatchEvent(new Event("heightChanged"));
            }
         }
      }
      
      public function set maxHeight(value:Number) : void
      {
         if(_explicitMaxHeight != value)
         {
            _explicitMaxHeight = value;
            if(Boolean(container))
            {
               container.invalidateSize();
               container.invalidateDisplayList();
            }
            dispatchEvent(new Event("maxHeightChanged"));
         }
      }
      
      public function setActualHeight(h:Number) : void
      {
         if(_height != h)
         {
            _height = h;
            dispatchEvent(new Event("heightChanged"));
         }
      }
      
      [Inspectable(category="Size",defaultValue="0")]
      [Bindable("minHeightChanged")]
      public function get minHeight() : Number
      {
         return _explicitMinHeight;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function set percentHeight(value:Number) : void
      {
         if(_percentHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            _explicitHeight = NaN;
         }
         _percentHeight = value;
         if(Boolean(container))
         {
            container.invalidateSize();
            container.invalidateDisplayList();
         }
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
         if(!this.height && !this.percentHeight)
         {
            contentSize = true;
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("percentHeightChanged")]
      public function get percentHeight() : Number
      {
         return _percentHeight;
      }
      
      [PercentProxy("percentHeight")]
      [Inspectable(category="General")]
      [Bindable("heightChanged")]
      public function get height() : Number
      {
         return _height;
      }
      
      [Inspectable(category="Size",defaultValue="10000")]
      [Bindable("maxHeightChanged")]
      public function get maxHeight() : Number
      {
         return _explicitMaxHeight;
      }
      
      public function set minHeight(value:Number) : void
      {
         if(_explicitMinHeight != value)
         {
            _explicitMinHeight = value;
            if(Boolean(container))
            {
               container.invalidateSize();
               container.invalidateDisplayList();
            }
            dispatchEvent(new Event("minHeightChanged"));
         }
      }
      
      public function set id(value:String) : void
      {
         _id = value;
      }
      
      [Bindable("yChanged")]
      public function get y() : Number
      {
         return _y;
      }
      
      [Bindable("explicitHeightChanged")]
      [Inspectable(environment="none")]
      public function get explicitHeight() : Number
      {
         return _explicitHeight;
      }
      
      public function set explicitHeight(value:Number) : void
      {
         if(_explicitHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            _percentHeight = NaN;
         }
         _explicitHeight = value;
         if(Boolean(container))
         {
            container.invalidateSize();
            container.invalidateDisplayList();
         }
         dispatchEvent(new Event("explicitHeightChanged"));
      }
   }
}

