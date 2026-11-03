package mx.containers.utilityClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.IInvalidating;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Exclude(name="container",kind="property")]
   public class ConstraintColumn extends EventDispatcher implements IMXMLObject
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      mx_internal var contentSize:Boolean = false;
      
      private var _container:IInvalidating;
      
      private var _id:String;
      
      private var _explicitMaxWidth:Number;
      
      private var _explicitMinWidth:Number;
      
      mx_internal var _width:Number;
      
      private var _explicitWidth:Number;
      
      private var _percentWidth:Number;
      
      private var _x:Number;
      
      public function ConstraintColumn()
      {
         super();
      }
      
      public function get container() : IInvalidating
      {
         return this._container;
      }
      
      public function set container(value:IInvalidating) : void
      {
         this._container = value;
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
      [Bindable("maxWidthChanged")]
      public function get maxWidth() : Number
      {
         return !isNaN(this._explicitMaxWidth) ? this._explicitMaxWidth : 10000;
      }
      
      public function set maxWidth(value:Number) : void
      {
         if(this._explicitMaxWidth != value)
         {
            this._explicitMaxWidth = value;
            if(Boolean(this.container))
            {
               this.container.invalidateSize();
               this.container.invalidateDisplayList();
            }
            dispatchEvent(new Event("maxWidthChanged"));
         }
      }
      
      [Inspectable(category="Size",defaultValue="0")]
      [Bindable("minWidthChanged")]
      public function get minWidth() : Number
      {
         return !isNaN(this._explicitMinWidth) ? this._explicitMinWidth : 0;
      }
      
      public function set minWidth(value:Number) : void
      {
         if(this._explicitMinWidth != value)
         {
            this._explicitMinWidth = value;
            if(Boolean(this.container))
            {
               this.container.invalidateSize();
               this.container.invalidateDisplayList();
            }
            dispatchEvent(new Event("minWidthChanged"));
         }
      }
      
      [PercentProxy("percentWidth")]
      [Inspectable(category="General")]
      [Bindable("widthChanged")]
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(value:Number) : void
      {
         if(this.explicitWidth != value)
         {
            this.explicitWidth = value;
            if(this._width != value)
            {
               this._width = value;
               if(!isNaN(this._width))
               {
                  this.contentSize = false;
               }
               if(Boolean(this.container))
               {
                  this.container.invalidateSize();
                  this.container.invalidateDisplayList();
               }
               dispatchEvent(new Event("widthChanged"));
            }
         }
      }
      
      [Bindable("explicitWidthChanged")]
      [Inspectable(environment="none")]
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function set explicitWidth(value:Number) : void
      {
         if(this._explicitWidth == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._percentWidth = NaN;
         }
         this._explicitWidth = value;
         if(Boolean(this.container))
         {
            this.container.invalidateSize();
            this.container.invalidateDisplayList();
         }
         dispatchEvent(new Event("explicitWidthChanged"));
      }
      
      [Inspectable(environment="none")]
      [Bindable("percentWidthChanged")]
      public function get percentWidth() : Number
      {
         return this._percentWidth;
      }
      
      public function set percentWidth(value:Number) : void
      {
         if(this._percentWidth == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this._explicitWidth = NaN;
         }
         this._percentWidth = value;
         if(!isNaN(this._percentWidth))
         {
            this.contentSize = false;
         }
         if(Boolean(this.container))
         {
            this.container.invalidateSize();
            this.container.invalidateDisplayList();
         }
         dispatchEvent(new Event("percentWidthChanged"));
      }
      
      [Bindable("xChanged")]
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(value:Number) : void
      {
         if(value != this._x)
         {
            this._x = value;
            dispatchEvent(new Event("xChanged"));
         }
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
         if(!this.width && !this.percentWidth)
         {
            this.contentSize = true;
         }
      }
      
      public function setActualWidth(w:Number) : void
      {
         if(this._width != w)
         {
            this._width = w;
            dispatchEvent(new Event("widthChanged"));
         }
      }
   }
}

