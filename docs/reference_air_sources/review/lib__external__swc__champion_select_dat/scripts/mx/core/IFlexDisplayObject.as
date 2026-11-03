package mx.core
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.IBitmapDrawable;
   import flash.events.IEventDispatcher;
   
   public interface IFlexDisplayObject extends IBitmapDrawable, IEventDispatcher
   {
      
      function get name() : String;
      
      function set width(param1:Number) : void;
      
      function get measuredHeight() : Number;
      
      function set height(param1:Number) : void;
      
      function get scaleY() : Number;
      
      function move(param1:Number, param2:Number) : void;
      
      function get scaleX() : Number;
      
      function set mask(param1:DisplayObject) : void;
      
      function set scaleX(param1:Number) : void;
      
      function set name(param1:String) : void;
      
      function set scaleY(param1:Number) : void;
      
      function get visible() : Boolean;
      
      function get measuredWidth() : Number;
      
      function set visible(param1:Boolean) : void;
      
      function get alpha() : Number;
      
      function get height() : Number;
      
      function get width() : Number;
      
      function get parent() : DisplayObjectContainer;
      
      function get mask() : DisplayObject;
      
      function set x(param1:Number) : void;
      
      function setActualSize(param1:Number, param2:Number) : void;
      
      function set y(param1:Number) : void;
      
      function get x() : Number;
      
      function get y() : Number;
      
      function set alpha(param1:Number) : void;
   }
}

