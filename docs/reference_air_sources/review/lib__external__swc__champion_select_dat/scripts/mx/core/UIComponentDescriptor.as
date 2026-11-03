package mx.core
{
   use namespace mx_internal;
   
   public class UIComponentDescriptor extends ComponentDescriptor
   {
      
      public var effects:Array;
      
      public var stylesFactory:Function;
      
      mx_internal var instanceIndices:Array;
      
      mx_internal var repeaters:Array;
      
      mx_internal var repeaterIndices:Array;
      
      public function UIComponentDescriptor(descriptorProperties:Object)
      {
         super(descriptorProperties);
      }
      
      override public function toString() : String
      {
         return "UIComponentDescriptor_" + id;
      }
   }
}

