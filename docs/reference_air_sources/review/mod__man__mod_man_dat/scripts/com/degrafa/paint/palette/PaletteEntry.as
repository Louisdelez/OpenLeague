package com.degrafa.paint.palette
{
   import com.degrafa.core.DegrafaObject;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class PaletteEntry extends DegrafaObject
   {
      
      protected var typeName:String;
      
      private var _value:Object;
      
      private var _name:String;
      
      protected var type:Class;
      
      public function PaletteEntry(param1:String = undefined, param2:Object = null)
      {
         super();
         this.name = param1;
         this.value = param2;
      }
      
      public function set value(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(_value != param1)
         {
            _loc2_ = _value;
            _value = param1;
            typeName = getQualifiedClassName(_value);
            typeName = typeName.replace("::",".");
            type = Class(getDefinitionByName(typeName));
            initChange("value",_loc2_,_value,this);
         }
      }
      
      override public function get name() : String
      {
         return _name;
      }
      
      public function get value() : Object
      {
         return _value;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
   }
}

