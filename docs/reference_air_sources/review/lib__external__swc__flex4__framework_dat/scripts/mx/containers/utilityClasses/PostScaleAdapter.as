package mx.containers.utilityClasses
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import mx.core.FlexVersion;
   import mx.core.IConstraintClient;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.managers.ISystemManager;
   
   public class PostScaleAdapter implements IUIComponent, IConstraintClient, IInvalidating
   {
      
      private var obj:IUIComponent;
      
      public function PostScaleAdapter(obj:IUIComponent)
      {
         super();
         this.obj = obj;
      }
      
      public static function getCompatibleIUIComponent(obj:Object) : IUIComponent
      {
         var uic:IUIComponent = obj as IUIComponent;
         if(!uic)
         {
            return null;
         }
         if(uic.scaleX == 1 && uic.scaleY == 1 || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            return uic;
         }
         if(uic is PostScaleAdapter)
         {
            return uic;
         }
         return new PostScaleAdapter(uic);
      }
      
      public function get baselinePosition() : Number
      {
         return this.obj.baselinePosition;
      }
      
      public function get document() : Object
      {
         return this.obj.document;
      }
      
      public function set document(value:Object) : void
      {
         this.obj.document = value;
      }
      
      public function get enabled() : Boolean
      {
         return this.obj.enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         this.obj.enabled = value;
      }
      
      public function get explicitHeight() : Number
      {
         return this.obj.explicitHeight * Math.abs(this.obj.scaleY);
      }
      
      public function set explicitHeight(value:Number) : void
      {
         this.obj.explicitHeight = this.obj.scaleY == 0 ? 0 : value / Math.abs(this.obj.scaleY);
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this.obj.explicitMaxHeight * Math.abs(this.obj.scaleY);
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this.obj.explicitMaxWidth * Math.abs(this.obj.scaleX);
      }
      
      public function get explicitMinHeight() : Number
      {
         return this.obj.explicitMinHeight * Math.abs(this.obj.scaleY);
      }
      
      public function get explicitMinWidth() : Number
      {
         return this.obj.explicitMinWidth * Math.abs(this.obj.scaleX);
      }
      
      public function get explicitWidth() : Number
      {
         return this.obj.explicitWidth * Math.abs(this.obj.scaleX);
      }
      
      public function set explicitWidth(value:Number) : void
      {
         this.obj.explicitWidth = this.obj.scaleX == 0 ? 0 : value / Math.abs(this.obj.scaleX);
      }
      
      public function get focusPane() : Sprite
      {
         return this.obj.focusPane;
      }
      
      public function set focusPane(value:Sprite) : void
      {
         this.obj.focusPane = value;
      }
      
      public function get includeInLayout() : Boolean
      {
         return this.obj.includeInLayout;
      }
      
      public function set includeInLayout(value:Boolean) : void
      {
         this.obj.includeInLayout = value;
      }
      
      public function get isPopUp() : Boolean
      {
         return this.obj.isPopUp;
      }
      
      public function set isPopUp(value:Boolean) : void
      {
         this.obj.isPopUp = value;
      }
      
      public function get maxHeight() : Number
      {
         return this.obj.maxHeight * Math.abs(this.obj.scaleY);
      }
      
      public function get maxWidth() : Number
      {
         return this.obj.maxWidth * Math.abs(this.obj.scaleX);
      }
      
      public function get measuredMinHeight() : Number
      {
         return this.obj.measuredMinHeight * Math.abs(this.obj.scaleY);
      }
      
      public function set measuredMinHeight(value:Number) : void
      {
         this.obj.measuredMinHeight = this.obj.scaleY == 0 ? 0 : value / Math.abs(this.obj.scaleY);
      }
      
      public function get measuredMinWidth() : Number
      {
         return this.obj.measuredMinWidth * Math.abs(this.obj.scaleX);
      }
      
      public function set measuredMinWidth(value:Number) : void
      {
         this.obj.measuredMinWidth = this.obj.scaleX == 0 ? 0 : value / Math.abs(this.obj.scaleX);
      }
      
      public function get minHeight() : Number
      {
         return this.obj.minHeight * Math.abs(this.obj.scaleY);
      }
      
      public function get minWidth() : Number
      {
         return this.obj.minWidth * Math.abs(this.obj.scaleX);
      }
      
      public function get owner() : DisplayObjectContainer
      {
         return this.obj.owner;
      }
      
      public function set owner(value:DisplayObjectContainer) : void
      {
         this.obj.owner = value;
      }
      
      public function get percentHeight() : Number
      {
         return this.obj.percentHeight;
      }
      
      public function set percentHeight(value:Number) : void
      {
         this.obj.percentHeight = value;
      }
      
      public function get percentWidth() : Number
      {
         return this.obj.percentWidth;
      }
      
      public function set percentWidth(value:Number) : void
      {
         this.obj.percentWidth = value;
      }
      
      public function get systemManager() : ISystemManager
      {
         return this.obj.systemManager;
      }
      
      public function set systemManager(value:ISystemManager) : void
      {
         this.obj.systemManager = value;
      }
      
      public function get tweeningProperties() : Array
      {
         return this.obj.tweeningProperties;
      }
      
      public function set tweeningProperties(value:Array) : void
      {
         this.obj.tweeningProperties = value;
      }
      
      public function initialize() : void
      {
         this.obj.initialize();
      }
      
      public function parentChanged(p:DisplayObjectContainer) : void
      {
         this.obj.parentChanged(p);
      }
      
      public function getExplicitOrMeasuredWidth() : Number
      {
         return this.obj.getExplicitOrMeasuredWidth() * Math.abs(this.obj.scaleX);
      }
      
      public function getExplicitOrMeasuredHeight() : Number
      {
         return this.obj.getExplicitOrMeasuredHeight() * Math.abs(this.obj.scaleY);
      }
      
      public function setVisible(value:Boolean, noEvent:Boolean = false) : void
      {
         this.obj.setVisible(value,noEvent);
      }
      
      public function owns(displayObject:DisplayObject) : Boolean
      {
         return this.obj.owns(displayObject);
      }
      
      public function get measuredHeight() : Number
      {
         return this.obj.measuredHeight * Math.abs(this.obj.scaleY);
      }
      
      public function get measuredWidth() : Number
      {
         return this.obj.measuredWidth * Math.abs(this.obj.scaleX);
      }
      
      public function move(x:Number, y:Number) : void
      {
         this.obj.move(x,y);
      }
      
      public function setActualSize(newWidth:Number, newHeight:Number) : void
      {
         this.obj.setActualSize(this.obj.scaleX == 0 ? 0 : newWidth / Math.abs(this.obj.scaleX),this.obj.scaleY == 0 ? 0 : newHeight / Math.abs(this.obj.scaleY));
      }
      
      public function get root() : DisplayObject
      {
         return this.obj.root;
      }
      
      public function get stage() : Stage
      {
         return this.obj.stage;
      }
      
      public function get name() : String
      {
         return this.obj.name;
      }
      
      public function set name(value:String) : void
      {
         this.obj.name = value;
      }
      
      public function get parent() : DisplayObjectContainer
      {
         return this.obj.parent;
      }
      
      public function get mask() : DisplayObject
      {
         return this.obj.mask;
      }
      
      public function set mask(value:DisplayObject) : void
      {
         this.obj.mask = value;
      }
      
      public function get visible() : Boolean
      {
         return this.obj.visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this.obj.visible = value;
      }
      
      public function get x() : Number
      {
         return this.obj.x;
      }
      
      public function set x(value:Number) : void
      {
         this.obj.x = value;
      }
      
      public function get y() : Number
      {
         return this.obj.y;
      }
      
      public function set y(value:Number) : void
      {
         this.obj.y = value;
      }
      
      public function get scaleX() : Number
      {
         return this.obj.scaleX;
      }
      
      public function set scaleX(value:Number) : void
      {
         this.obj.scaleX = value;
      }
      
      public function get scaleY() : Number
      {
         return this.obj.scaleY;
      }
      
      public function set scaleY(value:Number) : void
      {
         this.obj.scaleY = value;
      }
      
      public function get mouseX() : Number
      {
         return this.obj.mouseX;
      }
      
      public function get mouseY() : Number
      {
         return this.obj.mouseY;
      }
      
      public function get rotation() : Number
      {
         return this.obj.rotation;
      }
      
      public function set rotation(value:Number) : void
      {
         this.obj.rotation = value;
      }
      
      public function get alpha() : Number
      {
         return this.obj.alpha;
      }
      
      public function set alpha(value:Number) : void
      {
         this.obj.alpha = value;
      }
      
      public function get width() : Number
      {
         return this.obj.width * Math.abs(this.obj.scaleX);
      }
      
      public function set width(value:Number) : void
      {
         this.obj.width = this.obj.scaleX == 0 ? 0 : value / Math.abs(this.obj.scaleX);
      }
      
      public function get height() : Number
      {
         return this.obj.height * Math.abs(this.obj.scaleY);
      }
      
      public function set height(value:Number) : void
      {
         this.obj.height = this.obj.scaleY == 0 ? 0 : value / Math.abs(this.obj.scaleY);
      }
      
      public function get cacheAsBitmap() : Boolean
      {
         return this.obj.cacheAsBitmap;
      }
      
      public function set cacheAsBitmap(value:Boolean) : void
      {
         this.obj.cacheAsBitmap = value;
      }
      
      public function get opaqueBackground() : Object
      {
         return this.obj.opaqueBackground;
      }
      
      public function set opaqueBackground(value:Object) : void
      {
         this.obj.opaqueBackground = value;
      }
      
      public function get scrollRect() : Rectangle
      {
         return this.obj.scrollRect;
      }
      
      public function set scrollRect(value:Rectangle) : void
      {
         this.obj.scrollRect = value;
      }
      
      public function get filters() : Array
      {
         return this.obj.filters;
      }
      
      public function set filters(value:Array) : void
      {
         this.obj.filters = value;
      }
      
      public function get blendMode() : String
      {
         return this.obj.blendMode;
      }
      
      public function set blendMode(value:String) : void
      {
         this.obj.blendMode = value;
      }
      
      public function get transform() : Transform
      {
         return this.obj.transform;
      }
      
      public function set transform(value:Transform) : void
      {
         this.obj.transform = value;
      }
      
      public function get scale9Grid() : Rectangle
      {
         return this.obj.scale9Grid;
      }
      
      public function set scale9Grid(innerRectangle:Rectangle) : void
      {
         this.obj.scale9Grid = innerRectangle;
      }
      
      public function globalToLocal(point:Point) : Point
      {
         return this.obj.globalToLocal(point);
      }
      
      public function localToGlobal(point:Point) : Point
      {
         return this.obj.localToGlobal(point);
      }
      
      public function getBounds(targetCoordinateSpace:DisplayObject) : Rectangle
      {
         return this.obj.getBounds(targetCoordinateSpace);
      }
      
      public function getRect(targetCoordinateSpace:DisplayObject) : Rectangle
      {
         return this.obj.getRect(targetCoordinateSpace);
      }
      
      public function get loaderInfo() : LoaderInfo
      {
         return this.obj.loaderInfo;
      }
      
      public function hitTestObject(obj:DisplayObject) : Boolean
      {
         return obj.hitTestObject(obj);
      }
      
      public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false) : Boolean
      {
         return this.hitTestPoint(x,y,shapeFlag);
      }
      
      public function get accessibilityProperties() : AccessibilityProperties
      {
         return this.obj.accessibilityProperties;
      }
      
      public function set accessibilityProperties(value:AccessibilityProperties) : void
      {
         this.obj.accessibilityProperties = value;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this.obj.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.obj.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.obj.hasEventListener(type);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.obj.removeEventListener(type,listener,useCapture);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.obj.willTrigger(type);
      }
      
      public function getConstraintValue(constraintName:String) : *
      {
         if(this.obj is IConstraintClient)
         {
            return IConstraintClient(this.obj).getConstraintValue(constraintName);
         }
         return null;
      }
      
      public function setConstraintValue(constraintName:String, value:*) : void
      {
         if(this.obj is IConstraintClient)
         {
            IConstraintClient(this.obj).setConstraintValue(constraintName,value);
            return;
         }
         throw new Error("PostScaleAdapter can\'t set constraint value, underlying object is not an IConstraintClient");
      }
      
      public function invalidateProperties() : void
      {
         if(this.obj is IInvalidating)
         {
            IInvalidating(this.obj).invalidateProperties();
         }
      }
      
      public function invalidateSize() : void
      {
         if(this.obj is IInvalidating)
         {
            IInvalidating(this.obj).invalidateSize();
         }
      }
      
      public function invalidateDisplayList() : void
      {
         if(this.obj is IInvalidating)
         {
            IInvalidating(this.obj).invalidateDisplayList();
         }
      }
      
      public function validateNow() : void
      {
         if(this.obj is IInvalidating)
         {
            IInvalidating(this.obj).validateNow();
         }
      }
   }
}

