package mx.core
{
   public interface IDeferredInstantiationUIComponent extends IUIComponent
   {
      
      function get descriptor() : UIComponentDescriptor;
      
      function createReferenceOnParentDocument(param1:IFlexDisplayObject) : void;
      
      function set descriptor(param1:UIComponentDescriptor) : void;
      
      function deleteReferenceOnParentDocument(param1:IFlexDisplayObject) : void;
      
      function executeBindings(param1:Boolean = false) : void;
      
      function get id() : String;
      
      function set cacheHeuristic(param1:Boolean) : void;
      
      function get cachePolicy() : String;
      
      function registerEffects(param1:Array) : void;
      
      function set id(param1:String) : void;
   }
}

