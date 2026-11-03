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
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      mx_internal var contentSize:Boolean = false;
      
      private var _baseline:Object = "maxAscent:0";
      
      private var _container:IInvalidating;
      
      mx_internal var _height:Number;
      
      private var _explicitHeight:Number;
      
      private var _id:String;
      
      private var _explicitMaxHeight:Number;
      
      private var _explicitMinHeight:Number;
      
      private var _percentHeight:Number;
      
      private var _y:Number;
      
      public function ConstraintRow()
      {
         super();
      }
      
      [Inspectable(category="General")]
      [Bindable("baselineChanged")]
      public function get baseline() : Object
      {
         return this._baseline;
      }
      
      public function set baseline(value:Object) : void
      {
         if(this._baseline != value)
         {
            this._baseline = value;
            if(Boolean(this.container))
            {
               this.container.invalidateSize();
               this.container.invalidateDisplayList();
            }
            dispatchEvent(new Event("baselineChanged"));
         }
      }
      
      public function get container() : IInvalidating
      {
         return this._container;
      }
      
      public function set container(value:IInvalidating) : void
      {
         this._container = value;
      }
      
      [PercentProxy("percentHeight")]
      [Inspectable(category="General")]
      [Bindable("heightChanged")]
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set height(value:Number) : void
      {
         if(this.explicitHeight != value)
         {
            this.explicitHeight = value;
            if(this._height != value)
            {
               this._height = value;
               if(!isNaN(this._height))
               {
                  this.contentSize = false;
               }
               if(Boolean(this.container))
               {
                  this.container.invalidateSize();
                  this.container.invalidateDisplayList();
               }
               dispatchEvent(new Event("heightChanged"));
            }
         }
      }
      
      [Bindable("explicitHeightChanged")]
      [Inspectable(environment="none")]
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      public function set explicitHeight(value:Number) : void
      {
         if(this._explicitHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._percentHeight = NaN;
         }
         this._explicitHeight = value;
         if(Boolean(this.container))
         {
            this.container.invalidateSize();
            this.container.invalidateDisplayList();
         }
         dispatchEvent(new Event("explicitHeightChanged"));
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
      }
      
      [Inspectable(category="Size",defaultValue="10000")]
      [Bindable("maxHeightChanged")]
      public function get maxHeight() : Number
      {
         return !isNaN(this._explicitMaxHeight) ? this._explicitMaxHeight : 10000;
      }
      
      public function set maxHeight(value:Number) : void
      {
         if(this._explicitMaxHeight != value)
         {
            this._explicitMaxHeight = value;
            if(Boolean(this.container))
            {
               this.container.invalidateSize();
               this.container.invalidateDisplayList();
            }
            dispatchEvent(new Event("maxHeightChanged"));
         }
      }
      
      [Inspectable(category="Size",defaultValue="0")]
      [Bindable("minHeightChanged")]
      public function get minHeight() : Number
      {
         return !isNaN(this._explicitMinHeight) ? this._explicitMinHeight : 0;
      }
      
      public function set minHeight(value:Number) : void
      {
         if(this._explicitMinHeight != value)
         {
            this._explicitMinHeight = value;
            if(Boolean(this.container))
            {
               this.container.invalidateSize();
               this.container.invalidateDisplayList();
            }
            dispatchEvent(new Event("minHeightChanged"));
         }
      }
      
      [Inspectable(environment="none")]
      [Bindable("percentHeightChanged")]
      public function get percentHeight() : Number
      {
         return this._percentHeight;
      }
      
      public function set percentHeight(value:Number) : void
      {
         if(this._percentHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._explicitHeight = NaN;
         }
         this._percentHeight = value;
         if(!isNaN(this._percentHeight))
         {
            this.contentSize = false;
         }
         if(Boolean(this.container))
         {
            this.container.invalidateSize();
            this.container.invalidateDisplayList();
         }
      }
      
      [Bindable("yChanged")]
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(value:Number) : void
      {
         if(value != this._y)
         {
            this._y = value;
            dispatchEvent(new Event("yChanged"));
         }
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
         if(!this.height && !this.percentHeight)
         {
            this.contentSize = true;
         }
      }
      
      public function setActualHeight(h:Number) : void
      {
         if(this._height != h)
         {
            this._height = h;
            dispatchEvent(new Event("heightChanged"));
         }
      }
   }
}

