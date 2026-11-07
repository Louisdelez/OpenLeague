package mx.controls.listClasses
{
   import flash.events.EventDispatcher;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class BaseListData extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      [Bindable("__NoChangeEvent__")]
      public var columnIndex:int;
      
      [Bindable("__NoChangeEvent__")]
      public var label:String;
      
      [Bindable("__NoChangeEvent__")]
      public var owner:IUIComponent;
      
      [Bindable("__NoChangeEvent__")]
      public var rowIndex:int;
      
      private var _uid:String;
      
      public function BaseListData(label:String, uid:String, owner:IUIComponent, rowIndex:int = 0, columnIndex:int = 0)
      {
         super();
         this.label = label;
         this.uid = uid;
         this.owner = owner;
         this.rowIndex = rowIndex;
         this.columnIndex = columnIndex;
      }
      
      [Bindable("__NoChangeEvent__")]
      public function get uid() : String
      {
         return this._uid;
      }
      
      public function set uid(value:String) : void
      {
         this._uid = value;
      }
   }
}

